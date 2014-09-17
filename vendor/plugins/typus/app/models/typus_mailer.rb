class TypusMailer < ActionMailer::Base
  prepend_view_path("#{File.dirname(__FILE__)}/../views")

  def reset_password_link(user, url)
    @user = user
    @url  = url

    mail(
      :recipients => user.email,
      :from       => Typus::Configuration.options[:email],
      :subject    => "[#{Typus::Configuration.options[:app_name]}] #{_("Reset password")}"
    )
  end
end
