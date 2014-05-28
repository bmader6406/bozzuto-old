require 'test_helper'

class ExternalCmsTest < ActiveSupport::TestCase
  context 'A resource instance' do
    %w(vaultware property_link rent_cafe psi).each do |type|
      context "when managed by #{type.titlecase}" do
        setup { @community = ApartmentCommunity.make(type.to_sym) }

        context "#managed_by_#{type}?" do
          should 'be true' do
            assert @community.send("managed_by_#{type}?")
          end
        end

        context "#managed_externally?" do
          should 'be true' do
            assert @community.managed_externally?
          end
        end

        context '#external_cms_name' do
          should "call feed_name on ExternalFeedLoader" do
            Bozzuto::ExternalFeedLoader.expects(:feed_name).with(type)

            @community.external_cms_name
          end
        end
      end

      context "when community is not managed by #{type.titlecase}" do
        setup { @community = ApartmentCommunity.make }

        should 'be false' do
          assert !@community.send("managed_by_#{type}?")
        end
      end
    end
  end

  context 'The resource class' do
    setup do
      @vaultware     = ApartmentCommunity.make(:vaultware)
      @property_link = ApartmentCommunity.make(:property_link)
      @other         = ApartmentCommunity.make
    end

    context 'managed_by_* named scopes' do
      context 'vaultware' do
        should 'return only the Vaultware resources' do
          assert_equal [@vaultware], ApartmentCommunity.managed_by_vaultware.all
        end
      end

      context 'property_link' do
        should 'return only the PropertyLink resources' do
          assert_equal [@property_link], ApartmentCommunity.managed_by_property_link.all
        end
      end
    end

    context 'managed_locally named scope' do
      should 'return only the local resource' do
        assert_equal [@other], ApartmentCommunity.managed_locally
      end
    end
  end
end
