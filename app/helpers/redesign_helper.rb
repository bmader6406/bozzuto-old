module RedesignHelper
  def icon(text)
    content_tag(:i, text, :class => 'ico', :'aria-hidden' => 'true')
  end
end
