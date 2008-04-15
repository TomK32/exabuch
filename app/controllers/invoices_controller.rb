class InvoicesController < ApplicationController

  require 'fpdf'
  load 'fpdf_table.rb'
  load 'fpdf_invoice.rb'
  require 'iconv'
  
  layout "frontend"
  
	active_scaffold :invoice do |config|
    config.label = "Rechnungen"
    config.columns = [:payed, :number, :sender, :receiver, :order_date, :billing_date, :shipping_date, :payment_date, :title, :description, :items, :net_amount, :tax_amount, :gross_amount]
    config.action_links.add 'to_pdf', :label => 'PDF', :type => :record, :popup => true
    config.action_links.add 'index', :label => 'Adressen', :controller => "addresses", :page => true
    config.actions.swap :search, :live_search
		config.list.sorting = { :number => :asc }
    # i18n
    config.live_search.link.label = "Suchen"
    config.columns[:payed].label = "Bezahlt"
    config.columns[:number].label = "Nummer"
    config.columns[:sender].label = "Absender"
    config.columns[:receiver].label = "Empfänger"
    config.columns[:order_date].label = "Bestelldatum"
    config.columns[:billing_date].label = "Rechnungsdatum"
    config.columns[:shipping_date].label = "Lieferdatum"
    config.columns[:payment_date].label = "Zahlungsdatum"
    config.columns[:title].label = "Titel"
    config.columns[:description].label = "Beschreibung"
    config.columns[:items].label = "Einzelposten"
    config.columns[:net_amount].label = "Netto"
    config.columns[:tax_amount].label = "Umsatzsteuer"
    config.columns[:gross_amount].label = "Brutto"
    # list
    config.list.columns = [:number, :billing_date, :payment_date, :title, :items, :net_amount, :tax_amount, :gross_amount]
    # create
    config.create.link.label = "Neue Rechnung"
    config.create.columns.exclude :sender, :receiver, :order_date, :billing_date, :shipping_date, :payment_date, :net_amount, :tax, :tax_amount, :gross_amount
    config.create.columns.add_subgroup "Daten" do |dates_group|
      dates_group.add :order_date, :billing_date, :shipping_date, :payment_date
    end
    config.create.columns.add_subgroup "Adressen" do |address_group|
      address_group.add :sender, :receiver
    end
    # update
    config.update.link.label = "Ändern"
    config.update.columns.exclude :sender, :receiver, :order_date, :billing_date, :shipping_date, :payment_date, :net_amount, :tax, :tax_amount, :gross_amount
    config.update.columns.add_subgroup "Daten" do |dates_group|
      dates_group.add :order_date, :billing_date, :shipping_date, :payment_date
    end
    config.update.columns.add_subgroup "Adressen" do |address_group|
      address_group.add :sender, :receiver
    end
    # delete
    config.delete.link.label = "Löschen"
    # show
    config.show.link.label = "Zeigen"
	end

  # renders invoice for pdf-output
  def to_pdf
    @invoice  = Invoice.find(params[:id])
    # Here you can define your preferred filename of the generated invoice
    #filename  = (@invoice.billing_date.to_s+"_"+@invoice.title+".pdf").downcase.gsub(" ", "_")
    filename  = (@invoice.formated_number+"_"+@invoice.title+".pdf").downcase.gsub(" ", "_")
    send_data gen_invoice_pdf, :filename => filename, :type => "application/pdf"
  end

  private

  # generates PDF for given invoice
  # see /lib/fpdf/fpdf_invoice.rb + fpdf_table for details
  # :TODO: Add Meta-Info from Invoice to PDF (Author etc.)
  def gen_invoice_pdf
    @pdf = FPDF.new
    @pdf.extend(FPDF_INVOICE)
    @pdf.extend(Fpdf::Table)
    @pdf.extend(ApplicationHelper)
    @pdf.extend(ActionView::Helpers::NumberHelper)
    @pdf.AddFont('vera')
    @pdf.AddFont('verab')
    @pdf.AddPage('', @invoice)
    @pdf.BuildInvoice(@invoice)
    @pdf.Output
  end

end

