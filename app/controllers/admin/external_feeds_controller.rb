class Admin::ExternalFeedsController < Admin::MasterController
  skip_before_filter :set_resource
  skip_before_filter :check_if_user_can_perform_action_on_resource
  before_filter :create_feed_loader

  def load
    message = {}

    if request.post?
      name = @loader.feed_name

      begin
        if @loader.can_load_feed?
          @loader.load
          message[:notice] = "#{name} Feed successfully updated."

        elsif @loader.feed_already_loading?
          message[:notice] = "#{name} Feed is already being updated. Please try again later."

        else
          message[:notice] = "#{name} Feed can only be loaded once every two hours. Please try again later."
        end

      rescue Exception => e
        Rails.logger.debug e

        notify_hoptoad(e)

        message[:alert] = "There was an error loading the feed. Please try again later."
      end
    end

    redirect_to :back, message
  end


  private

  def create_feed_loader
    if params[:feed_type].present?
      @loader = Bozzuto::ExternalFeedLoader.loader_for_type(params[:feed_type])

      @loader.file = APP_CONFIG["#{params[:feed_type]}_feed_file".to_sym]
    else
      redirect_to :back, :alert => 'Please specify a feed type.'
    end
  end
end
