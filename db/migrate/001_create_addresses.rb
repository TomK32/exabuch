class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
			t.column :company, :string
      t.column :title, :string
			t.column :name, :string
			t.column :street, :string
			t.column :street_number, :string
			t.column :postcode, :string
      t.column :city, :string
			t.column :country, :string
    end
  end

  def self.down
    drop_table :addresses
  end
end
