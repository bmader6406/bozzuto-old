ActiveAdmin::Views::ActiveAdminForm.send(:include, ActiveAdmin::Reorderable::TableMethods)
ActiveAdmin::Views::Pages::Show.send(:include, ActiveAdmin::Views::CollectionPanel)
