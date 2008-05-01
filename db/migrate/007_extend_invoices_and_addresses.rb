class ExtendInvoicesAndAddresses < ActiveRecord::Migration
  def self.up
    add_column :invoices, :user_id, :integer, :null => false, :default => 1
    add_column :addresses, :user_id, :integer, :null => false, :default => 1
    add_column :addresses, :owner_by_user, :boolean, :default => false
  end

  def self.down
    remove_column :addresses, :type
    remove_column :addresses, :user_id
    remove_column :invoices, :user_id
  end
end
