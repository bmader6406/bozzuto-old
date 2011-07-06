class Lead2LeaseMailer < ActionMailer::Base
  def submission(community, submission)
    from       BOZZUTO_EMAIL_ADDRESS
    reply_to   submission.email
    recipients community.lead_2_lease_email
    subject    "--New Email Lead For #{community.title}--"
    sent_on    Time.now
    body       :submission => submission
  end
end
