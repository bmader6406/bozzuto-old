class SectionConstraint

  def matches?(request)
    uri = URI(request.url)

    !!regex.match(uri.path)
  end

  private

  def regex
    # anything that doesn't start with `/system`
    /^(?!(\/system)).*/
  end
end
