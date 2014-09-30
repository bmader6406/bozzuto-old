require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  context 'A publication' do
    subject { Publication.new }

    should validate_presence_of(:name)

    should have_attached_file(:image)

    should have_many(:rank_categories)

    describe "#typus_name" do
      subject { Publication.new(:name => 'Detective Comics') }

      it "returns the name" do
        subject.typus_name.should == 'Detective Comics'
      end
    end
  end
end
