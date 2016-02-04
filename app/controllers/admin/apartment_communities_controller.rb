# Controller generated by Typus, use it to extend admin functionality.
class Admin::ApartmentCommunitiesController < Admin::MasterController
  before_filter :fetch_item, :only => [:preview, :merge, :begin_merge, :end_merge, :disconnect, :delete_floor_plans]
  before_filter :verify_community_is_not_managed_externally, :only => [:merge, :begin_merge, :end_merge]
  before_filter :find_external_community, :only => [:begin_merge, :end_merge]

  def list_deleted
    set_fields
    items_count = ApartmentCommunity::Archive.count
    items_per_page = ApartmentCommunity.typus_options_for(:per_page).to_i

    @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
      ApartmentCommunity::Archive.find(:all, :limit => per_page, :offset => offset, :order => 'title ASC').map {|item|
        item.becomes(ApartmentCommunity)
      }
    end

    @items = @pager.page(page_number)

    respond_to do |format|
      format.html
    end
  end

  def list_duplicates
    @fields = @resource[:class].typus_fields_for('list')

    duplicates = ApartmentCommunity.duplicates

    items_count = duplicates.count
    items_per_page = ApartmentCommunity.typus_options_for(:per_page).to_i

    @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
      duplicates.all(:limit => per_page, :offset => offset)
    end

    @items = @pager.page(page_number)

    respond_to do |format|
      format.html
    end
  end

  def preview
    redirect_to apartment_community_url(@item, :preview => true)
  end

  def merge
    @options = [].tap do |options|
      Bozzuto::ExternalFeed::Feed.feed_types.sort.each do |type|
        loader = Bozzuto::ExternalFeed::Loader.loader_for_type(type)

        communities = ApartmentCommunity.all(:conditions => { :external_cms_type => type }, :order => 'title ASC')

        if communities.any?
          options << [loader.feed_name, communities.map { |c| [c.title, c.id] }]
        end
      end
    end
  end

  def begin_merge
  end

  def end_merge
    @item.merge(@external_community)
    flash[:notice] = 'Successfully merged communities'
    redirect_to url_for_action(:edit)
  end

  def export_field_audit
    csv_string = Bozzuto::ApartmentCommunityFieldAudit.audit_csv
    send_data csv_string, :filename => "apartment_communities_field_audit.csv", :type => :csv
  end

  def export_dnr
    send_file Bozzuto::DnrCsv.new(:conditions => { :published => true }).file
  end

  def disconnect
    feed_name = @item.external_cms_name

    @item.disconnect_from_external_cms!

    redirect_to url_for_action(:edit), :notice => "Successfully disconnected from #{feed_name}"
  end

  def delete_floor_plans
    @item.floor_plans.destroy_all

    redirect_to url_for_action(:edit), :notice => "Deleted all floor plans."
  end


  private

  def fetch_item
    # have to make a new method because there's already a before_filter for #find_item
    find_item
  end

  def verify_community_is_not_managed_externally
    if @item.managed_externally?
      flash[:error] = 'This community is already managed externally'
      redirect_to url_for_action(:edit)
    end
  end

  def find_external_community
    if params[:external_community_id].blank?
      flash[:error] = 'You must select an externally-managed community.'
      redirect_to url_for_action(:merge)
    else
      @external_community = ApartmentCommunity.managed_externally.find_by(id: params[:external_community_id])

      if @external_community.nil?
        flash[:error] = "Couldn't find that externally-managed community."
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
