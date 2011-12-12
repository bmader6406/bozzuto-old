require 'test_helper'

class PhoneNumberHelperTest < ActionView::TestCase
  context 'PhoneNumberHelper' do

    context '#sanitize_phone_number' do
      should 'return just the digits' do
        ['1 (234) 567-8900', '1.234.567.8900', '1 234 567-8900'].each do |number|
          assert_equal '12345678900', sanitize_phone_number(number)
        end
      end
    end

    context '#format_phone_number' do
      context 'with a leading 1' do
        should 'format the phone number' do
          assert_equal '(234) 567-8900', format_phone_number('1.234.567.8900')
        end
      end

      context 'without a leading 1' do
        should 'format the phone number' do
          assert_equal '(234) 567-8900', format_phone_number('234.567.8900')
        end
      end

      context 'with an unknown format' do
        should 'return the number unchanged' do
          number = '+44-20-8123-4567'
          assert_equal number, format_phone_number(number)
        end
      end
    end

    context '#phone_number_uri' do
      context 'with a leading 1' do
        should 'return the tel uri' do
          assert_equal 'tel:+12345678900', phone_number_uri('1 (234) 567-8900')
        end
      end

      context 'without a leading 1' do
        should 'return the tel uri' do
          assert_equal 'tel:+12345678900', phone_number_uri('(234) 567-8900')
        end
      end

      context 'with an unknown format' do
        should 'return the tel uri with the number u' do
          assert_equal 'tel:+442081234567', phone_number_uri('+44-20-8123-4567')
        end
      end
    end

    context '#link_to_phone_number' do
      context 'with a block' do
        should 'generate a link with the phone number URI' do
          link = link_to_phone_number('1 (234) 567-8900', :class => 'yay') { 'Yay!' }

          assert_equal '<a href="tel:+12345678900" class="yay">Yay!</a>', link
        end
      end

      context 'without a block' do
        should 'generate a link with the phone number URI' do
          assert_equal '<a href="tel:+12345678900" class="yay">Yay!</a>',
            link_to_phone_number('Yay!', '1 (234) 567-8900', :class => 'yay')
        end
      end
    end

    context '#dnr_phone_number' do
      context 'with a home community' do
        setup do
          @community = HomeCommunity.make
          @number    = @community.phone_number.gsub(/\D/, '')
          @account   = APP_CONFIG[:callsource]['home'].to_s
        end

        context 'that does not have a customer code' do
          setup do
            stubs(:dnr_referrer).returns(nil)
          end

          should 'output the replaceNumber function call' do
            assert_match %r{replaceNumber\('#{@number}', 'xxx.xxx.xxxx', '#{@account}', 'undefined', 'undefined', 'undefined'\);},
              dnr_phone_number(@community)
          end
        end

        context 'that has DNR configured' do
          setup do
            stubs(:dnr_referrer).returns(nil)

            @dnr = DnrConfiguration.make_unsaved
            @community.dnr_configuration = @dnr
            @community.save
          end

          should 'output the replaceNumber function call' do
            assert_match %r{replaceNumber\('#{@number}', 'xxx.xxx.xxxx', '#{@account}', '#{@dnr.customer_code}', '#{@dnr.campaign}', '#{@dnr.ad_source}'\);},
              dnr_phone_number(@community)
          end
        end

        context 'referrer matches an existing DNR Referrer' do
          setup do
            stubs(:dnr_referrer).returns('apartments.com')
          end

          should 'output the replaceNumber function call with the domain as campaign and ad source' do
            assert_match %r{replaceNumber\('#{@number}', 'xxx.xxx.xxxx', '#{@account}', 'undefined', 'apartments.com', 'apartments.com'\);},
              dnr_phone_number(@community)
          end
        end

        context 'that has DNR configured and referrer matches an existing DNR Referrer' do
          setup do
            stubs(:dnr_referrer).returns('apartments.com')

            @dnr = DnrConfiguration.make_unsaved
            @community.dnr_configuration = @dnr
            @community.save
          end

          should 'output the replaceNumber function call with the domain as campaign and ad source' do
            assert_match %r{replaceNumber\('#{@number}', 'xxx.xxx.xxxx', '#{@account}', '#{@dnr.customer_code}', 'apartments.com', 'apartments.com'\);},
              dnr_phone_number(@community)
          end
        end
      end

      context 'with an apartment community' do
        setup do
          @community = ApartmentCommunity.make
          @number    = @community.phone_number.gsub(/\D/, '')
          @account   = APP_CONFIG[:callsource]['apartment'].to_s
        end

        context 'that does not have a customer code' do
          setup do
            stubs(:dnr_referrer).returns(nil)
          end

          should 'output the replaceNumber function call' do
            assert_match %r{replaceNumber\('#{@number}', 'xxx.xxx.xxxx', '#{@account}', 'undefined', 'undefined', 'undefined'\);},
              dnr_phone_number(@community)
          end
        end

        context 'that has DNR configured' do
          setup do
            stubs(:dnr_referrer).returns(nil)

            @dnr = DnrConfiguration.make_unsaved
            @community.dnr_configuration = @dnr
            @community.save
          end

          should 'output the replaceNumber function call' do
            assert_match %r{replaceNumber\('#{@number}', 'xxx.xxx.xxxx', '#{@account}', '#{@dnr.customer_code}', '#{@dnr.campaign}', '#{@dnr.ad_source}'\);},
              dnr_phone_number(@community)
          end
        end

        context 'referrer matches an existing DNR Referrer' do
          setup do
            stubs(:dnr_referrer).returns('rent.com')
          end

          should 'output the replaceNumber function call with the domain as campaign and ad source' do
            assert_match %r{replaceNumber\('#{@number}', 'xxx.xxx.xxxx', '#{@account}', 'undefined', 'rent.com', 'rent.com'\);},
              dnr_phone_number(@community)
          end
        end

        context 'that has DNR configured and referrer matches an existing DNR Referrer' do
          setup do
            stubs(:dnr_referrer).returns('rent.com')

            @dnr = DnrConfiguration.make_unsaved
            @community.dnr_configuration = @dnr
            @community.save
          end

          should 'output the replaceNumber function call with the domain as campaign and ad source' do
            assert_match %r{replaceNumber\('#{@number}', 'xxx.xxx.xxxx', '#{@account}', '#{@dnr.customer_code}', 'rent.com', 'rent.com'\);},
              dnr_phone_number(@community)
          end
        end
      end

    end
  end
end
