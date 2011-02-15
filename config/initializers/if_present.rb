class Object
  def if_present?
    yield self if present?
  end
end
