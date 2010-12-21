class CreateDnrConfigurations < ActiveRecord::Migration
  def self.up
    create_table :dnr_configurations do |t|
      t.string  :customer_code
      t.string  :campaign
      t.string  :ad_source
      t.integer :property_id, :null => false

      t.timestamps
    end

    unless Rails.env.test?
      [HomeCommunity, ApartmentCommunity].each do |klass|
        klass.all.each do |community|
          id   = community.id
          code = community.dnr_customer_code

          if code.present?
            DnrConfiguration.create(
              :customer_code => code,
              :property_id   => id
            )
          end
        end
      end
    end

    remove_column :properties, :dnr_customer_code
  end

  def self.down
    add_column :properties, :dnr_customer_code, :string

    unless Rails.env.test?
      DnrConfiguration.all.each do |dnr|
        community = Property.find(dnr.property_id)
        community.dnr_customer_code = dnr.customer_code
        community.save
      end
    end

    drop_table :dnr_configurations
  end
end
