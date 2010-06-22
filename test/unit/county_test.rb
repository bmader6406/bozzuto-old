require 'test_helper'

class CountyTest < ActiveSupport::TestCase
  context 'A County' do
    setup do
      @county = County.make
    end

    subject { @county }

    should_belong_to :state
    should_have_many :cities
    should_have_many :communities, :through => :cities

    should_validate_presence_of :name, :state
    should_validate_uniqueness_of :name, :scoped_to => :state_id

    context '#to_s' do
      should 'return the county name and state' do
        assert_equal "#{@county.name}, #{@county.state.code}", @county.to_s
      end
    end
  end
end
