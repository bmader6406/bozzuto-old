job_type :rake, "cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

every 1.day, :at => '4:00 am' do
  rake "-s sitemap:refresh"
end

every 1.day, :at => '6:00 am' do
  rake 'bozzuto:send_recurring_emails'
end

every 1.day, :at => '7:00 am' do
  rake 'bozzuto:refresh_local_info_feeds'
end

every 1.day, :at => ['3:00 am'] do
  rake 'bozzuto:export_contact_list_csvs'
end

if environment == 'production'
  every 1.day, :at => '9:00 am' do
    command 'cp /home/bozzuto_feeds/bozzutovwfeed.xml /home/bozzuto/bozzutocom.xml'
  end

  every 1.day, :at => ['10:05 am', '2:05 pm'] do
    rake 'bozzuto:download_property_feeds'
  end

  every 1.day, :at => ['10:15 am', '2:15 pm'] do
    rake 'bozzuto:load_vaultware_feed'
  end

  every 1.day, :at => ['10:20 am', '2:20 pm'] do
    rake 'bozzuto:load_property_link_feed'
  end

  every 1.day, :at => ['10:25 am', '2:25 pm'] do
    rake 'bozzuto:load_rent_cafe_feed'
  end

  every 1.day, :at => ['10:30 am', '2:30 pm'] do
    rake 'bozzuto:load_psi_feed'
  end

  every 1.day, :at => ['10:40 am', '2:40 pm'] do
    rake 'bozzuto:export_apartment_feed'
  end

  every 1.day, :at => ['11:00 am', '3:00 pm'] do
    rake 'bozzuto:send_apartment_export'
  end
end
