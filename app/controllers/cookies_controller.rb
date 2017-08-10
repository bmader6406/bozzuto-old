class CookiesController < ApplicationController
  DISABLE_COOKIES_FIELD    = 'disable_cookies'
  COOKIES_DISABLED         = 'yes'
  COOKIES_ENABLED          = 'no'
  CHECK_IF_ENABLED         = -> (cookie_store) { cookie_store[DISABLE_COOKIES_FIELD] != COOKIES_DISABLED }
  SHOULD_REQUIRE_SELECTION = -> (cookie_store) { [COOKIES_ENABLED, COOKIES_DISABLED].exclude?(cookie_store[DISABLE_COOKIES_FIELD]) }

  def enable
    cookies.permanent[DISABLE_COOKIES_FIELD] = COOKIES_ENABLED

    head 200
  end

  def disable
    cookies.permanent[DISABLE_COOKIES_FIELD] = COOKIES_DISABLED
    
    head 200
  end
end
