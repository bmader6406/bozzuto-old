class CommunityListingMailer < ActionMailer::Base
  include TruncateHtmlHelper
  helper_method :truncate_html

  include ActionView::Helpers::NumberHelper
  helper_method :number_to_currency

  include CurrencyHelper
  helper_method :dollars

  default :from     => BOZZUTO_EMAIL_ADDRESS,
          :reply_to => BOZZUTO_REPLY_TO


  def single_listing(to_address, community)
    @community  = community
    @to_address = to_address

    mail(
      :to      => to_address,
      :subject => community.title
    )
  end

  def recently_viewed_listings(recurring_email)
    @recurring_email = recurring_email

    mail(
      :to => recurring_email.email_address,
      :subject => 'Recently Viewed Apartment Communities'
    )
  end

  def search_results_listings(recurring_email)
    @recurring_email = recurring_email

    mail(
      :to      => recurring_email.email_address,
      :subject => 'Apartment Communities Search Results'
    )
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
