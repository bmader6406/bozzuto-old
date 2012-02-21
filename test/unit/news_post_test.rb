require 'test_helper'

class NewsPostTest < ActiveSupport::TestCase
  context 'NewsPost' do
    should_validate_presence_of :title, :body

    should_have_and_belong_to_many :sections

    should_have_attached_file :image
    should_have_attached_file :home_page_image

    context '#typus_name' do
      setup { @news = NewsPost.new(:title => 'Hey ya') }

      should 'return the title' do
        assert_equal @news.title, @news.typus_name
      end
    end
  end
end
