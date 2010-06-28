class RenameCommunityToApartmentCommunity < ActiveRecord::Migration
  def self.up
    query = "UPDATE properties SET type = 'ApartmentCommunity' WHERE type = 'Community'"
    ActiveRecord::Base.connection.execute(query)
  end

  def self.down
    query = "UPDATE properties SET type = 'Community' WHERE type = 'ApartmentCommunity'"
    ActiveRecord::Base.connection.execute(query)
  end
end
