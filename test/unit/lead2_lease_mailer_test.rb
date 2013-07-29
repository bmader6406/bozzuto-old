require 'test_helper'

class Lead2LeaseMailerTest < ActionMailer::TestCase
  context 'Lead2LeaseMailer' do
    setup do
      @lead = Lead2LeaseSubmission.make_unsaved
      @community = ApartmentCommunity.make(:lead_2_lease_email => Faker::Internet.email)
    end

    context '#contact_form_submission' do
      setup do
        @email = Lead2LeaseMailer.deliver_submission(@community, @lead)
      end

      should_change('deliveries', :by => 1) { ActionMailer::Base.deliveries.count }

      should 'deliver the message' do
        assert_equal [@community.lead_2_lease_email], @email.to
      end

      should 'use the submission email as the reply to' do
        assert_equal [@lead.email], @email.reply_to
      end

      should 'have a subject' do
        assert_equal "--New Email Lead For #{@community.title}--",
          @email.subject
      end

      should 'contain the email address' do
        assert_match /Email Address: #{@lead.email}/, @email.body
      end
    end
  end
end
