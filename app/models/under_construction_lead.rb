class UnderConstructionLead < ActiveRecord::Base
  validates_presence_of :email, :first_name, :last_name

  belongs_to :apartment_community

  delegate :title,
    :to        => :apartment_community,
    :prefix    => true,
    :allow_nil => true
end
