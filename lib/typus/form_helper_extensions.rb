module Typus
  module FormHelperExtensions
    def self.included(base)
      base.class_eval do
        def typus_preview(item, attribute)
          return nil unless @item.send("#{attribute}?")

          href = item.send(attribute).url

          content = _("View {{attribute}}", :attribute => @item.class.human_attribute_name(attribute).downcase)

          render "admin/helpers/preview", 
            :attribute => attribute, 
            :content => content, 
            :href => href, 
            :item => item
        end
      end
    end

  end
end
