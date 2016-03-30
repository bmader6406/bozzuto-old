require 'test_helper'

class EmojiTest < ActiveSupport::TestCase
  context "Emoji" do
    describe ".strip!" do
      before do
        @example1 = "MySQL, y u do dis? \xF0\x9F\x98\x96"
        @example2 = 'Our hearts are with #Brussels today ❤️🇧🇪 #100parkapts #Bozzuto'
        @example3 = 'Happy Easter from 100 Park! 🌷🐰 #100parkapts #Bozzuto #Easter'
      end

      it "removes emojis from the given string" do
        Emoji.strip!(@example1)
        Emoji.strip!(@example2)
        Emoji.strip!(@example3)

        @example1.should == 'MySQL, y u do dis?'
        @example2.should == 'Our hearts are with #Brussels today ️ #100parkapts #Bozzuto'
        @example3.should == 'Happy Easter from 100 Park!  #100parkapts #Bozzuto #Easter'
      end
    end
  end
end
