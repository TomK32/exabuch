class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :addresses

  attr_protected :user_id
  attr_protected :customer_id
end
