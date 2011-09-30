class DnrReferrer < ActiveRecord::Base
  validates_presence_of :domain_name
  validate :properly_formatted_uri
  validate :does_not_include_protocol

  attr_accessible :domain_name

  before_save :write_pattern

  def self.matching(domain)
    return nil if domain.blank? || domain == '/'

    all(:conditions => ['? RLIKE pattern', domain]).first.try(:domain_name)
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
