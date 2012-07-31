class RecurringEmail < ActiveRecord::Base
  STATES = %w(active completed unsubscribed)

  attr_protected :token

  serialize :property_ids, Array

  validates_presence_of :email_address, :token

  validates_inclusion_of :recurring, :in => [true, false]
  validates_inclusion_of :state, :in => STATES

  validates_uniqueness_of :token

  before_validation :generate_token, :on => :create


  def self.random_uuid
    UUIDTools::UUID.random_create
  end


  private

  def generate_token
    self.token = self.class.random_uuid.to_s unless self.token.present?
  end
end
