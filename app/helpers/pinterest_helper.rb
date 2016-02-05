module PinterestHelper
  def pinterest_button(url, image_url, description = '#bozzuto')

    <<-HTML.html_safe
      <span class="pinterest-button">
        <a href="http://pinterest.com/pin/create/button/?url=#{URI::encode(url)}&media=#{URI::encode(image_url)}&description=#{URI::encode(description)}" class="pin-it-button" count-layout="none"><img border="0" src="//assets.pinterest.com/images/PinExt.png" title="Pin It" /></a>
      </span>
    HTML

  end
end
