module Ckeditor
  module Routes
    def self.draw(map)
      map.connect 'ckeditor/images', :controller => 'ckeditor', :action => 'images'
      map.connect 'ckeditor/files', :controller => 'ckeditor', :action => 'files'
      map.connect 'ckeditor/create', :controller => 'ckeditor', :action => 'create'
    end
  end
end
