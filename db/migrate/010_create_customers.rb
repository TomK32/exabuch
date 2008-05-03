class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.column :user_id, :integer, :null => false
      t.column :customer_id, :integer # for the case the customer has an account here      
      t.column :name, :string, :null => false # an internal identifier, most likely company name

      t.timestamps
    end
    add_column :addresses, :customer_id, :integer    
  end

  def self.down
    remove_column :addresses, :customer_id
    drop_table :customers
  end
end
