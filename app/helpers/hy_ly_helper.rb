module HyLyHelper
  def hyly_script(options = {})
    host = Bozzuto::HyLy.host_for(options[:context])
    id   = options.fetch(:id, Bozzuto::HyLy::PRIMARY_ID)
    pid  = pid_parameter_for(options[:context])

    <<-HTML.html_safe
    <!-- HyLy Form (Start) -->

    <script async src="//#{host}/fjs/#{id}/0.js#{pid}"></script>

    <!-- HyLy Form (End) -->
    HTML
  end

  def hyly_script_about_us_contact(options = {})
    host = Bozzuto::HyLy::PRIMARY_HOST_ABOUT_US_CONTACT
    id   = options.fetch(:id, Bozzuto::HyLy::PRIMARY_ID)
    pid  = pid_parameter_for(options[:context])

    <<-HTML.html_safe
    <!-- HyLy Form (Start) -->

    <script async src="//#{host}/fjs/#{id}/0.js#{pid}"></script>

    <!-- HyLy Form (End) -->
    HTML
  end

  def hyly_form(options = {})
    <<-HTML.html_safe
    <div id="hy-#{options.fetch(:id, Bozzuto::HyLy::PRIMARY_ID)}-0" class="hywrap" data-redirect-url="#{options.fetch(:redirect_to)}"></div>
    HTML
  end

  private

  def pid_parameter_for(thing)
    value = Bozzuto::HyLy.pid_for(thing)

    '?pid=' + value if value.present?
  end
end
