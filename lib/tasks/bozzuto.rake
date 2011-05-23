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
      v = Vaultware::Parser.new
      v.parse(file)
      v.process
      puts "Vaultware feed successfully loaded"
    rescue Exception => e
      puts "Failed to load feed: #{e.message}"
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
      rescue Twitter::BadRequest => e
        puts " --> error syncing: #{e.message}"
      end
    end
  end
end
