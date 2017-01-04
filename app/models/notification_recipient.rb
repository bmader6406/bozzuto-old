class NotificationRecipient < ActiveRecord::Base
  belongs_to :admin_user

  validates :admin_user_id, :email, uniqueness: true

  validate :email_address_provided

  def self.emails
    all.map(&:contact_email)
  end

  def contact_email
    admin_user.try(:email) || email
  end

  private

  def email_address_provided
    if contact_email.blank?
      errors.add(:base, 'requires an admin user or an email address.')
    end
  end
end
