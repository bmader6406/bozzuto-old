require 'test_helper'

class Bozzuto::Data::InlineFontDestroyerTest < ActiveSupport::TestCase
  context 'Bozzuto::Data::InlineFontDestroyer' do
    before do
      @markup          ="<p>\r\n\t<span style=\"color:#808080;\"><span style=\"font-size:12px;\"><span style=\"font-family: arial, sans, sans-serif; white-space: pre-wrap;\">Cadence at Crown</span></span></span></p>\r\n"
      @expected_markup ="<p>\r\n\t<span><span><span style=\"white-space: pre-wrap;\">Cadence at Crown</span></span></span></p>\r\n"
      @record          = PropertyFeaturesPage.make(text_1: @markup, text_2: @markup, text_3: @markup)
      @other_record    = PropertyFeaturesPage.make(text_1: @markup, text_2: @markup, text_3: @markup)
    end

    subject { Bozzuto::Data::InlineFontDestroyer.new(PropertyFeaturesPage) }

    describe "#strip_font_styles!" do
      it "removes all font-related inline styles from the given model's text columns for each record" do
        subject.strip_font_styles!

        @record.reload.text_1.should eq @expected_markup
        @record.text_2.should eq @expected_markup
        @record.text_3.should eq @expected_markup

        @other_record.reload.text_1.should eq @expected_markup
        @other_record.text_2.should eq @expected_markup
        @other_record.text_3.should eq @expected_markup
      end

      context "when the destroyer is initialized with specific attributes" do
        subject { Bozzuto::Data::InlineFontDestroyer.new(PropertyFeaturesPage, attributes: :text_1) }

        it "removes all font-related inline styles from the given attributes for the given model's records" do
          subject.strip_font_styles!

          @record.reload.text_1.should eq @expected_markup
          @record.text_2.should eq @markup
          @record.text_3.should eq @markup

          @other_record.reload.text_1.should eq @expected_markup
          @other_record.text_2.should eq @markup
          @other_record.text_3.should eq @markup
        end
      end
    end
  end
end
