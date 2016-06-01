module PhoneNumberHelper
  def sanitize_phone_number(number)
    (number || '').gsub(/\D/, '')
  end

  def format_phone_number(number)
    pn = sanitize_phone_number(number)
    pn = '1' << pn if pn.length == 10

    if pn.length == 11
      '(%s) %s-%s' % [pn[1..3], pn[4..6], pn[7..10]]
    else
      number
    end
  end

  def phone_number_uri(number)
    pn = sanitize_phone_number(number)

    if pn.length == 10
      "tel:+1#{pn}"
    else
      "tel:+#{pn}"
    end
  end

  def link_to_phone_number(*args, &block)
    if block_given?
      number       = args.first
      html_options = args.second || {}

      link_to(phone_number_uri(number), html_options, &block)
    else
      name         = args.first
      number       = args.second || {}
      html_options = args.third || {}

      link_to(name, phone_number_uri(number), html_options)
    end
  end

  def dnr_phone_number(community)
    return '' unless community.phone_number.present?

    # sanitize phone number
    number = sanitize_phone_number(community.phone_number)

    # find account
    account = if community.apartment?
      APP_CONFIG[:callsource]['apartment']
    elsif community.home?
      APP_CONFIG[:callsource]['home']
    end

    customer = community.dnr_configuration.try(:customer_code)

    <<-HTML.html_safe
      <span class="phone-number dnr-replace" data-format="xxx.xxx.xxxx" data-account="#{account}" data-customer="#{customer}">
        #{number}
      </span>
    HTML
  end
end
