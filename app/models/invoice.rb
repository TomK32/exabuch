class Invoice < ActiveRecord::Base

	has_one :total
	has_many :items
	has_many :addresses

end
