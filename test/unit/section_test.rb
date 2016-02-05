require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  context 'Section' do
    subject { Section.make }

    should validate_presence_of(:title)
    should validate_uniqueness_of(:title)

    should have_many(:testimonials)
    should have_many(:projects)
    should have_and_belong_to_many(:awards)
    should have_and_belong_to_many(:news_posts)
    should have_and_belong_to_many(:press_releases)
    should have_one(:contact_topic)

    should have_attached_file(:left_montage_image)
    should have_attached_file(:middle_montage_image)
    should have_attached_file(:right_montage_image)


    describe "#typus_name" do
      it "returns the title" do
        subject.typus_name.should == subject.title
      end
    end

    describe "self#about" do
      it "returns the About section" do
        about = Section.make(:about)

        Section.about.should == about
      end
    end

    describe "#about?" do
      context "when about flag is true" do
        before do
          subject.about = true
        end

        it "returns true" do
          subject.about?.should == true
        end
      end

      context "when slug is anything else" do
        before do
          subject.about = false
        end

        it "returns false" do
          subject.about?.should == false
        end
      end
    end

    describe "#aggregate?" do
      context "when About section" do
        before do
          subject.about = true
        end

        it "returns true" do
          subject.aggregate?.should == true
        end
      end

      context "when any other section" do
        before do
          subject.about = false
        end

        it "returns false" do
          subject.aggregate?.should == false
        end
      end
    end

    describe "#to_param" do
      context "section isn't a service" do
        subject { Section.make(:title => "I'm Batman") }

        it "returns just the name" do
          subject.to_param.should == "i-m-batman"
        end
      end

      context "section is a service" do
        subject { Section.make(:service, :title => "I'm Batman") }

        it "returns the services prefix and the name" do
          subject.to_param.should == "services/i-m-batman"
        end
      end
    end

    describe "#montage?" do
      context "when all montage images are present" do
        before do
          subject.expects(:left_montage_image?).returns(true)
          subject.expects(:middle_montage_image?).returns(true)
          subject.expects(:right_montage_image?).returns(true)
        end

        it "returns true" do
          subject.montage?.should == true
        end
      end

      context "when any montage images are missing" do
        before do
          subject.expects(:left_montage_image?).returns(false)
          subject.stubs(:middle_montage_image?).returns(true)
          subject.stubs(:right_montage_image?).returns(true)
        end

        it "returns false" do
          subject.montage?.should == false
        end
      end
    end
  end
end
