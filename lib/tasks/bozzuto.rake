namespace :bozzuto do

  def log_task(message)
    puts "#{Time.now} #{message}"
  end

  def report_error(task, error)
    puts "Failed to #{task}: #{error.message}"
    puts error.backtrace
  end

  def enqueue_source(source)
    Bozzuto::ExternalFeed.queue!(source).tap do |feed_import|
      Resque.enqueue(PropertyFeedImportJob, feed_import.id)
    end
  rescue => e
    Airbrake.notify(e)
    report_error("#{source} imort", e)
  end

  desc 'Download property feeds via FTP'
  task :download_property_feeds => :environment do
    log_task 'Downloading property feeds ...'

    begin
      Bozzuto::ExternalFeed::Ftp.download_files

      puts '  Property feeds successfully downloaded'
    rescue => e
      report_error('download feeds', e)
      Airbrake.notify(e)
    end
  end

  desc 'Load latest feed from Vaultware'
  task :load_vaultware_feed => :environment do
    enqueue("vaultware")
  end

  desc 'Load latest feed from PropertyLink'
  task :load_property_link_feed => :environment do
    enqueue("property_link")
  end

  desc 'Load latest feed from Rent Cafe'
  task :load_rent_cafe_feed => :environment do
    enqueue("rent_cafe")
  end

  desc 'Load latest feed from PSI'
  task :load_psi_feed => :environment do
    enqueue("psi")
  end

  desc 'Send recurring emails'
  task :send_recurring_emails => :environment do
    log_task 'Sending recurring emails'

    RecurringEmail.needs_sending.each do |email|
      begin
        puts "  Sending recurring email to #{email.email_address}"
        email.send!
      rescue => e
        report_error('send recurring email', e)
        Airbrake.notify(e)
      end
    end
  end

  desc "Export apartment data to a feed"
  task :export_apartment_feed => :environment do
    log_task 'Exporting Apartment feed ...'

    begin
      export      = Bozzuto::Exports::ApartmentExport.new('legacy')
      output_file = APP_CONFIG[:apartment_export_file]

      File.open(output_file, 'w') do |f|
        f.write(export.to_xml)
      end

      puts '  Legacy apartment feed successfully exported'
    rescue => e
      report_error('export data', e)
      Airbrake.notify(e)
    end
  end

  desc "Send apartment export via FTP"
  task :send_apartment_export => :environment do
    log_task 'Uploading apartment feed via FTP...'

    begin
      Bozzuto::ExternalFeed::QburstFtp.transfer APP_CONFIG[:apartment_export_file]

      puts '  Apartment feed successfully uploaded'
    rescue => e
      report_error('send apartment export via FTP', e)
      Airbrake.notify(e)
    end
  end

  desc "Export contact lists in CSV format (Under Construction Leads + Buzzes)"
  task :export_contact_list_csvs => :environment do
    log_task 'Exporting contact lists as CSVs...'

    begin
      Bozzuto::UnderConstructionLeadCsv.new(:filename => APP_CONFIG[:under_construction_lead_file]).file
      Bozzuto::BuzzCsv.new(:filename => APP_CONFIG[:buzz_email_list_file]).file

      puts '  Contact list CSVs successfully exported'
    rescue => e
      report_error('export contact lists', e)
      Airbrake.notify(e)
    end
  end

  desc "Export LeaseHawk files in CSV format (Ad Sources + Apartment Community DNR configuration)"
  task :export_lease_hawk_csvs => :environment do
    log_task 'Exporting LeaseHawk files as CSVs...'

    begin
      Bozzuto::AdSourceCsv.new(:filename => APP_CONFIG[:ad_source_export_file]).file
      Bozzuto::DnrCsv.new(:filename => APP_CONFIG[:dnr_export_file]).file

      puts '  LeaseHawk CSVs successfully exported'
    rescue => e
      report_error('export LeaseHawk files', e)
      Airbrake.notify(e)
    end
  end

  desc "Send LeaseHawk CSV exports via FTP"
  task :send_lease_hawk_csvs => :environment do
    begin
      log_task 'Sending LeaseHawk Ad Source file via FTP...'
      Bozzuto::ExternalFeed::QburstFtp.transfer(APP_CONFIG[:ad_source_export_file], :dir => '/reporting/dni_feed')
      puts '  LeaseHawk Ad Source file successfully sent'

      log_task 'Sending LeaseHawk DNR Config file via FTP...'
      Bozzuto::ExternalFeed::QburstFtp.transfer(APP_CONFIG[:dnr_export_file], :dir => '/reporting/dni_feed')
      puts '  LeaseHawk DNR Config file successfully sent'
    rescue => e
      report_error('send LeaseHawk exports via FTP', e)
      Airbrake.notify(e)
    end
  end
end
