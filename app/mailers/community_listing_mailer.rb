class CommunityListingMailer < ActionMailer::Base
  include TruncateHtmlHelper
  helper_method :truncate_html

  include CurrencyHelper
  helper_method :dollars


  def single_listing(to_address, community)
    from       BOZZUTO_EMAIL_ADDRESS
    reply_to   BOZZUTO_REPLY_TO
    recipients to_address
    subject    community.title
    sent_on    Time.now
    body       :community => community, :to => to_address
  end

  def recently_viewed_listings(recurring_email)
    from       BOZZUTO_EMAIL_ADDRESS
    reply_to   BOZZUTO_REPLY_TO
    recipients recurring_email.email_address
    subject    'Recently Viewed Apartment Communities'
    sent_on    Time.now
    body       :recurring_email => recurring_email
  end

  def search_results_listings(recurring_email)
    from       BOZZUTO_EMAIL_ADDRESS
    reply_to   BOZZUTO_REPLY_TO
    recipients recurring_email.email_address
    subject    'Apartment Communities Search Results'
    sent_on    Time.now
    body       :recurring_email => recurring_email
  end


  private

  def floor_plans_url(community)
    case community
    when ApartmentCommunity then apartment_community_floor_plan_groups_url(community)
    when HomeCommunity then      home_community_homes_url(community)
    end
  end
  helper_method :floor_plans_url


  def tel_url(number)
    number = number.gsub(/\D/, '')

    if number.length == 10
      number = '1' << number
    end

    "tel:+#{number}"
  end
  helper_method :tel_url
end
