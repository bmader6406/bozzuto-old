module ActiveAdmin
  module Views
    module AssociationTable
      extend ActiveSupport::Concern

      included do
        def association_table_for(association, receiver: resource, &block)
          collection = receiver.send(association)

          div class: 'association_table_add_link'  do
            link_to "Add New", polymorphic_url([:new, :new_admin, association.to_s.singularize.to_sym]), class: "button"
          end

          if collection.any?
            insert_tag(ActiveAdmin::Views::IndexAsTable::IndexTableFor, collection) do
              yield

              column nil, class: 'col-actions' do |resource|
                div class: 'table_actions' do
                  link_to I18n.t('active_admin.view'), polymorphic_url([:new_admin, resource])
                  link_to I18n.t('active_admin.edit'), polymorphic_url([:edit, :new_admin, resource])
                  link_to I18n.t('active_admin.delete'), polymorphic_url([:new_admin, resource]), method: :delete, data: { confirm: I18n.t('active_admin.delete_confirmation') }
                end
              end
            end
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
