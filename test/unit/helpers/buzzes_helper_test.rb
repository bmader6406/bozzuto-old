require 'test_helper'

class BuzzesHelperTest < ActionView::TestCase
  context "#mobile_check_box" do
    should "return check box nested in label tag" do
      form_for Buzz.new do |f|
        assert_match /<label.*><input.*<\/label>/,
          mobile_check_box(f, f.object.buzzes, :apartments)
      end
    end

    should "return custom label text" do
      form_for Buzz.new do |f|
        assert_match /APARTments/,
          mobile_check_box(f, f.object.buzzes, :apartments, 'APARTments')
      end
    end
  end

  private

  def buzzes_path(*args)
    '/bozzuto-buzz'
  end
end
