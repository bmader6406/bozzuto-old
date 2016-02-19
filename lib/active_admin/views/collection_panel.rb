module ActiveAdmin
  module Views
    module CollectionPanel
      extend ActiveSupport::Concern

      included do
        def collection_panel_for(association, receiver: resource, &block) 
          collection = receiver.send(association)
          
          panel nil do
            if collection.try(:any?)
              yield
            else
              div class: 'blank_slate_container' do
                span class: 'blank_slate' do
                  span 'No ' + association.to_s.titleize 
                end
              end
            end
          end
        end
      end
    end
  end
end
