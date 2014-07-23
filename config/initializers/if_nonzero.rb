class Object
  def if_nonzero?
    yield self if self.to_i.nonzero?
  end
end
