require 'test_helper'

class EmojiTest < ActiveSupport::TestCase
  context "Emoji" do
    describe ".strip!" do
      subject { "MySQL, y u do dis? \xF0\x9F\x98\x96" }

      it "removes emojis from the given string" do
        Emoji.strip!(subject)

        subject.should == 'MySQL, y u do dis?'
      end
    end
  end
end
