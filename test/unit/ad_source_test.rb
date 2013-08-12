require 'test_helper'

class AdSourceTest < ActiveSupport::TestCase
  context 'An AdSource' do
    subject { AdSource.make }

    context 'when validating' do
      should_validate_presence_of :domain_name, :value
      should_validate_uniqueness_of :domain_name

      context 'domain includes protocol' do
        setup do
          subject.domain_name = 'http://bozzuto.com'
          assert !subject.valid?
        end

        should 'have errors on :domain_name' do
          assert_contains subject.errors.on(:domain_name), 'must not include http://'
        end
      end

      context 'domain name contains invalid characters' do
        %w(bozzuto com bozzuto;com bozzuto~com bozzuto..com).each do |domain|
          context(domain) do
            setup do
              subject.domain_name = 'bozzuto com'
              assert !subject.valid?
            end

            should 'have errors on :domain_name' do
              assert_equal 'contains invalid characters', subject.errors.on(:domain_name)
            end
          end
        end
      end

    end

    context 'when saving' do
      setup do
        subject.domain_name = 'bozzuto.com'
        subject.save
      end

      should 'write the pattern' do
        assert_equal 'bozzuto.com$', subject.pattern
      end
    end
  end

  context 'The Ad Source class' do
    setup do
      @apartments = AdSource.create(:domain_name => 'apartments.com', :value => 'apartments')
      @rent       = AdSource.create(:domain_name => 'rent.com',       :value => 'rent')
      @blah       = AdSource.create(:domain_name => 'blah.com',       :value => 'blah')
    end

    context 'when matching a domain' do
      context 'that is root-level' do
        should 'return the match' do
          assert_equal @apartments, AdSource.matching('apartments.com')
        end
      end

      context 'that is a sub-domain' do
        should 'return the match' do
          assert_equal @apartments, AdSource.matching('va.apartments.com')
        end
      end

      context 'that does not exist' do
        should 'return nil' do
          assert_nil AdSource.matching('yay.com')
        end
      end

      context 'that is not present' do
        should 'return nil' do
          assert_nil AdSource.matching(nil)
        end
      end
    end
  end
end
