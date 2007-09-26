class InvoicesController < ApplicationController

  require 'fpdf'
  require 'iconv'
  layout "frontend"
  
	active_scaffold :invoice do |config|
    config.label = "Rechnungen"
    config.columns = [:payed, :number, :sender, :receiver, :order_date, :billing_date, :shipping_date, :payment_date, :title, :description, :items, :net_amount, :tax, :gross_amount]
    config.action_links.add 'to_pdf', :label => 'PDF', :type => :record, :popup => true
    config.action_links.add 'index', :label => 'Adressen', :controller => "addresses", :page => true
    config.actions.swap :search, :live_search
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
    config.columns[:tax].label = "Mwst."
    config.columns[:gross_amount].label = "Brutto"
    # list
    config.list.columns = [:number, :billing_date, :payment_date, :title, :items, :net_amount, :tax, :gross_amount]
    # create
    config.create.link.label = "Neue Rechnung"
    config.create.columns.exclude :sender, :receiver, :order_date, :billing_date, :shipping_date, :payment_date, :net_amount, :tax, :gross_amount
    config.create.columns.add_subgroup "Daten" do |dates_group|
      dates_group.add :order_date, :billing_date, :shipping_date, :payment_date
    end
    config.create.columns.add_subgroup "Adressen" do |address_group|
      address_group.add :sender, :receiver
    end
    # update
    config.update.link.label = "Ändern"
    config.update.columns.exclude :sender, :receiver, :order_date, :billing_date, :shipping_date, :payment_date, :net_amount, :tax, :gross_amount
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
    @sender   = @invoice.sender.address
    @receiver = @invoice.receiver.address
    filename  = (@invoice.billing_date.to_s+"_"+@invoice.title+".pdf").downcase.gsub(" ", "_")
    send_data gen_pdf, :filename => filename, :type => "application/pdf"
  end

  private
  def gen_pdf
    @pdf = FPDF.new
    @pdf.AddPage
    @pdf.SetFont('times')
    @pdf.SetFontSize(12)
    text = render_to_string :action => "print", :layout => false
    @pdf.Write(5, replace_UTF8(text))
    @pdf.Output
  end

  # workaround... fpdf doesn't do utf-8
  def replace_UTF8(field)
    ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    field = ic_ignore.iconv(field)
    ic_ignore.close  
    field
  end

end

