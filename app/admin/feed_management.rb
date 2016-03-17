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
      tab 'External Feed Sources' do
        panel nil do
          table_for Bozzuto::ExternalFeed::SOURCES do
            column :type do |source|
              link_to source.titleize, [:admin, :property_feed_imports, scope: source]
            end

            column :communities do |source|
              link_to "View All", [:admin, :apartment_communities, q: { external_cms_type_eq: source }], class: 'button', target: :blank
            end

            column '* Feeds can be refreshed once every two hours' do |source|
              link_to 'Refresh', refresh_admin_feed_export_management_path(source), class: 'button', method: :put
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
      feed_import = Bozzuto::ExternalFeed.queue!(params[:source])
      Resque.enqueue(PropertyFeedImportJob, feed_import.id)

      flash[:notice] = "#{Bozzuto::ExternalFeed.source_name(params[:source])} Feed successfully queued."
      redirect_to [:admin, :property_feed_imports]
    rescue => e
      notify_airbrake(e)

      flash[:alert] = 'There was an error loading the feed. Please try again later.'
      redirect_to [:admin, :feed_export_management]
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

    def exports
      Bozzuto::Exports::ApartmentExport::FORMATS
    end
    helper_method :exports
  end
end
