job_type :rake, "cd :path && source /etc/profile.d/rbenv.sh && RAILS_ENV=:environment bundle exec rake :task :output"

if environment == 'production'
  every 1.day, :at => '6:00 am' do
    rake 'bozzuto:send_recurring_emails'
  end

  every 1.day, :at => '4:00 am' do
    rake "-s sitemap:refresh"
  end

  every 1.day, :at => ['12:05 am', '2:05 am', '4:05 am', '6:05 am', '8:05am', '10:05 am', '2:05 pm', '4:05 pm', '6:05 pm', '8:05 pm', '10:05 pm'] do
    rake 'bozzuto:download_property_feeds'
  end

  every 1.day, :at => ['10:15 am', '2:15 pm'] do
    rake 'bozzuto:load_vaultware_feed'
  end

  every 1.day, :at => ['10:20 am', '2:20 pm'] do
    rake 'bozzuto:load_property_link_feed'
  end

  every 1.day, :at => ['12:25 am', '4:25 am', '7:25 am', '10:25 am', '2:25 pm', '4:25 pm', '6:25 pm', '8:25 pm', '10:25 pm'] do
    rake 'bozzuto:load_rent_cafe_feed'
  end

  every 1.day, :at => ['10:30 am', '2:30 pm'] do
    rake 'bozzuto:load_psi_feed'
  end

  every 1.day, :at => ['1:55 am', '5:55 am', '8:55 am', '11:55 am', '3:55 pm', '5:55 pm', '7:55 pm', '9:55 pm', '11:55 pm'] do
    rake 'bozzuto:export_apartment_feed'
  end

  every 1.day, :at => ['2:00 am', '6:00 am', '9:00 am', '12:00 pm', '4:00 pm', '6:00 pm', '8:00 pm', '10:00 pm', '12:00 am'] do
    rake 'bozzuto:send_apartment_export'
  end

  every 1.day, :at => '1:00 am' do
    rake 'bozzuto:export_lease_hawk_csvs'
  end

  every 1.day, :at => '1:15 am' do
    rake 'bozzuto:send_lease_hawk_csvs'
  end

  every 1.day, :at => '2:00 am' do
    rake 'bozzuto:generate_mits4_1_export'
  end

  every 1.day, :at => '3:00 am' do
    rake 'bozzuto:send_mits4_1_export'
  end
end
