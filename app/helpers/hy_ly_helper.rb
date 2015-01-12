module HyLyHelper
  def hyly_script(options = {})
    <<-HTML.html_safe
      <!-- HyLy Form (Start) -->

      <script async src="//app.hy.ly/fjs/#{options.fetch(:id, Bozzuto::HyLy::PRIMARY_ID)}/0.js#{pid(options[:context])}"></script>

      <!-- HyLy Form (End) -->
    HTML
  end

  def hyly_form(options = {})
    <<-HTML.html_safe
      <div id="hy-#{options.fetch(:id, Bozzuto::HyLy::PRIMARY_ID)}-0" class="hywrap" data-redirect-url="#{options.fetch(:redirect_to)}"></div>
    HTML
  end

  private

  def pid(thing)
    value = Bozzuto::HyLy.pid_for(thing)

    '?pid=' + value if value.present?
  end
end
