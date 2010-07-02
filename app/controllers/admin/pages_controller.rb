# Controller generated by Typus, use it to extend admin functionality.
class Admin::PagesController < Admin::MasterController
  def position
    @item.send(params[:go])

    to = case params[:go].gsub(/move_/, '').humanize.downcase
      when 'left' then 'up'
      when 'right' then 'down'
    end
    flash[:success] = _("Record moved {{to}}.", :to => to)

    redirect_to request.referer || admin_dashboard_path
  end
end
