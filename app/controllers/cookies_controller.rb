class CookiesController < ApplicationController
  DISABLE_COOKIES = 'disable_cookies'

  def enable
    cookies.delete(DISABLE_COOKIES)

    head 200
  end

  def disable
    cookies.permanent[DISABLE_COOKIES] = true
    
    head 200
  end
end
