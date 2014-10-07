module Ckeditor
  module Routes
    def self.draw(router)
      # map.connect 'ckeditor/images', :controller => 'ckeditor', :action => 'images'
      # map.connect 'ckeditor/files', :controller => 'ckeditor', :action => 'files'
      # map.connect 'ckeditor/create', :controller => 'ckeditor', :action => 'create'

      router.instance_eval do
        match 'ckeditor/images' => 'ckeditor#images'
        match 'ckeditor/files'  => 'ckeditor#files'
        match 'ckeditor/create' => 'ckeditor#create'
      end
    end
  end
end
