require 'test_helper'

class ProjectUpdateTest < ActiveSupport::TestCase
  context 'ProjectUpdate' do
    subject { ProjectUpdate.make }

    should belong_to(:project)

    should validate_presence_of(:body)
    should validate_presence_of(:project)

    should have_attached_file(:image)

    describe "#typus_name" do
      subject do
        ProjectUpdate.new(
          :project      => Project.new(:title => 'Gotham Transit'),
          :published_at => Date.new(1997, 8, 29).to_time
        )
      end

      it "returns the project title and published at timestamp" do
        subject.typus_name.should == 'Gotham Transit Update - August 29, 1997'
      end
    end
  end
end
