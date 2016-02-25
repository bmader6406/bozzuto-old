# TODO remove this with Typus, RF 2-26-16
module ActiveRecord
  class Base

    def self.human_tip_text(attribute_key_name, options = {})
      if Rails.env.development?
        fail "This shouldn't be hit, except by Typus. Remove with Typus."
      end
    end
  end
end
