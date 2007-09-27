class AddressMapping < ActiveRecord::Base

  belongs_to :address, :foreign_key => "address_id"
  belongs_to :invoice
  attr_accessor :invoices

  #fix for AS, which requires this metod when creating invoices with addresses
  def invoices=(dummy)
    true
  end
  
end
