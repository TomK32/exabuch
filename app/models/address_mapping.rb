class AddressMapping < ActiveRecord::Base

  belongs_to :address
  belongs_to :invoice
  
end
