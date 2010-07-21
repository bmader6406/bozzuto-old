require 'yaml'
require 'fileutils'
require 'tmpdir'
require 'ckeditor/config'
require 'ckeditor/utils'
require 'ckeditor/view_helper'
require 'ckeditor/form_builder'

ActionView::Base.send(:include, Ckeditor::ViewHelper)
ActionView::Helpers::FormBuilder.send(:include, Ckeditor::FormBuilder)

Ckeditor::Utils.check_and_install

class ActionController::Routing::RouteSet
  unless (instance_methods.include?('draw_with_ckeditor'))
    class_eval <<-"end_eval", __FILE__, __LINE__  
      alias draw_without_ckeditor draw
      def draw_with_ckeditor
        draw_without_ckeditor do |map|
          map.connect 'ckeditor/images', :controller => 'ckeditor', :action => 'images'
          map.connect 'ckeditor/files',  :controller => 'ckeditor', :action => 'files'
          map.connect 'ckeditor/create', :controller => 'ckeditor', :action => 'create'
          yield map
        end
      end
      alias draw draw_with_ckeditor
    end_eval
  end
end
