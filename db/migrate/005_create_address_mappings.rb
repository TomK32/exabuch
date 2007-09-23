class CreateAddressMappings < ActiveRecord::Migration
  def self.up
    create_table :address_mappings do |t|
			t.column :invoice_id, :integer
			t.column :address_id, :integer
			t.column :created_at, :datetime
			t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :address_mappings
  end
end
