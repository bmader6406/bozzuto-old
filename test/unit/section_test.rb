require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  context 'Section' do
    setup do
      @section = Section.make
    end

    subject { @section }

    should_validate_presence_of :title
    should_validate_uniqueness_of :title

    should_have_one :service
    should_have_many :news_posts, :testimonials
  end
end
