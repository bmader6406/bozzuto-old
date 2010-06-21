require 'test_helper'

class PageTest < ActiveSupport::TestCase
  context 'Page' do
    should_belong_to :section
  end
end
