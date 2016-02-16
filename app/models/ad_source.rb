class AdSource < ActiveRecord::Base
  validates_presence_of :domain_name, :value
  validates_uniqueness_of :domain_name
  validate :properly_formatted_uri
  validate :does_not_include_protocol

  before_save :write_pattern

  def self.matching(domain)
    return nil if domain.blank? || domain == '/'

    where("? RLIKE pattern", domain).first
  end

  def to_s
    domain_name
  end

  private

  def properly_formatted_uri
    URI::HTTP.build(:host => domain_name)
  rescue URI::InvalidComponentError
    errors.add(:domain_name, 'contains invalid characters')
  end

  def does_not_include_protocol
    if domain_name =~ /^https?:\/\//
      errors.add(:domain_name, 'must not include http://')
    end
  end

  def write_pattern
    self.pattern = "#{domain_name}$"
  end
end
