require 'test_helper'

class ServiceNewsControllerTest < ActionController::TestCase
  context 'ServiceNewsController' do
    setup do
      @service = Service.make
      @section = @service.section

      @news = []
      3.times do
        @news << NewsPost.make(:section => @section)
      end
      NewsPost.make :unpublished, :section => @section
    end

    context 'a GET to #index' do
      setup do
        get :index, :service_id => @service.to_param
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:service)    { @service }
      should_assign_to(:section)    { @section }
      should_assign_to(:news_posts) { @news }
    end

    context 'a GET to #show' do
      setup do
        @post = @news.first
        get :show, :service_id => @service.to_param, :id => @post.id
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:service) { @service }
      should_assign_to(:section) { @section }
      should_assign_to(:post)    { @post }
    end
  end
end
