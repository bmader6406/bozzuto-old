require 'test_helper'

class PhoneNumberHelperTest < ActionView::TestCase
  context "PhoneNumberHelper" do

    describe "#sanitize_phone_number" do
      it "returns just the digits" do
        ['1 (234) 567-8900', '1.234.567.8900', '1 234 567-8900'].each do |number|
          sanitize_phone_number(number).should == '12345678900'
        end
      end
    end

    describe "#format_phone_number" do
      context "with a leading 1" do
        it "formats the phone number" do
          format_phone_number('1.234.567.8900').should == '(234) 567-8900'
        end
      end

      context "without a leading 1" do
        it "formats the phone number" do
          format_phone_number('234.567.8900').should == '(234) 567-8900'
        end
      end

      context "with an unknown format" do
        it "returns the number unchanged" do
          number = '+44-20-8123-4567'

          format_phone_number(number).should == number
        end
      end
    end

    describe "#phone_number_uri" do
      context "with a leading 1" do
        it "returns the tel uri" do
          phone_number_uri('1 (234) 567-8900').should == 'tel:+12345678900'
        end
      end

      context "without a leading 1" do
        it "returns the tel uri" do
          phone_number_uri('(234) 567-8900').should == 'tel:+12345678900'
        end
      end

      context "with an unknown format" do
        it "returns the tel uri with the number u" do
          phone_number_uri('+44-20-8123-4567').should == 'tel:+442081234567'
        end
      end
    end

    describe "#link_to_phone_number" do
      context "with a block" do
        it "generates a link with the phone number URI" do
          link = link_to_phone_number('1 (234) 567-8900', :class => 'yay') { 'Yay!' }

          link.should == '<a href="tel:+12345678900" class="yay">Yay!</a>'
        end
      end

      context "without a block" do
        it "generates a link with the phone number URI" do
          link = link_to_phone_number('Yay!', '1 (234) 567-8900', :class => 'yay')
          
          link.should == '<a href="tel:+12345678900" class="yay">Yay!</a>'
        end
      end
    end

    describe "#dnr_phone_number" do
      context "with a home community" do
        before do
          @community = HomeCommunity.make
          @number    = @community.phone_number.gsub(/\D/, '')
          @account   = APP_CONFIG[:callsource]['home'].to_s
        end

        context "no ad source and no DNR config" do
          it "outputs the correct replaceNumber function call" do
            dnr_phone_number(@community).should =~ dnr_regex(@number, @account, 'undefined', 'undefined')
          end
        end

        context "with ad source and DNR config" do
          before do
            @community.create_dnr_configuration(:customer_code => '1234')
          end

          it "outputs the correct replaceNumber function call" do
            dnr_phone_number(@community, 'batman').should =~ dnr_regex(@number, @account, '1234', 'batman')
          end
        end
      end

      context "with an apartment community" do
        before do
          @community = ApartmentCommunity.make
          @number    = @community.phone_number.gsub(/\D/, '')
          @account   = APP_CONFIG[:callsource]['apartment'].to_s
        end

        context "no ad source and no DNR config" do
          it "outputs the correct replaceNumber function call" do
            dnr_phone_number(@community).should =~ dnr_regex(@number, @account, 'undefined', 'undefined')
          end
        end

        context "with ad source and DNR config" do
          before do
            @community.create_dnr_configuration(:customer_code => '1234')
          end

          it "outputs the correct replaceNumber function call" do
            dnr_phone_number(@community, 'batman').should =~ dnr_regex(@number, @account, '1234', 'batman')
          end
        end
      end
    end
  end

  def dnr_regex(number, account, customer_code, ad_source)
    %r{replaceNumber\('#{number}', 'xxx.xxx.xxxx', '#{account}', '#{customer_code}', '#{ad_source}', '#{ad_source}'\);}
  end
end
