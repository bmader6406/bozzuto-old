require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  context 'Property' do
    setup do
      @property = Property.make
    end

    subject { @property }

    should_belong_to :city, :county
    should_have_one :slideshow
    should_have_many :landing_page_popular_orderings
    should_have_and_belong_to_many :property_features

    should_validate_presence_of :title, :city
    should_validate_numericality_of :latitude, :longitude
    should_ensure_length_in_range :short_title, (0..22)

    should_have_attached_file :listing_image
    should_have_attached_file :brochure
    
    should 'be archivable' do
      assert Property.acts_as_archive?
      assert_nothing_raised do
        Property::Archive
      end
      assert defined?(Property::Archive)
      assert Property::Archive.ancestors.include?(ActiveRecord::Base)
    end

    context 'when querying property type' do
      setup { @property = ApartmentCommunity.make }

      should 'return the type' do
        assert_equal @property.class.to_s, @property.property_type
      end
    end

    context 'when setting property type' do
      setup { @property = ApartmentCommunity.make }

      should 'set the type' do
        @property.property_type = 'HomeCommunity'
        assert_equal 'HomeCommunity', @property.property_type
      end
    end

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

      context 'with no separator parameter' do
        should "return the formatted address, separated by ', '" do
          assert_equal "#{@address}, #{@property.city}", @property.address
        end
      end

      context 'with separator parameter' do
        should "return the formatted address, separated by the provided separator" do
          assert_equal "#{@address}<br />#{@property.city}", @property.address('<br />')
        end
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

    context '#to_jmapping' do
      setup do
        @property = ApartmentCommunity.make :latitude => 1, :longitude => 2
      end

      should 'return a string with fields set' do
        assert_match /id: #{@property.id}/, @property.to_jmapping
        assert_match /lat: #{@property.latitude}/, @property.to_jmapping
        assert_match /lng: #{@property.longitude}/, @property.to_jmapping
        assert_match /category: '#{@property.class}'/, @property.to_jmapping
      end
    end

    context '#apartment?' do
      context 'when property is an apartment' do
        setup { @property = ApartmentCommunity.make }

        should 'be true' do
          assert @property.apartment?
        end
      end

      [HomeCommunity, Project].each do |klass|
        context "when property is #{klass}" do
          setup { @property = klass.make }

          should 'be false' do
            assert !@property.apartment?
          end
        end
      end
    end

    context '#home?' do
      context 'when property is a home community' do
        setup { @property = HomeCommunity.make }

        should 'be true' do
          assert @property.home?
        end
      end

      [ApartmentCommunity, Project].each do |klass|
        context "when property is #{klass}" do
          setup { @property = klass.make }

          should 'be false' do
            assert !@property.home?
          end
        end
      end
    end

    context '#project?' do
      context 'when property is a project' do
        setup { @property = Project.make }

        should 'be true' do
          assert @property.project?
        end
      end

      [ApartmentCommunity, HomeCommunity].each do |klass|
        context "when property is #{klass}" do
          setup { @property = klass.make }

          should 'be false' do
            assert !@property.project?
          end
        end
      end
    end

    context "#seo_link?" do
      setup do
        @property = ApartmentCommunity.make
      end

      context "when seo_link_text is blank" do
        should "return false" do
          @property.seo_link_text = ''

          assert !@property.seo_link?
        end
      end

      context "when seo_link_url is blank" do
        should "return false" do
          @property.seo_link_url = ''

          assert !@property.seo_link?
        end
      end

      context "when seo_link_text and seo_link_url are present" do
        should "return true" do
          @property.seo_link_text = 'click me'
          @property.seo_link_url = 'http://bukk.it'

          assert @property.seo_link?
        end
      end
    end
  end

  context 'The Property class' do
    context 'when querying for properties in a state' do
      setup do
        @state = State.make
        @city1 = City.make :state => @state
        @city2 = City.make :state => State.make

        @properties = (1..3).inject([]) { |array, i|
          array << Property.make(:city => @city1)
        }

        @other = Property.make :city => @city2
      end

      should 'return the properties' do
        assert_equal @properties, Property.in_state(@state)
      end
    end
  end
end
