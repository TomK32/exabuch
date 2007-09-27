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
      t.column :call_number, :string
      t.column :fax_number, :string
      t.column :email, :string
      t.column :website_url, :string
      t.column :tax_number, :string
      t.column :account_number, :string
      t.column :iban, :string
      t.column :bank_name, :string
      t.column :bank_number, :string
    end
  end

  def self.down
    drop_table :addresses
  end
end
