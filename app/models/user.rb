class User < ActiveRecord::Base
  serialize :preferences

  has_many :user_addresses, :class_name => 'Address', :conditions => 'addresses.owned_by_user = "t"'
  has_many :addresses, :conditions => 'addresses.owned_by_user = "f"'
  has_many :invoices
  
  validates_uniqueness_of :email

end
