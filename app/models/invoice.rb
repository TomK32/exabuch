class Invoice < ActiveRecord::Base

	has_one :total
	has_many :items
	has_many :address_mappings
  has_many :addresses, :through => :address_mappings

end
