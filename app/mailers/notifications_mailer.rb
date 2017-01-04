class NotificationsMailer < ActionMailer::Base
  def feed_error(import)
    @import = import

    mail(
      to:      'bmader@bozzuto.com',
      cc:      NotificationRecipient.emails,
      from:    BOZZUTO_EMAIL_ADDRESS,
      subject: "[Bozzuto.com] Error While Importing #{import.type.titleize} Feed"
    )
  end
end
