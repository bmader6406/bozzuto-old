require 'test_helper'

class BuzzTest < ActiveSupport::TestCase
  context "A Buzz" do
    should_validate_presence_of :email

    should "save buzzes correctly" do
      buzz = Buzz.new
      buzz.buzzes = {:hello => '1', :hi => '0', :hola => '1'}
      assert_same_elements(["hello", "hola"], buzz.buzzes)
    end
    
    should "save affiliations correctly" do
      buzz = Buzz.new
      buzz.affiliations = {:hello => '1', :hi => '0', :hola => '1'}
      assert_same_elements(["hello", "hola"], buzz.affiliations)
    end
  end
end
