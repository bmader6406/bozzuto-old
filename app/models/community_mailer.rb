class CommunityMailer < ActionMailer::Base
  def send_to_friend(to_address, community)
    recipients to_address
    subject    community.title
    sent_on    Time.now
    body       :community => community
  end
end
