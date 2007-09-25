class AddressMappingsController < ApplicationController

  layout "frontend"
	active_scaffold :address_mapping do |config|
    config.columns = [:address, :invoice]
    config.subform.columns = [:address]
	end
  
end
