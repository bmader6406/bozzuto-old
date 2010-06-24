require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  context 'Property' do
    setup do
      @property = Property.make
    end

    subject { @property }

    should_belong_to :city

    should_validate_presence_of :title, :city
    should_validate_numericality_of :latitude, :longitude

    context "#address" do
      setup do
        @address = '202 Rigsbee Ave'
        @property = Property.make(:street_address => @address)
      end

      should "return the formatted address" do
        assert_equal "#{@address}, #{@property.city}", @property.address
      end
    end

    context '#typus_name' do
      should 'return the title' do
        assert_equal @property.title, @property.typus_name
      end
    end

    context '#county' do
      setup do
        @county = County.make
        @property = Community.make(:city => City.make(:county => @county))
      end

      should "return the city's county" do
        assert_equal @county, @property.county
      end
    end

    context '#state' do
      setup do
        @state = State.make
        @property = Property.make(:city => City.make(:state => @state))
      end

      should "return the city's state" do
        assert_equal @state, @property.state
      end
    end

  end
end
