namespace :bozzuto do
  desc 'Download property feeds via FTP'
  task :download_property_feeds => :environment do
    puts 'Downloading property feeds ...'

    begin
      Bozzuto::ExternalFeed::InboundFtp.download_files
    rescue Exception => e
      puts "Failed to download feeds: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from Vaultware'
  task :load_vaultware_feed => :environment do
    puts 'Loading Vaultware feed ...'

    begin
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:vaultware)

      if loader.load!
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
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:property_link)

      if loader.load!
        puts "PropertyLink feed successfully loaded"
      else
        puts "Can't load PropertyLink feed. Try again later."
      end
    rescue Exception => e
      puts "Failed to load feed: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from Rent Cafe'
  task :load_rent_cafe_feed => :environment do
    puts 'Loading RentCafe feed ...'

    begin
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:rent_cafe)

      if loader.load!
        puts "RentCafe feed successfully loaded"
      else
        puts "Can't load RentCafe feed. Try again later."
      end
    rescue Exception => e
      puts "Failed to load feed: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from PSI'
  task :load_psi_feed => :environment do
    puts 'Loading PSI feed ...'

    begin
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:psi)

      if loader.load!
        puts "PSI feed successfully loaded"
      else
        puts "Can't load PSI feed. Try again later."
      end
    rescue Exception => e
      puts "Failed to load feed: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Refresh Local Info feeds'
  task :refresh_local_info_feeds => :environment do
    Feed.all.each do |feed|
      begin
        puts
        puts "==> Refreshing #{feed.name} feed (#{feed.url})"
        feed.refresh!
      rescue Exception => e
        puts "Failed to load feed: #{e.message}"
        HoptoadNotifier.notify(e)
      end
    end
  end

  desc 'Send recurring emails'
  task :send_recurring_emails => :environment do
    RecurringEmail.needs_sending.each do |email|
      begin
        puts "Sending recurring email to #{email.email_address}"
        email.send!
      rescue Exception => e
        puts "Failed to send recurring email: #{e.message}"
        HoptoadNotifier.notify(e)
      end
    end
  end

  desc "Export apartment data to a feed"
  task :export_apartment_feed => :environment do
    return unless Rails.env.production?

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

  desc "Send apartment export via FTP"
  task :send_apartment_export => :environment do
    puts 'Sending apartment export via FTP...'

    begin
      Bozzuto::ExternalFeed::OutboundFtp.transfer APP_CONFIG[:apartment_export_file]
    rescue Exception => e
      puts "Failed to send apartment export via FTP: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end

  desc "Export contact lists in CSV format (Under Construction Leads + Buzzes)"
  task :export_contact_list_csvs => :environment do
    puts 'Exporting contact lists as CSVs...'

    begin
      Bozzuto::UnderConstructionLeadCsv.new(:filename => APP_CONFIG[:under_construction_lead_file]).file
      Bozzuto::BuzzCsv.new(:filename => APP_CONFIG[:buzz_email_list_file]).file

    rescue Exception => e
      puts "Failed to export contact lists: #{e.message}"
      HoptoadNotifier.notify(e)
    end
  end
end
