require 'test_helper'

class HomePageTest < ActiveSupport::TestCase
  context 'HomePage' do
    should_belong_to :apartment_mini_slideshow
    should_belong_to :home_mini_slideshow
    should_have_many :slides

    should_validate_presence_of :body
  end
end
