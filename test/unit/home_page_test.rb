require 'test_helper'

class HomePageTest < ActiveSupport::TestCase
  context 'HomePage' do
    should_have_many :slides
    should_have_one :carousel

    should_validate_presence_of :body

    should_have_attached_file :mobile_banner_image
  end
end
