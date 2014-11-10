class Admin::ExternalFeedsController < Admin::MasterController
  skip_before_filter :set_resource
  skip_before_filter :check_if_user_can_perform_action_on_resource
  before_filter      :create_feed_loader, :only => :load
  before_filter      :create_ftp,         :only => :download_feeds

  def load
    message = {}

    name = @loader.feed_name

    begin
      if @loader.can_load?
        @loader.load!
        message[:notice] = "#{name} Feed successfully updated."

      elsif @loader.already_loading?
        message[:notice] = "#{name} Feed is already being updated. Please try again later."

      else
        interval = Bozzuto::ExternalFeed::Loader.load_interval
        message[:notice] = "#{name} Feed can only be loaded once every #{interval / 3600} hours. Please try again later."
      end

    rescue Exception => e
      Rails.logger.debug(e.inspect)

      notify_hoptoad(e)

      message[:alert] = "There was an error loading the feed. Please try again later."
    end

    redirect_to :back, message
  end

  def download_feeds
    message = {}

    name = @ftp.ftp_name

    begin
      if @ftp.can_load?
        @ftp.download_files
        message[:notice] = "Successfully downloaded feed files via #{name} FTP."

      elsif @ftp.already_loading?
        message[:notice] = "Feed files are already being downloaded via #{name} FTP. Please try again later."

      else
        interval = @ftp.load_interval
        message[:notice] = "Feed files can only be downloaded via #{name} FTP once every #{interval / 3600} hours. Please try again later."
      end

    rescue Exception => e
      Rails.logger.debug(e.inspect)

      notify_hoptoad(e)

      message[:alert] = "There was an error downloading the feed files. Please try again later."
    end

    redirect_to :back, message
  end

  private

  def create_feed_loader
    if params[:feed_type].present?
      @loader = Bozzuto::ExternalFeed::Loader.loader_for_type(params[:feed_type])
    else
      redirect_to :back, :alert => 'Please specify a feed type.'
    end
  end

  def create_ftp
    if params[:ftp_type].present?
      @ftp = params[:ftp_type].constantize.new
    else
      redirect_to :back, :alert => 'Please specify a feed download type.'
    end
  end
end
