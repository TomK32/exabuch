# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "addresses", :force => true do |t|
    t.string  "company"
    t.string  "title"
    t.string  "name"
    t.string  "street"
    t.string  "street_number"
    t.string  "postcode"
    t.string  "city"
    t.string  "country"
    t.string  "call_number"
    t.string  "fax_number"
    t.string  "email"
    t.string  "website_url"
    t.string  "tax_number"
    t.string  "account_number"
    t.string  "iban"
    t.string  "bank_name"
    t.string  "bank_number"
    t.integer "user_id",        :default => 1, :null => false
  end

  create_table "invoices", :force => true do |t|
    t.integer  "number"
    t.boolean  "payed",               :default => false
    t.string   "title"
    t.string   "description"
    t.date     "order_date"
    t.date     "billing_date"
    t.date     "shipping_date"
    t.date     "payment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",             :default => 1,     :null => false
    t.integer  "sender_address_id",                      :null => false
    t.integer  "receiver_address_id",                    :null => false
  end

  create_table "items", :force => true do |t|
    t.integer "invoice_id"
    t.string  "title"
    t.string  "description"
    t.float   "amount"
    t.integer "price_in_cents"
    t.integer "tax"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.text     "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
