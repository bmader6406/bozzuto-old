class Lead2LeaseMailer < ActionMailer::Base
  def submission(community, submission)
    recipients community.lead_2_lease_email
    subject    "--New Email Lead For #{community.title}--"
    sent_on    Time.now
    from       submission.email
    body       :submission => submission
  end
end
