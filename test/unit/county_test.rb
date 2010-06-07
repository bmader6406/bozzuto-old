require 'test_helper'

class CountyTest < ActiveSupport::TestCase
  context 'A County' do
    setup do
      @county = County.make
    end

    subject { @county }

    should_have_many :cities
    should_belong_to :state

    should_validate_presence_of :name, :state
    should_validate_uniqueness_of :name, :scoped_to => :state_id
  end
end
