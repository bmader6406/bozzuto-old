require 'test_helper'

class GreenPackageTest < ActiveSupport::TestCase
  subject { GreenPackage.make }

  should_belong_to(:home_community)
  should_have_many(:green_package_items, :dependent => :destroy)
  should_have_many(:green_features, :through => :green_package_items)

  should_validate_presence_of(:home_community)
  should_validate_presence_of(:ten_year_old_cost)

  should_validate_attachment_presence(:photo)

  context '#home_community_title' do
    setup do
      subject.stubs(:home_community).returns(stub(:title => 'Yay'))
    end

    should "return the home community title" do
      assert_equal 'Yay', subject.home_community_title
    end
  end

  context '#has_ultra_green_features?' do
    context 'no ultra green items' do
      setup do
        GreenPackageItem.make(:green_package => subject)
      end

      should 'return false' do
        assert !subject.has_ultra_green_features?
      end
    end

    context 'has ultra green items' do
      setup do
        GreenPackageItem.make(:ultra_green, :green_package => subject)
      end

      should 'return true' do
        assert subject.has_ultra_green_features?
      end
    end
  end

  context '#has_graph?' do
    context "title and image aren't present" do
      setup do
        subject.graph_title = nil
        subject.graph.stubs(:present?).returns(false)
      end

      should 'return false' do
        assert !subject.has_graph?
      end
    end

    context "title and image are present" do
      setup do
        subject.graph_title = 'Hooray'
        subject.graph.expects(:present?).returns(true)
      end

      should 'return true' do
        assert subject.has_graph?
      end
    end
  end

  context 'calculating total_savings' do
    setup do
      GreenPackageItem.make(:savings => 10, :green_package => subject)
      GreenPackageItem.make(:savings => 10, :green_package => subject)
      GreenPackageItem.make(:ultra_green, :savings => 30, :green_package => subject)
    end

    context 'without ultra green features' do
      should 'return total' do
        assert_equal 20, subject.total_savings
      end
    end

    context 'with ultra green features' do
      should 'return total' do
        assert_equal 50, subject.total_savings_with_ultra_green
      end
    end
  end

  context '#annual_savings' do
    setup do
      subject.expects(:total_savings).returns(5)
      subject.ten_year_old_cost = 100
    end

    should 'return the percentage' do
      assert_equal 5, subject.annual_savings
    end
  end

  context '#annual_savings_with_ultra_green' do
    setup do
      subject.expects(:total_savings_with_ultra_green).returns(5)
      subject.ten_year_old_cost = 100
    end

    should 'return the percentage' do
      assert_equal 5, subject.annual_savings_with_ultra_green
    end
  end
end
