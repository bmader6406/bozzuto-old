class AddDescriptionAndCtaToHomePageSlides < ActiveRecord::Migration
  def change
    add_column :home_page_slides, :call_to_action, :string
    add_column :home_page_slides, :description,    :string
  end
end
