require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  context 'A publication' do
    setup { @publication = Publication.new }

    subject { @publication }

    should_validate_presence_of :name

    should_have_attached_file :image

    should_have_many :rank_categories
  end
end
