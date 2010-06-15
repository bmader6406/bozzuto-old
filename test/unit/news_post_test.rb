require 'test_helper'

class NewsPostTest < ActiveSupport::TestCase
  context 'NewsPost' do
    should_validate_presence_of :title, :body, :section

    should_have_named_scope :published,
      :conditions => { :published => true }

    should_belong_to :section
  end
end
