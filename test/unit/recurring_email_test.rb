require 'test_helper'

class RecurringEmailTest < ActiveSupport::TestCase
  context "A Recurring Email" do
    should validate_presence_of(:email_address)

    describe "on creation" do
      subject { RecurringEmail.make }

      it "auto-generates a token" do
        subject.token.present?.should == true
      end
    end

    describe "#properties" do
      subject { RecurringEmail.make(:property_ids => [@published.id, @unpublished.id]) }

      before do
        @published   = ApartmentCommunity.make
        @unpublished = ApartmentCommunity.make :unpublished
      end

      it "returns only the published properties" do
        subject.properties.should == [@published]
      end
    end

    describe "#send!" do
      context "email is recurring" do
        subject { RecurringEmail.make(:recurring, :last_sent_at => (Time.now - 2.years)) }

        it "sends the email" do
          expect {
            subject.send!
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "updates the last_sent_at time" do
          subject.send!

          subject.last_sent_at.should be_within(0.5).of(Time.now)
        end
      end

      context "email isn't recurring" do
        subject { RecurringEmail.make }

        it "sends the email" do
          expect {
            subject.send!
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "sets the state to completed" do
          subject.send!

          subject.state.should == 'completed'
        end
      end
    end

    describe ".needs_sending" do
      before do
        @needs_sending = RecurringEmail.make(:recurring, :last_sent_at => 35.days.ago)
        @too_recent    = RecurringEmail.make(:recurring, :last_sent_at => 15.days.ago)
        @not_active    = RecurringEmail.make(:recurring, :state => 'unsubscribed')
        @not_recurring = RecurringEmail.make
      end

      it "returns the correct records" do
        RecurringEmail.needs_sending.should == [@needs_sending]
      end
    end
  end
end
