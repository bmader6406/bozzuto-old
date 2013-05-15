require 'test_helper'

class BuzzTest < ActiveSupport::TestCase
  context "A Buzz" do
    setup { @buzz = Buzz.new }
    subject { @buzz }

    should_validate_presence_of :email

    should "save buzzes correctly" do
      @buzz.buzzes = {:hello => '1', :hi => '0', :hola => '1'}
      assert_same_elements(["hello", "hola"], @buzz.buzzes)
    end
    
    should "save affiliations correctly" do
      @buzz.affiliations = ['1', '0', '1']
      assert_same_elements(['1', '0', '1'], @buzz.affiliations)
    end

    context '#convert_checkboxes_to_string' do
      @buzz = Buzz.new

      context 'with hash' do
        setup do
          @data = { :one => 1, :two => 2, :three => 3 }
        end

        should 'join the keys with comma' do
          assert_same_elements @data.keys.map(&:to_s), 
            @buzz.send(:convert_checkboxes_to_string, @data).split(',')
        end
      end

      context 'with array' do
        setup { @data = [:one, :two, :three] }

        should 'join the elements with comma' do
          assert_equal @data.join(','),
            @buzz.send(:convert_checkboxes_to_string, @data)
        end
      end

      context 'with other value' do
        setup { @data = 123 }

        should 'return the string version of the input' do
          assert_equal @data.to_s,
            @buzz.send(:convert_checkboxes_to_string, @data)
        end
      end
    end

    context "#name" do
      setup do
        subject.first_name = 'Bruce'
        subject.last_name  = 'Wayne'
      end

      should "return the first name and last name, joined with a space" do
        assert_equal 'Bruce Wayne', subject.name
      end
    end
  end
end
