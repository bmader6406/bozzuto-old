class Admin::VaultwareController < Admin::MasterController
  skip_before_filter :set_resource
  skip_before_filter :check_if_user_can_perform_action_on_resource

  def refresh
    message = {}

    if request.post?
      lock_file = "#{VAULTWARE_TMP_FILE}.lock"

      begin
        if File.exists?(lock_file)
          message = { :alert => 'Vaultware Feed is already being updated. Please try again later.' }
        else
          `touch #{lock_file}`

          file = APP_CONFIG[:vaultware_feed_file]
          v = Bozzuto::VaultwareFeedLoader.new
          v.load(file)
          v.process

          `touch #{VAULTWARE_TMP_FILE}`

          message = { :notice => 'Vaultware Feed successfully updated.' }
        end
      rescue Exception => e
        Rails.logger.debug e

        notify_hoptoad(e)

        message = { :alert => 'There was an error loading the feed. Please try again later.' }
      ensure
        `rm #{lock_file}`
      end
    end

    redirect_to :back, message
  end
end
