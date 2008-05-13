class DropAddressMappings < ActiveRecord::Migration
  def self.up
    add_column :invoices, :sender_address_id, :integer
    add_column :invoices, :receiver_address_id, :integer
    execute("UPDATE invoices SET `sender_address_id` = (SELECT address_id FROM address_mappings WHERE address_mappings.invoice_sender_id = invoices.id)")
    execute("UPDATE invoices SET `receiver_address_id` = (SELECT address_id FROM address_mappings WHERE address_mappings.invoice_receiver_id = invoices.id)")
    drop_table :address_mappings
    change_column :invoices, :sender_address_id, :integer, :null => false
    change_column :invoices, :receiver_address_id, :integer, :null => false    
  end

  def self.down
    remove_column :invoices, :receiver_address_id
    remove_column :invoices, :sender_address_id
    create_table :address_mappings do |t|
      t.column :invoice_sender_id, :integer
      t.column :invoice_receiver_id, :integer
      t.column :address_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end
end
