require 'test_helper'

class StateTest < ActiveSupport::TestCase
  context "A State" do
    setup do
      @state = State.make
    end

    subject { @state }

    should_have_many :cities, :counties
    should_have_many :communities, :through => :cities

    should_validate_presence_of :code, :name
    should_ensure_length_is :code, 2
    should_validate_uniqueness_of :code, :name

    should 'use code as param' do
      assert_equal @state.code, @state.to_param
    end
  end
end
