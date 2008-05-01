class DropAddressMappings < ActiveRecord::Migration
  def self.up
    add_column :invoices, :sender_address_id, :integer
    add_column :invoices, :receiver_address_id, :integer
    Invoice.has_one :old_sender, :class_name => "AddressMapping", :foreign_key => "invoice_sender_id"
    Invoice.has_one :old_receiver, :class_name => "AddressMapping", :foreign_key => "invoice_receiver_id"
    Invoice.find(:all, :include => [:old_sender, :old_receiver]).each do |invoice|
      invoice.update_attribute(:sender_address_id, invoice.old_sender.address_id)
      invoice.update_attribute(:receiver_address_id, invoice.old_receiver.address_id)
    end
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
