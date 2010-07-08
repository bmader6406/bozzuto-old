module Bozzuto
  module FlickrMocks
    class FlickrSet
      attr_accessor :id, :title, :photos

      def initialize(id, title)
        self.id     = id
        self.title  = title
        self.photos = []
      end
    end
  end
end
