class AddressesController < ApplicationController

  layout "frontend"
	active_scaffold :address do |config|
    config.columns = [:company, :name, :street, :street_number, :postcode, :city, :country]
    config.label = "Adressen"
    config.action_links.add 'index', :label => 'Rechnungen', :controller => "invoices", :page => true
    config.actions.swap :search, :live_search
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
	end
  
end
