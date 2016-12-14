class NotificationsMailer < ActionMailer::Base
  def feed_error(import)
    @import   = import
    copy_list = [
      'webdev@bozzuto.com',
      'ryan.stenberg@viget.com',
      'samantha.freda@viget.com'
    ]

    mail(
      to:       'bmader@bozzuto.com',
      cc:       copy_list,
      from:     BOZZUTO_EMAIL_ADDRESS,
      subject:  "[Bozzuto.com] Error While Importing #{import.type.titleize} Feed"
    )
  end
end
