require 'test_helper'

class NotificationsMailerTest < ActionMailer::TestCase
  context "NotificationsMailer" do
    before do
      @import = PropertyFeedImport.make
      @import.error = 'Invalid URI'
    end

    describe "#feed_error" do
      before do
        expect {
          @email = NotificationsMailer.feed_error(@import).deliver_now
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "includes the import error in the body" do
        @email.body.should include 'Invalid URI'
      end

      it "includes a link to the import's page in the admin" do
        @email.body.should include Rails.application.routes.url_helpers.admin_property_feed_import_url(@import)
      end
    end
  end
end
