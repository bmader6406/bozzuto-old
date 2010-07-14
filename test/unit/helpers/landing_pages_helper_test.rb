require 'test_helper'

class LandingPagesHelperTest < ActionView::TestCase
  context '#popular_property_class' do
    [HomeCommunity, ApartmentCommunity, Project].each do |klass|
      context "when property is a #{klass}" do
        should 'return the class name' do
          assert_equal klass.to_s.underscore.gsub(/_/, '-'),
            popular_property_class(klass.new)
        end
      end
    end
  end
end
