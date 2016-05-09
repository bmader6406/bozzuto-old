# Included from activeadmin_reorderable
ActiveAdmin::Views::ActiveAdminForm.send(:include, ActiveAdmin::Reorderable::TableMethods)

# Bozzuto customizations
ActiveAdmin::Views::ActiveAdminForm.send(:include, Bozzuto::ActiveAdmin::Views::AssociationTable)
ActiveAdmin::Views::Pages::Show.send(:include, Bozzuto::ActiveAdmin::Views::CollectionPanel)
ActiveAdmin::Resource::ActionItems.send(:include, Bozzuto::ActiveAdmin::Resource::DefaultActions)

# Redirect to return_to path if available
ActiveAdmin::ResourceController.send(:include, Bozzuto::ActiveAdmin::ActionRedirects)

# Find pages by ID in Admin
ActiveAdmin::BaseController.send(:include, Bozzuto::ActiveAdmin::PageFinding)
