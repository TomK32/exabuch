class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
			t.column :number, :integer
      t.column :payed, :boolean, {:default => false}
			t.column :title, :string
			t.column :description, :string
			t.column :billing_date, :date
			t.column :payment_date, :date
			t.column :created_at, :datetime
			t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :invoices
  end
end
