module Analytics
  class DoubleClick < Struct.new(:options)
    def floodlight_tag_script
      <<-END.html_safe
        <!--
          Start of DoubleClick Floodlight Tag: Please do not remove
          Activity name of this tag: #{description}
          URL of the webpage where the tag is expected to be placed: http://www.bozzuto.com
          This tag must be placed between the <body> and </body> tags, as close as possible to the opening tag.
          Creation Date: 07/01/2014
        -->

        <script type="text/javascript">
          var axel = Math.random() + "";
          var a = axel * 10000000000000;
          document.write('<#{tag_type} src="http://4076175.fls.doubleclick.net/#{activity_type};src=4076175;#{type}#{cat}#{u1}ord=1;num=' + a + '?" width="1" height="1" #{tag_ending}');
        </script>

        <noscript>
          <#{tag_type} src="http://4076175.fls.doubleclick.net/#{activity_type};src=4076175;#{type}#{cat}#{u1}#{ord}" width="1" height="1" #{tag_ending}
        </noscript>

        <!-- End of DoubleClick Floodlight Tag: Please do not remove -->
      END
    end

    private

    def u1
      "u1=#{property_name};" if property_name
    end

    def cat
      "cat=#{options[:cat]};" if options[:cat]
    end

    def type
      "type=#{options[:type]};" if options[:type]
    end

    def ord
      if options[:fixed_ord]
        "ord=1;num='+ a + '?"
      else
        "ord='+ a + '?"
      end
    end

    def description
      options[:description]
    end

    def property_name
      URI.encode(options[:name]) if options[:name]
    end

    def image?
      options[:image]
    end

    def tag_type
      image? ? 'img' : 'iframe'
    end

    def activity_type
      image? ? 'activity' : 'activityi'
    end

    def tag_ending
      image? ? "alt=\"\"/>" : "frameborder=\"0\" style=\"display:none\"></iframe>"
    end
  end
end
