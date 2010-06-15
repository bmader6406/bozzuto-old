module ServicesHelper
  def service_nav_item(service)
    classes = []
    classes << 'first' if service.position == 1
    classes << 'current' if params[:id] == service.to_param

    content_tag :li, :class => classes.compact.join(' ') do
      link_to(service.title, service)
    end
  end
end
