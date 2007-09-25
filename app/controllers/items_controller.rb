class ItemsController < ApplicationController

  layout "frontend"
	active_scaffold :item do |config|
    config.label = "Einzelposten"
    config.columns = [:amount, :title, :description, :price, :tax]
    config.columns[:amount].label = "Menge"
    config.columns[:title].label = "Titel"
    config.columns[:description].label = "Beschreibung"
    config.columns[:price].label = "Nettopreis"
    config.columns[:tax].label = "Steuersatz"
    config.actions.swap :search, :live_search
    # i18n
    config.live_search.link.label = "Suchen"
    # create
    config.create.link.label = "Neues Element"
    # update
    config.update.link.label = "Ändern"
    # delete
    config.delete.link.label = "Löschen"
    # show
    config.show.link.label = "Zeigen"
	end
  
end
