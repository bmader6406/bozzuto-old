class ContactMailer < ActionMailer::Base
  def contact_form_submission(submission)
    @submission = submission

    mail(
      :to       => submission.topic.recipients,
      :from     => BOZZUTO_EMAIL_ADDRESS,
      :reply_to => "#{submission.name} <#{submission.email}>",
      :subject  => "[Bozzuto.com] Message from #{submission.name}"
    )
  end
end
