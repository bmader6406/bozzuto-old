class Promo < ActiveRecord::Base
  has_many :apartment_communities
  has_many :home_communities
  has_many :landing_pages

  named_scope :active,
    :conditions => ['has_expiration_date = ? OR expiration_date > ?', false, Time.now]
  named_scope :expired,
    :conditions => ['has_expiration_date = ? AND expiration_date < ?', true, Time.now]

  validates_presence_of :title, :subtitle
  validates_presence_of :expiration_date, :if => proc { |record| record.has_expiration_date? }
  validates_inclusion_of :has_expiration_date, :in => [true, false]

  before_validation :nullify_expiration_date

  def typus_name
    title
  end


  private

  def nullify_expiration_date
    write_attribute(:expiration_date, nil) unless has_expiration_date?
  end
end
