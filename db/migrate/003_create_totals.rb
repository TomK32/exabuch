class CreateTotals < ActiveRecord::Migration
  def self.up
    create_table :totals do |t|
			t.column :tax, :integer
			t.column :total, :decimal, {:precision => 8, :default => 0}
    end
  end

  def self.down
    drop_table :totals
  end
end
