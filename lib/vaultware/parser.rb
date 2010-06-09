module Vaultware
  class Parser
    attr_reader :data

    def parse(file)
      @data = Nokogiri::XML(File.read(file))

      process_data
    end


    private

    def process_data
      data.xpath('/PhysicalProperty/Property', ns).each do |property|
        process_property(property)
      end
    end

    def process_property(property)
      info = property.at_xpath('PropertyID/ns:Identification', ns)

      community = Community.create({
        :title       => info.at_xpath('ns:MarketingName', ns).content,
        :subtitle    => 'blah blah blah',
        :website_url => info.at_xpath('ns:WebSite', ns).content,
        :city        => City.make
      })
    end

    def ns
      { 'ns' => 'http://my-company.com/namespace' }
    end
  end
end
