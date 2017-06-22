class AddHylyIdToHomeCommunities < ActiveRecord::Migration
  def change
    add_column :home_communities, :hyly_id, :string
  end
end
