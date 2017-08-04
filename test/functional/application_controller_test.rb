require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  context "ApplicationController" do
    describe "#page_number" do
      context "params[:page] is nil" do
        before do
          @controller.stubs(:params => {})
        end

        it "returns 1" do
          @controller.send(:page_number).should == 1
        end
      end

      context "params[:page] is a rando string" do
        before do
          @controller.stubs(:params => { :page => 'blah blah blah' })
        end

        it "returns 1" do
          @controller.send(:page_number).should == 1
        end
      end

      context "params[:page] is 0" do
        before do
          @controller.stubs(:params => { :page => '' })
        end

        it "returns 1" do
          @controller.send(:page_number).should == 1
        end
      end

      context "params[:page] is a valid number" do
        before do
          @controller.stubs(:params => { :page => '123' })
        end

        it "returns the number" do
          @controller.send(:page_number).should == 123
        end
      end
    end

    context '#states helper method' do
      setup do
        5.times { State.make }
        @states = State.ordered_by_name
      end

      should 'return all states' do
        assert_equal @states, @controller.send(:states)
      end
    end

    context '#services helper method' do
      setup do
        5.times { Section.make(:service) }
        @services = Section.services.ordered_by_title
      end

      should 'return all states' do
        assert_equal @services, @controller.send(:services)
      end
    end

    context '#about_root_pages helper method' do
      context 'when no About section exists' do
        should 'return an empty array' do
          assert_equal [], @controller.send(:about_root_pages)
        end
      end

      context 'when no pages exist' do
        setup do
          @section = Section.make(:about)
        end

        should 'return an empty array' do
          assert_equal [], @controller.send(:about_root_pages)
        end
      end

      context 'when pages exist' do
        setup do
          @section = Section.make(:about)
          @page1 = Page.make :section => @section
          @page2 = Page.make :section => @section

          @page2.move_to_child_of(@page1)
        end

        should 'return the roots' do
          @controller.send(:about_root_pages).all.should == @section.pages.roots
        end
      end
    end

    context '#mobile? helper method' do
      context 'when request format is not :mobile' do
        setup { @controller.request.format = :html }

        should 'return false' do
          assert !@controller.send(:mobile?)
        end
      end

      context 'when request format is :mobile' do
        setup { @controller.request.format = :mobile }

        should 'return true' do
          assert @controller.send(:mobile?)
        end
      end
    end

    context '#viget_ip? method' do
      %w(
        70.182.186.96
        70.182.186.99
        70.182.186.100
        70.182.186.119
        70.182.186.120
        70.182.186.127
        96.10.0.146
        96.49.115.54
        67.176.76.149
        173.8.242.217
        50.52.128.102
      ).each do |valid_ip|
        context "with valid IP #{valid_ip}" do
          setup do
            @controller.stubs(:request).returns(stub(:remote_ip => valid_ip))
          end

          should 'return true' do
            assert @controller.send(:viget_ip?)
          end
        end
      end

      %w(
        192.168.0.1
        127.0.0.1
        0.0.0.0
        123.456.789.123
      ).each do |invalid_ip|
        context "with invalid IP #{invalid_ip}" do
          setup do
            @controller.stubs(:request).returns(stub(:remote_ip => invalid_ip))
          end

          should 'return true' do
            assert !@controller.send(:viget_ip?)
          end
        end
      end

    end
  end
end
