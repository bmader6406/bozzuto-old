require 'yaml'
require 'fileutils'
require 'tmpdir'
require 'ckeditor/config'
require 'ckeditor/utils'
require 'ckeditor/view_helper'
require 'ckeditor/form_builder'
require 'ckeditor/routes'

ActionView::Base.send(:include, Ckeditor::ViewHelper)
ActionView::Helpers::FormBuilder.send(:include, Ckeditor::FormBuilder)

Ckeditor::Utils.check_and_install
