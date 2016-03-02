require 'test_helper'

class PromoTest < ActiveSupport::TestCase
  context 'Promo' do
    subject { Promo.make }

    should have_many(:apartment_communities)
    should have_many(:home_communities)
    should have_many(:landing_pages)

    should validate_presence_of(:title)
    should validate_presence_of(:subtitle)

    describe "#to_s" do
      context "promo is active" do
        subject { Promo.make(:active, :title => 'Hey ya') }

        it "return the title" do
          subject.to_s.should == 'Hey ya'
        end
      end

      context "promo is expired" do
        subject { Promo.make(:expired, :title => 'Hey ya') }

        it "return the title plus expired" do
          subject.to_s.should == 'Hey ya (expired)'
        end
      end
    end

    describe "#active?" do
      context "a promo without an expiration_date" do
        before do
          subject.has_expiration_date = false
        end

        it "be active" do
          subject.active?.should == true
        end
      end

      context "a promo with an expiration_date in the future" do
        before do
          subject.has_expiration_date = true
          subject.expiration_date = Time.now + 1.day
        end

        it "be active" do
          subject.active?.should == true
        end
      end

      context "a promo with an expiration_date in the past" do
        before do
          subject.has_expiration_date = true
          subject.expiration_date = Time.now - 1.day
        end

        it "not be active" do
          subject.active?.should == false
        end
      end
    end

    describe "#expired?" do
      context "a promo without an expiration_date" do
        before do
          subject.has_expiration_date = false
        end

        it "not be expired" do
          subject.expired?.should == false
        end
      end

      context "a promo with an expiration_date in the future" do
        before do
          subject.has_expiration_date = true
          subject.expiration_date = Time.now + 1.day
        end

        it "not be expired" do
          subject.expired?.should == false
        end
      end

      context "a promo with an expiration_date in the past" do
        before do
          subject.has_expiration_date = true
          subject.expiration_date = Time.now - 1.day
        end

        it "be expired" do
          subject.expired?.should == true
        end
      end
    end

    describe "has_expiration_date is false" do
      before do
        subject.has_expiration_date = false
      end

      it "set expiration_date to nil before validation" do
        subject.expiration_date = Time.now
        subject.expiration_date.present?.should == true

        subject.valid?

        subject.expiration_date.should == nil
      end

      it "allow nil for expiration_date" do
        subject.expiration_date = nil
        subject.valid?

        subject.errors[:expiration_date].should == []
      end
    end

    describe "has_expiration_date is true" do
      before do
        subject.has_expiration_date = true
        subject.expiration_date = nil
      end

      should validate_presence_of(:expiration_date)
    end

    describe "#expired_string" do
      context "when expired" do
        subject { Promo.make(:expired) }

        it "return Yes" do
          subject.expired_string.should == 'Yes'
        end
      end

      context "when active" do
        subject { Promo.make(:active) }

        it "return empty string" do
          subject.expired_string.should == ''
        end
      end
    end

    describe "scopes" do
      before do
        @promo   = Promo.make
        @active  = Promo.make :active
        @expired = Promo.make :expired
      end

      describe ".active" do
        it "return promos with no expiration date or date in the future" do
          assert_same_elements [@promo, @active], Promo.active
        end
      end

      describe ".expired" do
        it "return promos with expiration date in the past" do
          Promo.expired.should == [@expired]
        end
      end
    end
  end
end
