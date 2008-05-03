class AlterAddresses < ActiveRecord::Migration
  def self.up
    Adress.find(:all).each do |address|
      address.street = "%s %s" % [address.street, address.street_number]
    end
    rename_column :addresses, :call_number, :phone
    rename_column :addresses, :fax_number, :fax
    rename_column :addresses, :website_url, :website
    remove_column :addresses, :street_number
  end

  def self.down
    add_column :addresses, :street_number, :string
    rename_column :addresses, :website, :website_url
    rename_column :addresses, :fax, :fax_number
    rename_column :addresses, :phone, :call_number
  end
end
