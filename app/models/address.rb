class Address < ActiveRecord::Base
  attr_protected :user_id
  belongs_to :customer
  has_many :invoices, :foreign_key => 'receiver_address_id'
  
  def short_info
    return "%s, %s %s" % [company, postcode, city]
  end
end
