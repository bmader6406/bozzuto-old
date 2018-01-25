class MobileViewConstraint

  def self.matches?(request)
    new(request).matches?
  end

  def initialize(request)
    @request = request
  end

  def matches?
    is_mobile_request?
  end

  private

  attr_reader :request

  def is_mobile_request?
    request.params['format'] == 'mobile' || (device != :browser && !force_browser?) || force_mobile?
  end

  def device
    request.env['bozzuto.mobile.device'] || :browser
  end

  def force_browser?
    request.params[:force_full_site] == "1"
  end

  def force_mobile?
    request.params[:force_full_site] == "0"
  end
end
