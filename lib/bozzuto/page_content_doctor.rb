module Bozzuto
  class PageContentDoctor
    PERSISTING_CONTENT_DELIMITER = /(?<header>[\r\t\n]*(<h2>)*[\r\t\n]*(<strong>)*Looking for answers.*We are here to help.(<\/strong>)*)/

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

        split_content = content.split(PERSISTING_CONTENT_DELIMITER)

        if split_content.size > 1
          split_content[1] + split_content[2]
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
