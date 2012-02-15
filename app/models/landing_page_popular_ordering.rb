class LandingPagePopularOrdering < ActiveRecord::Base
  belongs_to :landing_page
  belongs_to :property
  
  acts_as_list :scope => :landing_page
  
  delegate :title, :street_address, :city, :to => :property
end
