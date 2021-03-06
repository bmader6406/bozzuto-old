module Bozzuto
  class SlideshowWrapper < Struct.new(:type, :page)
    delegate :name, :present?, to: :record

    def record
      @record ||= page.send(type)
    end

    def label
      type.to_s.titleize
    end

    def url_params(action = :show)
      {
        show: [:admin, record],
        new:  [:new, :admin, type, type => { page_id: page.id }]
      }.fetch(action.to_sym)
    end
  end
end
