require 'test_helper'

class NewsPostTest < ActiveSupport::TestCase
  context 'NewsPost' do
    should_validate_presence_of :title, :body, :section, :category

    should_belong_to :section

    should_have_attached_file :image
  end
end
