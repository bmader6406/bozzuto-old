module Bozzuto
  class PageContentDoctor
    attr_accessor :results
    attr_reader   :page, :content_method

    def initialize(page, options = {})
      @page           = page
      @content_method = options.fetch(:content_method, :content)
      @preview        = options.fetch(:preview, false)
    end

    def preview?
      !!@preview
    end

    def preview
      self.tap { @preview = true }
    end

    def execute
      self.tap { @preview = false }
    end

    def content
      page.public_send(content_method)
    end

    def trim_address_phone_and_office_hours
      based_on_preview_state do
        # In almost every PropertyContactPage record, this text appears immediately after the
        # address and office hours.
        header_for_persisting_content = "<h2>\r\n\t\t<strong>Looking for answers?&nbsp; We are here to help.</strong>"

        split_content = content.split(header_for_persisting_content)

        if split_content.size > 1
          header_for_persisting_content + split_content.last
        else
          content
        end
      end
    end

    private

    def based_on_preview_state(&block)
      yield.tap do |doctored_content|
        self.results = doctored_content
        page.update_attributes(content_method => results) unless preview?
      end
    end
  end
end
