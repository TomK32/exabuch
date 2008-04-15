class ItemsController < ApplicationController

  layout "frontend"
	active_scaffold :item do |config|
    config.label = "Einzelposten"
    config.columns = [:amount, :title, :description, :price, :price_amount, :tax, :gross_amount]
    config.columns[:amount].label = "Menge"
    config.columns[:title].label = "Titel"
    config.columns[:description].label = "Beschreibung"
    config.columns[:price].label = "Einzelpreis"
    config.columns[:price_amount].label = "Netto"
    config.columns[:tax].label = "Umsatzsteuer"
    config.columns[:gross_amount].label = "Brutto"
    config.actions.swap :search, :live_search
    # i18n
    config.live_search.link.label = "Suchen"
    # create
    config.create.columns.exclude :price_amount, :gross_amount
    config.create.link.label = "Neues Element"
    # update
    config.update.columns.exclude :price_amount, :gross_amount
    config.update.link.label = "Ändern"
    # delete
    config.delete.link.label = "Löschen"
    # show
    config.show.link.label = "Zeigen"
	end
  
end
