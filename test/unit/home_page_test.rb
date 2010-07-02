require 'test_helper'

class HomePageTest < ActiveSupport::TestCase
  context 'HomePage' do
    should_belong_to :featured_property

    should_validate_presence_of :body

    should_have_attached_file :banner_image
    
    should_validate_attachment_presence :banner_image
  end
end
