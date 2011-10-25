# Controller generated by Typus, use it to extend admin functionality.
class Admin::ApartmentCommunitiesController < Admin::MasterController
  before_filter :fetch_item, :only => [:preview, :merge, :begin_merge, :end_merge]
  before_filter :verify_community_is_not_managed_by_vaultware, :only => [:merge, :begin_merge, :end_merge]
  before_filter :find_vaultware_community, :only => [:begin_merge, :end_merge]

  def list_deleted
    set_fields
    items_count = ApartmentCommunity::Archive.count
    items_per_page = ApartmentCommunity.typus_options_for(:per_page).to_i

    @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
      ApartmentCommunity::Archive.find(:all, :limit => per_page, :offset => offset, :order => 'title ASC').map {|item| 
        item.becomes(ApartmentCommunity)
      }
    end

    @items = @pager.page(params[:page])
    
    respond_to do |format|
      format.html
    end
  end
  
  def preview
    redirect_to apartment_community_url(@item)
  end

  def merge
    @vaultware_communities = ApartmentCommunity.managed_by_vaultware.all(:order => 'title ASC')
  end

  def begin_merge
  end

  def end_merge
    @item.merge(@vaultware_community)
    flash[:notice] = 'Successfully merged communities'
    redirect_to url_for_action(:edit)
  end


  private

  def fetch_item
    # have to make a new method because there's already a before_filter for #find_item
    find_item
  end

  def verify_community_is_not_managed_by_vaultware
    if @item.managed_by_vaultware?
      flash[:error] = 'This community is already managed by Vaultware'
      redirect_to url_for_action(:edit)
    end
  end

  def find_vaultware_community
    if params[:vaultware_community_id].blank?
      flash[:error] = 'You must select a Vaultware-managed community.'
      redirect_to url_for_action(:merge)
    else
      @vaultware_community = ApartmentCommunity.managed_by_vaultware.find_by_id(params[:vaultware_community_id])

      if @vaultware_community.nil?
        flash[:error] = "Couldn't find that Vaultware community."
        redirect_to url_for_action(:merge)
      end
    end
  end

  def url_for_action(action)
    {
      :controller => 'admin/apartment_communities',
      :action     => action,
      :id         => @item.id
    }
  end
  helper_method :url_for_action
end
