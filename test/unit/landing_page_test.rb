require 'test_helper'

class LandingPageTest < ActiveSupport::TestCase
  context 'LandingPage' do
    setup do
      @page = LandingPage.create :title => 'Baltimore'
    end

    subject { @page }

    should_validate_presence_of :title
    should_validate_uniqueness_of :title
    should_have_attached_file :masthead_image
  end
end
