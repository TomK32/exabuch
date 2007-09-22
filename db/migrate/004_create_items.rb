class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
			t.column :title, :string
			t.column :description, :string
			t.column :amount, :decimal, {:precision => 2, :default => 0}
			t.column :price, :decimal, {:precision => 2, :default => 0}
    end
  end

  def self.down
    drop_table :items
  end
end
