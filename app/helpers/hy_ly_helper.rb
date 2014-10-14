module HyLyHelper
  def hyly_script_for(thing)
    <<-HTML.html_safe
      <!-- HyLy Form (Start) -->

      <script async src="//app.hy.ly/fjs/#{Bozzuto::HyLy::ID}/0.js#{pid(thing)}"></script>

      <!-- HyLy Form (End) -->
    HTML
  end

  def hyly_form(options = {})
    <<-HTML.html_safe
      <div id="hy-#{Bozzuto::HyLy::ID}-0" class="hywrap" data-redirect-url="#{options.fetch(:redirect_to)}"></div>
    HTML
  end

  private

  def pid(thing)
    value = Bozzuto::HyLy.pid_for(thing)

    '?pid=' + value if value.present?
  end
end
