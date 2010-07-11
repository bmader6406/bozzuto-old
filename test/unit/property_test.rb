require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  context 'Property' do
    setup do
      @property = Property.make
    end

    subject { @property }

    should_belong_to :city, :county
    should_have_one :slideshow, :mini_slideshow
    should_have_and_belong_to_many :property_features

    should_validate_presence_of :title, :city
    should_validate_numericality_of :latitude, :longitude
    should_ensure_length_in_range :short_title, (0..22)

    should_have_attached_file :listing_image
    should_have_attached_file :brochure

    context '#mappable?' do
      setup do
        @property.latitude = 10
        @property.longitude = 10
      end

      should 'return true if latitude and longitude are both present' do
        assert @property.mappable?
      end

      should "return false if latitude or longitude isn't present" do
        @property.latitude = nil
        assert !@property.mappable?

        @property.latitude = 10
        @property.longitude = nil
        assert !@property.mappable?
      end
    end

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

    context '#state' do
      setup do
        @state = State.make
        @property = Property.make(:city => City.make(:state => @state))
      end

      should "return the city's state" do
        assert_equal @state, @property.state
      end
    end

    context '#uses_brochure_url?' do
      context 'when brochure_type is USE_BROCHURE_URL' do
        setup do
          @property.brochure_type = Property::USE_BROCHURE_URL
        end

        should 'return true' do
          assert @property.uses_brochure_url?
        end
      end

      context 'when brochure_type is USE_BROCHURE_FILE' do
        setup do
          @property.brochure_type = Property::USE_BROCHURE_FILE
        end

        should 'return false' do
          assert !@property.uses_brochure_url?
        end
      end
    end

    context '#uses_brochure_file?' do
      context 'when brochure_type is USE_BROCHURE_URL' do
        setup do
          @property.brochure_type = Property::USE_BROCHURE_URL
        end

        should 'return false' do
          assert !@property.uses_brochure_file?
        end
      end

      context 'when brochure_type is USE_BROCHURE_FILE' do
        setup do
          @property.brochure_type = Property::USE_BROCHURE_FILE
        end

        should 'return true' do
          assert @property.uses_brochure_file?
        end
      end
    end
  end
end
