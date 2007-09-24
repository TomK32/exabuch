class CreateTotals < ActiveRecord::Migration
  def self.up
    create_table :totals do |t|
      t.column :invoice_id, :integer
			t.column :tax, :integer, {:default => 19}
			t.column :total_in_cents, :integer
    end
  end

  def self.down
    drop_table :totals
  end
end
