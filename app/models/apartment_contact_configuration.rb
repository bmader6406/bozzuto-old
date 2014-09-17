class ApartmentContactConfiguration < ActiveRecord::Base
  belongs_to :apartment_community

  validates_presence_of :apartment_community

  after_initialize :set_default_intro_text


  private

  def set_default_intro_text
    if upcoming_intro_text.blank?
      self.upcoming_intro_text = 'Sign up below to be the first to know when this community is read to accept residents.'
    end
  end
end
