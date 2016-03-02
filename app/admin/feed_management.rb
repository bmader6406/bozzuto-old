ActiveAdmin.register_page 'Feed & Export Management' do
  menu parent: 'System'

  action_item :download_feeds, only: :index do
    if ftp.can_load?
      link_to 'Download Feeds to Server', download_admin_feed_export_management_path, class: 'button'
    else
      span distance_of_time_in_words(Time.now, ftp.next_load_at).capitalize + ' until feeds can be downloaded again.'
    end
  end

  content do
    tabs do
      tab 'External Feeds' do
        panel nil do
          table_for loaders do
            column :type do |loader|
              loader.feed_name
            end

            column :communities do |loader|
              link_to "View All", [:admin, :apartment_communities, q: { external_cms_type_eq: loader.feed_type }], class: 'button', target: :blank
            end

            column '* Feeds can be refreshed once every two hours' do |loader|
              return unless loader.loading_enabled?

              if loader.can_load?
                link_to 'Refresh', refresh_admin_feed_export_management_path(loader.feed_type), class: 'button', method: :put
              else
                if loader.already_loading?
                  span 'Feed refresh in progress'
                else
                  span distance_of_time_in_words(Time.now, loader.next_load_at).capitalize + ' until next refresh'
                end
              end
            end
          end
        end
      end

      tab 'Exports' do
        panel nil do
          table_for exports do
            column :format do |export|
              export.to_s
            end

            column 'Last Built' do |export|
              if File.exists?(export.const_get(:PATH))
                time_ago_in_words(File.new(export.const_get(:PATH)).mtime).capitalize + ' ago'
              end
            end

            column nil do |export|
              link_to 'Rebuild & Re-Send', rebuild_admin_feed_export_management_path(export.to_s.parameterize), class: 'button', method: :put
            end
          end
        end
      end
    end
  end

  controller do
    def download
      if ftp.can_load?
        ftp.download_files
        message[:notice] = "Successfully downloaded feed files via FTP."
      elsif ftp.already_loading?
        message[:notice] = "Feed files are already being downloaded via FTP. Please try again later."
      else
        interval = ftp.load_interval
        message[:notice] = "Feed files can only be downloaded via FTP once every #{interval / 3600} hours. Please try again later."
      end
    rescue => e
      Rails.logger.debug(e.inspect)
      notify_airbrake(e)
      message[:alert] = "There was an error downloading the feed files. Please try again later."
    ensure
      redirect_to :back, message
    end

    def refresh
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(params[:feed_type])

      if loader.can_load?
        loader.load!
        message[:notice] = "#{loader.feed_name} Feed successfully updated."
      elsif loader.already_loading?
        message[:notice] = "#{loader.feed_name} Feed is already being updated. Please try again later."
      else
        message[:notice] = "#{loader.feed_name} Feed can only be loaded once every #{Bozzuto::ExternalFeed::Loader.load_interval / 3600} hours. Please try again later."
      end
    rescue => e
      Rails.logger.debug(e.inspect)
      notify_airbrake(e)
      message[:alert] = 'There was an error loading the feed. Please try again later.'
    ensure
      redirect_to :back, message
    end

    def rebuild
      Bozzuto::Exports::ApartmentExport.new(params[:format]).deliver

      message[:notice] = 'Apartments export successfully rebuilt and sent.'
    rescue => e
      notify_airbrake(e)
      message[:notice] = 'There was an error when rebuilding and re-sending the export.  Please try again later.'
    ensure
      redirect_to :back, message
    end

    def message
      @message ||= {}
    end

    def ftp
      @ftp ||= Bozzuto::ExternalFeed::LiveBozzutoFtp.new
    end
    helper_method :ftp
    
    def loaders
      @loaders ||= Bozzuto::ExternalFeed::Feed.feed_types.map do |type|
        Bozzuto::ExternalFeed::Loader.loader_for_type(type)
      end
    end
    helper_method :loaders

    def exports
      Bozzuto::Exports::ApartmentExport::FORMATS
    end
    helper_method :exports
  end
end
