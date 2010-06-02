module ApplicationHelper
  def current_if(predicate)
    'current' if predicate
  end
end
