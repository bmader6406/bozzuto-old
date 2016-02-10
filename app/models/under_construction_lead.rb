class UnderConstructionLead < ActiveRecord::Base

  attr_accessible :first_name,
                  :last_name,
                  :address,
                  :address_2,
                  :city,
                  :state,
                  :zip_code,
                  :phone_number,
                  :email,
                  :comments

  belongs_to :apartment_community

  validates_presence_of :email, :first_name, :last_name

  delegate :title,
    :to        => :apartment_community,
    :prefix    => true,
    :allow_nil => true
end
