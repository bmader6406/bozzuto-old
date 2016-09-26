module Bozzuto
  module Data
    class InlineFontDestroyer
      # There are problematic inline font styles in WYSIWYG text.
      #   * style="color:#808080;"
      #   * style="font-size:12px;"
      #   * style="font-family: arial, sans, sans-serif;"
      #
      #   This class takes a model & an optional array of attributes
      #   to strip inline font styles from.  Example usage:
      #
      #     Bozzuto::Data::InlineFontDestroyer.new(ApartmentCommunity).strip_font_styles!
      #
      #   Every ApartmentCommunity record in this case would have every
      #   text-type column stripped of color, font size, and font family
      #   inline styles.

      STYLES = %w(
        color
        font-size
        font-family
      )

      attr_reader :model, :attributes

      def initialize(model, attributes: [])
        @model      = model
        @attributes = Array(attributes).presence || model.columns.select do |column|
          column.type == :text
        end.map(&:name)
      end

      def strip_font_styles!
        model.find_each do |record|
          attrs = stripped_attributes_for(record)

          if attrs.any?
            record.update_attributes(attrs) and report(record, attrs)
          end
        end
      end

      private

      def stripped_attributes_for(record)
        attributes.reduce(Hash.new) do |attrs, attribute|
          value = strip_font_styles_from(record.read_attribute(attribute))

          if value.present?
            attrs.merge(attribute => value)
          else
            attrs
          end
        end
      end

      def strip_font_styles_from(text)
        return unless text.is_a? String

        html   = Nokogiri::HTML(text)
        styles = html.xpath('//@style')

        return if styles.none?

        html.xpath('//@style').each do |style_attribute|
          STYLES.each do |style|
            value = style_attribute.value.gsub(/#{style}:[^;]*;/, '').strip

            if value.present?
              style_attribute.value = value
            else
              style_attribute.remove
            end
          end
        end

        html.xpath('//body').children.to_s
      end

      def report(record, attrs)
        unless Rails.env.test?
          puts "#{model} ##{record.id}: Stripped inline font styles from #{attrs.keys.to_sentence}"
        end
      end
    end
  end
end
