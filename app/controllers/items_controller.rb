class ItemsController < ApplicationController

  layout "frontend"
	active_scaffold :item do |config|
    config.columns = [:amount, :title, :description, :price, :tax]
    config.columns[:amount].label = "Menge"
    config.columns[:title].label = "Titel"
    config.columns[:description].label = "Beschreibung"
    config.columns[:price].label = "Nettopreis"
    config.columns[:tax].label = "Steuersatz"
	end
  
end
