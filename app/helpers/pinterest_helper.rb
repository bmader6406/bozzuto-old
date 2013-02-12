module PinterestHelper
  def pinterest_button(url, image_url, description = '#bozzuto')

    <<-HTML.html_safe
      <span class="pinterest-button">
        <a href="http://pinterest.com/pin/create/button/?url=#{url_encode(url)}&media=#{url_encode(image_url)}&description=#{url_encode(description)}" class="pin-it-button" count-layout="none"><img border="0" src="//assets.pinterest.com/images/PinExt.png" title="Pin It" /></a>
      </span>
    HTML

  end
end
