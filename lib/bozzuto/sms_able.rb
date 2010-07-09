module Bozzuto
  module SMSAble
    URL = 'http://www.i2sms.net/services/httpsend/httpsend.php'

    def phone_params(phone_number)
      params = {:to => phone_number,
        :message => phone_message,
        :username => APP_CONFIG[:sms]['username'],
        :pword => APP_CONFIG[:sms]['password'],
        :sender => APP_CONFIG[:sms]['sender']}.map do |k,v|

        "#{k.to_s}=#{CGI::escape(v.to_s)}"
      end
      params.join("&")
    end

    def send_info_message_to(phone_number)
      phone_number = "1" + phone_number unless (phone_number.first == '1')

      HTTParty.get([URL, phone_params(phone_number)].join('?'))
    end
  end
end
