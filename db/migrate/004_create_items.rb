class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.column :invoice_id, :integer
			t.column :title, :string
			t.column :description, :string
			t.column :amount, :float, {:precision => 2}
			t.column :price_in_cents, :integer
    end
  end

  def self.down
    drop_table :items
  end
end
