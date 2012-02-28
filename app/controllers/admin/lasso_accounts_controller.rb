class Admin::LassoAccountsController < Admin::MasterController
  def create_with_back_to
    resource_class = params[:resource].classify.constantize
    resource_id = params[:resource_id]
    resource = resource_class.find(resource_id)

    @item.property = resource
    @item.save

    flash[:success] = _("{{model_a}} successfully assigned to {{model_b}}.",
                        :model_a => @item.class.typus_human_name,
                        :model_b => resource_class.typus_human_name)

    redirect_to params[:back_to]
  end
end
