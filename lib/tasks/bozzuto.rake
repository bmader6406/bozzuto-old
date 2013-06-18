namespace :bozzuto do
  desc 'Sync photos from Flickr'
  task :sync_photo_sets => :environment do
    PhotoSet.needs_sync.each do |set|
      message = set.sync_photos ? 'Success' : 'Error!'
      puts "#{message}: #{set.title} (#{set.flickr_set_number})"
    end
  end

  desc 'Load latest feed from Vaultware'
  task :load_vaultware_feed => :environment do
    puts 'Loading Vaultware feed ...'

    begin
      file = APP_CONFIG[:vaultware_feed_file]
      loader = Bozzuto::VaultwareFeedLoader.new
      loader.file = file

      if loader.load
        puts "Vaultware feed successfully loaded"
      else
        puts "Can't load Vaultware feed. Try again later."
      end
    rescue Exception => e
      puts "Failed to load feed: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from PropertyLink'
  task :load_property_link_feed => :environment do
    puts 'Loading PropertyLink feed ...'

    begin
      file = APP_CONFIG[:property_link_feed_file]
      loader = Bozzuto::PropertyLinkFeedLoader.new
      loader.file = file

      if loader.load
        puts "PropertyLink feed successfully loaded"
      else
        puts "Can't load PropertyLink feed. Try again later."
      end
    rescue Exception => e
      puts "Failed to load feed: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Refresh Local Info feeds'
  task :refresh_local_info_feeds => :environment do
    Feed.all.each do |feed|
      puts "Refreshing #{feed.name} feed (#{feed.url})"
      feed.refresh
    end
  end

  desc 'Sync Twitter accounts'
  task :sync_twitter_accounts => :environment do
    TwitterAccount.all(:order => 'updated_at ASC').each do |account|
      begin
        puts "Refreshing @#{account.username}"
        account.sync
      rescue Exception => e
        puts " --> error syncing: #{e.message}"
        HoptoadNotifier.notify(e)
      end
    end
  end

  desc 'Send recurring emails'
  task :send_recurring_emails => :environment do
    RecurringEmail.needs_sending.each do |email|
      puts "Sending recurring email to #{email.email_address}"
      email.send!
    end
  end

  desc "Export apartment data to a feed"
  task :export_apartment_feed => :environment do
    puts 'Exporting Apartment data ...'

    begin
      exporter = Bozzuto::ApartmentFeedExporter.new
      output_file = APP_CONFIG[:apartment_export_file]

      File.open(output_file, 'w') do |f|
        f.write(exporter.to_xml)
      end

    rescue Exception => e
      puts "Failed to export data: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end
end
