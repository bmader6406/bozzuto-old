class ContactMailer < ActionMailer::Base
  def contact_form_submission(submission)
    from       BOZZUTO_EMAIL_ADDRESS
    reply_to   "#{submission.name} <#{submission.email}>"
    recipients submission.topic.recipients
    subject    "[Bozzuto.com] Message from #{submission.name}"
    sent_on    Time.now
    body       :submission => submission
  end
end
