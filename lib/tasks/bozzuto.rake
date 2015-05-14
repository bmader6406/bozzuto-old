namespace :bozzuto do
  def log_task(message)
    puts "#{Time.now} #{message}"
  end

  def report_error(task, error)
    puts "Failed to #{task}: #{error.message}"
    puts error.backtrace
  end

  desc 'Download property feeds via FTP'
  task :download_property_feeds => :environment do
    log_task 'Downloading property feeds ...'

    begin
      Bozzuto::ExternalFeed::Ftp.download_files

      puts '  Property feeds successfully downloaded'
    rescue Exception => e
      report_error('download feeds', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from Vaultware'
  task :load_vaultware_feed => :environment do
    log_task 'Loading Vaultware feed ...'

    begin
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:vaultware)

      if loader.load!
        puts "  Vaultware feed successfully loaded"
      else
        puts "  Can't load Vaultware feed. Try again later."
      end
    rescue Exception => e
      report_error('load feed', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from PropertyLink'
  task :load_property_link_feed => :environment do
    log_task 'Loading PropertyLink feed ...'

    begin
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:property_link)

      if loader.load!
        puts "  PropertyLink feed successfully loaded"
      else
        puts "  Can't load PropertyLink feed. Try again later."
      end
    rescue Exception => e
      report_error('load feed', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from Rent Cafe'
  task :load_rent_cafe_feed => :environment do
    log_task 'Loading RentCafe feed ...'

    begin
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:rent_cafe)

      if loader.load!
        puts "  RentCafe feed successfully loaded"
      else
        puts "  Can't load RentCafe feed. Try again later."
      end
    rescue Exception => e
      report_error('load feed', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from PSI'
  task :load_psi_feed => :environment do
    log_task 'Loading PSI feed ...'

    begin
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:psi)

      if loader.load!
        puts "  PSI feed successfully loaded"
      else
        puts "  Can't load PSI feed. Try again later."
      end
    rescue Exception => e
      report_error('load feed', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Load latest feed from Carmel'
  task :load_carmel_feed => :environment do
    log_task 'Loading Carmel feed ...'

    begin
      loader = Bozzuto::ExternalFeed::Loader.loader_for_type(:carmel)

      if loader.load!
        puts "  Carmel feed successfully loaded"
      else
        puts "  Can't load Carmel feed. Try again later."
      end
    rescue Exception => e
      report_error('load feed', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc 'Refresh Local Info feeds'
  task :refresh_local_info_feeds => :environment do
    log_task 'Refreshing RSS feeds'

    Feed.all.each do |feed|
      begin
        puts "  Refreshing #{feed.name} feed (#{feed.url})"
        feed.refresh!
      rescue Exception => e
        report_error('load RSS feed', e)
        HoptoadNotifier.notify(e)
      end
    end
  end

  desc 'Send recurring emails'
  task :send_recurring_emails => :environment do
    log_task 'Sending recurring emails'

    RecurringEmail.needs_sending.each do |email|
      begin
        puts "  Sending recurring email to #{email.email_address}"
        email.send!
      rescue Exception => e
        report_error('send recurring email', e)
        HoptoadNotifier.notify(e)
      end
    end
  end

  desc "Export apartment data to a feed"
  task :export_apartment_feed => :environment do
    log_task 'Exporting Apartment feed ...'

    begin
      export      = Bozzuto::Exports::ApartmentExport.legacy
      output_file = APP_CONFIG[:apartment_export_file]

      File.open(output_file, 'w') do |f|
        f.write(export.to_xml)
      end

      puts '  Legacy apartment feed successfully exported'
    rescue Exception => e
      report_error('export data', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc "Send apartment export via FTP"
  task :send_apartment_export => :environment do
    log_task 'Uploading apartment feed via FTP...'

    begin
      Bozzuto::ExternalFeed::QburstFtp.transfer APP_CONFIG[:apartment_export_file]

      puts '  Apartment feed successfully uploaded'
    rescue Exception => e
      report_error('send apartment export via FTP', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc "Generate MITS 4.1 Export"
  task :generate_mits4_1_export => :environment do
    log_task 'Generating MITS 4.1 Export ...'

    begin
      export      = Bozzuto::Exports::ApartmentExport.mits4_1
      output_file = APP_CONFIG[:mits4_1_export_file]

      File.open(output_file, 'w') do |f|
        f.write(export.to_xml)
      end

      puts '  MITS 4.1 export successfully generated'
    rescue Exception => e
      report_error('generating MITS 4.1 export', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc "Send MITS 4.1 export via FTP"
  task :send_mits4_1_export => :environment do
    log_task 'Sending MITS 4.1 export via FTP...'

    begin
      Bozzuto::ExternalFeed::QburstFtp.transfer APP_CONFIG[:mits4_1_export_file]

      puts '  MITS 4.1 export successfully sent'
    rescue Exception => e
      report_error('send MITS 4.1 export via FTP', e)
      HoptoadNotifier.notify(e)
    end
  end

  desc "Export contact lists in CSV format (Under Construction Leads + Buzzes)"
  task :export_contact_list_csvs => :environment do
    log_task 'Exporting contact lists as CSVs...'

    begin
      Bozzuto::UnderConstructionLeadCsv.new(:filename => APP_CONFIG[:under_construction_lead_file]).file
      Bozzuto::BuzzCsv.new(:filename => APP_CONFIG[:buzz_email_list_file]).file

      puts '  Contact list CSVs successfully exported'
    rescue Exception => e
      report_error('export contact lists', e)
      HoptoadNotifier.notify(e)
    end
  end
end
