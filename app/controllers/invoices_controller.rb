class InvoicesController < ApplicationController

  layout "frontend"
	active_scaffold :invoice do |config|
    config.label = "Rechnungen"
    config.columns = [:number, :payed, :billing_date, :payment_date, :title, :description, :items, :net_amount, :tax, :gross_amount]
    config.columns[:number].label = "Nummer"
    config.columns[:billing_date].label = "Rechnung"
    config.columns[:payment_date].label = "Zahlung"
    config.columns[:title].label = "Titel"
    config.columns[:description].label = "Beschreibung"
    config.columns[:items].label = "Einzelposten"
    config.columns[:net_amount].label = "Netto"
    config.columns[:tax].label = "Mwst."
    config.columns[:gross_amount].label = "Brutto"
    config.list.columns = [:number, :billing_date, :payment_date, :title, :items, :net_amount, :tax, :gross_amount]
    config.create.columns.exclude :net_amount, :tax, :gross_amount
    config.update.columns.exclude :net_amount, :tax, :gross_amount
	end

end

