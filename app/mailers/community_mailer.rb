class CommunityMailer < ActionMailer::Base
  include TruncateHtmlHelper
  helper_method :truncate_html

  def send_to_friend(to_address, community)
    from       BOZZUTO_EMAIL_ADDRESS
    recipients to_address
    subject    community.title
    sent_on    Time.now
    body       :community => community, :to => to_address
  end


  private

  def community_url(community)
    case community
    when ApartmentCommunity
      apartment_community_url(community)
    when HomeCommunity
      home_community_url(community)
    end
  end
  helper_method :community_url


  def offers_url(community, opts = {})
    ufollowup_url(community.id, opts)
  end
  helper_method :offers_url


  def floor_plans_url(community)
    case community
    when ApartmentCommunity
      apartment_community_floor_plan_groups_url(community)
    when HomeCommunity
      home_community_homes_url(community)
    end
  end
  helper_method :floor_plans_url
end
