class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :addresses
  has_many :invoices, :through => :addresses
  has_many :open_invoices, :through => :addresses, :source => :invoices, :conditions => ['payed = ?', false]

  attr_protected :user_id
  attr_protected :customer_id
end
