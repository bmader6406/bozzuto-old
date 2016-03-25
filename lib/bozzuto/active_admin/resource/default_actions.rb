module Bozzuto
  module ActiveAdmin
    module Resource
      module DefaultActions
        extend ActiveSupport::Concern

        included do
          private

          def add_default_action_items
            add_default_new_action_item
            add_default_edit_action_item
            add_default_show_action_item
            add_default_destroy_action_item
          end

          def add_default_show_action_item
            add_action_item :show, only: :edit do
              if controller.action_methods.include?('show') && authorized?(::ActiveAdmin::Auth::READ, resource)
                link_to I18n.t('active_admin.details', model: active_admin_config.resource_label), resource_path(resource)
              end
            end
          end

          def add_default_destroy_action_item
            add_action_item :destroy, only: :show do
              if controller.action_methods.include?('destroy') && authorized?(::ActiveAdmin::Auth::DESTROY, resource)
                link_to I18n.t('active_admin.delete_model', model: active_admin_config.resource_label), resource_path(resource),
                method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
              end
            end

            add_action_item :destroy, only: :edit do
              if controller.action_methods.include?('destroy') && authorized?(::ActiveAdmin::Auth::DESTROY, resource)
                link_to I18n.t('active_admin.delete_model', model: active_admin_config.resource_label), resource_path(resource),
                method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')}
              end
            end
          end
        end
      end
    end
  end
end
