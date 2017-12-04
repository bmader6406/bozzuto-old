class AddNoteToApartmentCommunities < ActiveRecord::Migration
  def change
    add_column :apartment_communities, :note, :string
  end
end
