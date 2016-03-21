class AddContactFormNoteAndThankYouTextToContactPages < ActiveRecord::Migration
  def change
    add_column :property_contact_pages, :contact_form_note, :text
    add_column :property_contact_pages, :thank_you_text,    :text
  end
end
