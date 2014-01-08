require File.expand_path(File.dirname(__FILE__) + "/config/environment")

require 'CSV'

def generate_csv(file, base)
  File.open(file, 'wb') do |f|
    f << ['id', "#{base.to_s.underscore}_name", 'dnr_customer_id'].map(&:inspect).join(',')

    base.all.each do |a|
      f << "\n"
      f << [a.id, a.title, a.try(:dnr_configuration).try(:customer_code)].map(&:to_s).map(&:inspect).join(',')
    end
  end
end

generate_csv('dnr_apartment_communities.csv', ApartmentCommunity)
generate_csv('dnr_home_communities.csv', HomeCommunity)
