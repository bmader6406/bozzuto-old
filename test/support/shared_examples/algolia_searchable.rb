module AlgoliaSearchable
  include SharedExamples

  shared_example_for "being searchable with algolia" do |described_class, attribute|

    context 'without transactions' do
      setup do
        DatabaseCleaner.start
      end

      context "indexing" do
        it "indexes when creating a record" do
          described_class.expects(:algolia_index!).returns(true)
          described_class.make
        end
      end

      context 'searching' do
        it "returns the correct result" do
          erb_options = {attribute_name: attribute.to_s, :klass_name => described_class.name}
          request_matchers = [:method, :algolia_path_matcher, :algolia_host_matcher]

          VCR.use_cassette("algolia_search", erb: erb_options, :match_requests_on => request_matchers) do
            described_class.algolia_clear_index!(true)

            described_class.make(attribute => "Testing 1", id: 1234567891)
            described_class.make(attribute => "Testing 2", id: 1234567892)
            described_class.make(attribute => "Testing 3", id: 1234567893)
            described_class.make(attribute => "#{described_class.name} Throne room", id: 1234567894)

            results = described_class.algolia_raw_search("#{described_class.name} Throne room")

            results["hits"][0][attribute.to_s].should == "#{described_class.name} Throne room"
          end
        end
      end

      teardown do
        VCR.use_cassette("algolia_teardown", :match_requests_on => [:method, :algolia_path_matcher, :algolia_host_matcher]) do
          described_class.algolia_clear_index!(true)
        end
        DatabaseCleaner.clean
      end
    end
  end
end
