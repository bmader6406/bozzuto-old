require 'test_helper'

class PressReleasesControllerTest < ActionController::TestCase
  context 'PressReleasesController' do
    setup do
      @about = Section.make :about
      @press_release = PressRelease.make :sections => [@about]
    end

    context 'a GET to #index' do
      all_devices do
        setup do
          get :index, :section => @about.to_param
        end

        should_respond_with :success
        should_render_template :index
        should_assign_to(:press_releases) { [@press_release] }
      end
    end

    context 'a GET to #show' do
      all_devices do
        setup do
          get :show, :section          => @about.to_param,
                     :press_release_id => @press_release.id
        end

        should_respond_with :success
        should_render_template :show
        should_assign_to(:press_release) { @press_release }
      end
    end
  end
end
