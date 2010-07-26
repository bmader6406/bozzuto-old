class Promo < ActiveRecord::Base
  has_many :apartment_communities
  has_many :home_communities
  has_many :landing_pages

  validates_presence_of :title, :subtitle

  def typus_name
    title
  end
end
