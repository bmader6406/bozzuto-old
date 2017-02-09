require 'test_helper'

class SearchResultProxyTest < ActiveSupport::TestCase
  context 'with cassette' do
    before do
      VCR.insert_cassette('search_proxy')
    end

    should validate_presence_of(:query)
    should validate_presence_of(:url)

    it "is invalid for a bad URL (bad domain)" do
      subject = SearchResultProxy.new(query: 'new apartment', url: 'http://totes-bogus-domain.com/')
      subject.valid?.should == false
      subject.errors[:url].should include("is invalid")
    end

    it "is invalid for a bad URL (bad path)" do
      subject = SearchResultProxy.new(query: 'new apartment', url: 'https://google.com/bogus/path')
      subject.valid?.should == false
      subject.errors[:url].should include("is invalid")
    end

    teardown do
      VCR.eject_cassette
    end
  end
end
