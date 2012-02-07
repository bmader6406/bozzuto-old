class UnderConstructionLead < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :phone_number, :email

  belongs_to :apartment_community

  # Used by the CSV exporter
  def apartment_community_title
    apartment_community.try(:title)
  end
end
