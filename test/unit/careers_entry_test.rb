require 'test_helper'

class CareersEntryTest < ActiveSupport::TestCase
  context "A Careers Entry" do
    should validate_presence_of(:name)
    should validate_presence_of(:company)
    should validate_presence_of(:job_title)
    should validate_presence_of(:job_description)

    should validate_attachment_presence(:main_photo)
    should validate_attachment_presence(:headshot)

    describe "#typus_name" do
      subject { CareersEntry.new(:name => 'Batman') }

      it "returns the name" do
        subject.typus_name.should == 'Batman'
      end
    end
  end
end
