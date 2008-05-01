class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :email, :string
      t.column :name, :string
      t.column :preferences, :text

      t.timestamps
    end
    
    User.create!(:email => 'user@example.com', :name => 'Default User', :preferences => {})
  end

  def self.down
    drop_table :users
  end
end
