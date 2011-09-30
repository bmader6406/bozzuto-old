require 'test_helper'

class DnrReferrerTest < ActiveSupport::TestCase
  context 'A DNR Referrer' do
    setup   { @referrer = DnrReferrer.new }
    subject { @referrer }

    context 'when validating' do
      should_validate_presence_of :domain_name

      context 'domain includes protocol' do
        setup do
          @referrer.domain_name = 'http://bozzuto.com'
          assert !@referrer.valid?
        end

        should 'have errors on :domain_name' do
          assert_contains @referrer.errors.on(:domain_name), 'must not include http://'
        end
      end

      context 'domain name contains invalid characters' do
        %w(bozzuto com bozzuto;com bozzuto~com bozzuto..com).each do |domain|
          context(domain) do
            setup do
              @referrer.domain_name = 'bozzuto com'
              assert !@referrer.valid?
            end

            should 'have errors on :domain_name' do
              assert_equal 'contains invalid characters', @referrer.errors.on(:domain_name)
            end
          end
        end
      end

    end

    context 'when saving' do
      setup do
        @referrer.domain_name = 'bozzuto.com'
        @referrer.save
      end

      should 'write the pattern' do
        assert_equal 'bozzuto.com$', @referrer.pattern
      end
    end
  end

  context 'The DNR Referrer class' do
    setup do
      %w(apartments.com rent.com blah.com).each { |domain|
        DnrReferrer.create :domain_name => domain
      }
    end

    context 'when matching a domain' do
      context 'that is root-level' do
        should 'return the match' do
          assert_equal 'apartments.com', DnrReferrer.matching('apartments.com')
        end
      end

      context 'that is a sub-domain' do
        should 'return the match' do
          assert_equal 'apartments.com', DnrReferrer.matching('va.apartments.com')
        end
      end

      context 'that does not exist' do
        should 'return nil' do
          assert_nil DnrReferrer.matching('yay.com')
        end
      end

      context 'that is not present' do
        should 'return nil' do
          assert_nil DnrReferrer.matching(nil)
        end
      end
    end
  end
end
