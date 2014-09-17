class Lead2LeaseMailer < ActionMailer::Base
  def submission(community, submission)
    @community  = community
    @submission = submission

    mail(
      :to       => community.lead_2_lease_email,
      :from     => BOZZUTO_EMAIL_ADDRESS,
      :reply_to => submission.email,
      :subject  => "--New Email Lead For #{community.title}--"
    )
  end
end
