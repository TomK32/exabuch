class ItemsController < ApplicationController

  layout "frontend"
	active_scaffold :item do |config|
    config.columns = [:amount, :title, :description, :price]
    config.columns[:amount].label = "Menge"
    config.columns[:title].label = "Titel"
    config.columns[:description].label = "Beschreibung"
    config.columns[:price].label = "Preis"
	end
  
end
