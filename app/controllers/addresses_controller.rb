class AddressesController < ApplicationController

  layout "frontend"
	active_scaffold :address do |config|
    config.columns = [:company, :title, :name, :street, :street_number, :postcode, :city, :country, :tax_number, :account_number, :bank_number, :bank_name]
    config.label = "Adressen"
    config.action_links.add 'index', :label => 'Rechnungen', :controller => "invoices", :page => true
    config.actions.swap :search, :live_search
    config.columns[:company].label = "Firma"
    config.columns[:title].label = "Anrede"
    config.columns[:name].label = "Name"
    config.columns[:street].label = "Straße"
    config.columns[:street_number].label = "Hausnummer"
    config.columns[:postcode].label = "PLZ"
    config.columns[:city].label = "Stadt"
    config.columns[:country].label = "Land"
    config.columns[:tax_number].label = "Steuernummer"
    config.columns[:account_number].label = "KTO"
    config.columns[:bank_number].label = "BLZ"
    config.columns[:bank_name].label = "Bank"
    # i18n
    config.live_search.link.label = "Suchen"
    # create
    config.create.link.label = "Neue Adresse"
    # update
    config.update.link.label = "Ändern"
    # delete
    config.delete.link.label = "Löschen"
    # show
    config.show.link.label = "Zeigen"
    # list
    config.list.columns.exclude :tax_number, :account_number, :bank_name, :bank_number, :street, :street_number, :country
	end
  
end
