require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  context 'Home' do
    setup do
      @home = Home.make
    end

    subject { @home }

    should_belong_to :home_community
    should_have_many :floor_plans

    should_validate_presence_of :home_community,
      :bedrooms,
      :bathrooms

    should_validate_numericality_of :bedrooms,
      :bathrooms
  end
end
