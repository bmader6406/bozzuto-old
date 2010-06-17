class ContactMailer < ActionMailer::Base
  def contact_form_submission(submission)
    recipients APP_CONFIG[:contact_emails][submission.topic]
    subject    "Message from #{submission.name}"
    sent_on    Time.now
    body       :submission => submission
  end
end
