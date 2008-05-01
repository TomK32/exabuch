class User < ActiveRecord::Base
  serialize :preferences

  has_many :user_addresses, :class_name => 'Address', :conditions => 'owner_by_user = 1'
  has_many :addresses, :conditions => 'owned_by_user = 0'
  has_many :invoices
  
  validates_uniqueness_of :email

end
