module ActiveAdmin
  module Views
    module AssociationTable
      extend ActiveSupport::Concern

      included do
        def association_table_for(association, receiver: resource, scope: nil, reorderable: false, &block)
          table_config = resource.class.reflect_on_all_associations.find { |a| a.name == association }
          collection   = Array(scope || receiver.send(association))
          route_symbol = table_config.klass.model_name.singular_route_key
          new_options  = { route_symbol => { table_config.foreign_key => resource.id } }
          table_type   = if reorderable
            ActiveAdmin::Views::ReorderableTableFor
          else
            ActiveAdmin::Views::IndexAsTable::IndexTableFor
          end

          unless table_config.macro == :has_one && collection.any?
            div class: 'association_table_add_link'  do
              link_to "Add New", polymorphic_url([:new, :new_admin, route_symbol], new_options), class: 'button', target: :blank
            end
          end

          if collection.any?
            panel nil do
              insert_tag table_type, collection do
                yield

                column nil, class: 'col-actions' do |resource|
                  div class: 'table_actions' do
                    link_to I18n.t('active_admin.view'), polymorphic_url([:new_admin, resource])
                    link_to I18n.t('active_admin.edit'), polymorphic_url([:edit, :new_admin, resource])
                    link_to I18n.t('active_admin.delete'), polymorphic_url([:new_admin, resource]), method: :delete, data: { confirm: I18n.t('active_admin.delete_confirmation') }
                  end
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
