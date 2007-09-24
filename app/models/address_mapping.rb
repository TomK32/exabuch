class AddressMapping < ActiveRecord::Base

  belongs_to :address, :foreign_key => "address_id"
  belongs_to :invoice
  
end
