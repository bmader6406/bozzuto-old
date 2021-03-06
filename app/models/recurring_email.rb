class RecurringEmail < ActiveRecord::Base
  STATES = %w(active completed unsubscribed)

  attr_protected :token

  serialize :property_ids, Array

  validates_presence_of :email_address, :token

  validates_inclusion_of :recurring, :in => [true, false]
  validates_inclusion_of :state, :in => STATES

  validates_uniqueness_of :token

  before_validation :generate_token, :on => :create

  scope :recurring,             -> { where(recurring: true) }
  scope :active,                -> { where(state: 'active') }
  scope :last_sent_30_days_ago, -> { where('last_sent_at < ?', 30.days.ago) }

  def self.random_uuid
    UUIDTools::UUID.random_create
  end

  def self.needs_sending
    recurring.active.last_sent_30_days_ago
  end

  def properties
    ApartmentCommunity.published.where(id: property_ids)
  end

  def send!
    if recurring?
      CommunityListingMailer.search_results_listings(self).deliver_now
      update_attribute(:last_sent_at, Time.now)
    else
      CommunityListingMailer.recently_viewed_listings(self).deliver_now
      update_attribute(:state, 'completed')
    end
  end

  def cancel_recurring!
    update_attribute(:state, 'unsubscribed')
  end


  private

  def generate_token
    self.token = self.class.random_uuid.to_s unless self.token.present?
  end
end
