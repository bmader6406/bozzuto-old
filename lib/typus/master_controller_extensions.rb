module Typus
  module MasterControllerExtensions
    def self.included(base)
      base.class_eval do
        # use carrierwave's remove_attachment! method
        def detach
          attachment = @resource[:class].human_attribute_name(params[:attachment])

          if @item.send("remove_#{params[:attachment]}!")
            flash[:success] = _("{{attachment}} removed.", 
                                :attachment => attachment)
          else
            flash[:notice] = _("{{attachment}} can't be removed.", 
                               :attachment => attachment)
          end

          redirect_to :back
        end
      end
    end
  end
end
