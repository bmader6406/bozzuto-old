module Ckeditor
  module Routes
    def self.draw(router)
      # map.connect 'ckeditor/images', :controller => 'ckeditor', :action => 'images'
      # map.connect 'ckeditor/files', :controller => 'ckeditor', :action => 'files'
      # map.connect 'ckeditor/create', :controller => 'ckeditor', :action => 'create'

      router.instance_eval do
        get 'ckeditor/images' => 'ckeditor#images'
        get 'ckeditor/files'  => 'ckeditor#files'
        get 'ckeditor/create' => 'ckeditor#create'
      end
    end
  end
end
