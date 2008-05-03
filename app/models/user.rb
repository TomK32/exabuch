class User < ActiveRecord::Base
  serialize :preferences

  has_many :user_addresses, :class_name => 'Address', :conditions => ['addresses.owned_by_user = ?', true]
  has_many :addresses, :conditions => ['addresses.owned_by_user = ?', false]
  has_many :invoices
  has_many :customers
  
  validates_uniqueness_of :email

end
