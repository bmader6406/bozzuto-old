require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  context 'Property' do
    setup do
      @property = Property.make
    end

    subject { @property }

    context '#to_s' do
      should 'return the title' do
        assert_equal @property.title, @property.to_s
      end
    end

    context '#uses_brochure_url?' do
      context 'when brochure_type is USE_BROCHURE_URL' do
        setup do
          @property.brochure_url = "https://google.com"
        end

        should 'return true' do
          assert @property.uses_brochure_url?
        end
      end

      context 'when brochure_type is USE_BROCHURE_FILE' do
        setup do
          @property.brochure_url = nil
        end

        should 'return false' do
          assert !@property.uses_brochure_url?
        end
      end
    end

    context '#uses_brochure_file?' do
      context 'when brochure_type is USE_BROCHURE_URL' do
        setup do
          @property.brochure = nil
        end

        should 'return false' do
          assert !@property.uses_brochure_file?
        end
      end

      context 'when brochure_type is USE_BROCHURE_FILE' do
        setup do
          @property.brochure = ::File.open("test/files/psi.xml")
        end

        should 'return true' do
          assert @property.uses_brochure_file?
        end
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

    describe "#as_jmapping" do
      subject { Property.new(:title => "Batman's Batcave") }

      it "returns the title with HTML entities" do
        subject.as_jmapping[:name].should == Rack::Utils.escape_html("Batman's Batcave")
      end
    end

    describe "#phone_number" do
      subject { ApartmentCommunity.make(phone_number: '8153813919') }

      it "returns a period-separated phone number" do
        subject.phone_number.should == '815.381.3919'
      end
    end

    describe "#mobile_phone_number" do
      subject { ApartmentCommunity.make(mobile_phone_number: '8153813919') }

      it "returns a period-separated mobile phone number" do
        subject.mobile_phone_number.should == '815.381.3919'
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
