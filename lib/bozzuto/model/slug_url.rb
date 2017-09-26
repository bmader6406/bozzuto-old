module Bozzuto
  module Model
    module SlugUrl
      def self.to_readable_url(s)
        #strip the string
        ret = s.strip
        
        #blow away apostrophes
        ret.gsub! /['`]/,""

        # @ --> at, and & --> and
        ret.gsub! /\s*@\s*/, " at "
        ret.gsub! /\s*&\s*/, " and "

        #replace all non alphanumeric, underscore or periods with underscore
        ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'  

        #convert double underscores to single
        ret.gsub! /-+/,"-"

        #strip off full stop
        ret.gsub! /\./,""

        #strip off leading/trailing underscore
        ret.gsub! /\A[-\.]+|[-\.]+\z/,""

        ret
      end
    end
  end
end