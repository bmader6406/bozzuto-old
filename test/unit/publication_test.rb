require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  extend AlgoliaSearchable

  context 'A publication' do
    subject { Publication.new }

    should have_many(:rank_categories)

    should validate_presence_of(:name)

    should have_attached_file(:image)

    describe "#to_s" do
      subject { Publication.new(:name => 'Detective Comics') }

      it "returns the name" do
        subject.to_s.should == 'Detective Comics'
      end
    end

    describe "#to_label" do
      subject { Publication.new(:name => 'Detective Comics') }

      it "returns the name" do
        subject.to_label.should == 'Detective Comics'
      end
    end
  end
end
