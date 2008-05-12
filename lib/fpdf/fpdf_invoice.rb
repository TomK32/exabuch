# Module for generating PDF files out of invoices
#

module FPDF_INVOICE
  
  # Invoice Header
  def Header
    # are we running as standalone? change logopath
    if defined?(TAR2RUBYSCRIPT) then                                                                                                                              
      logo = oldlocation('images/logo.png')                                                                                                                       
    else                                                                                                                                                          
      logo = 'public/images/logo.png'                                                                                                                             
    end
    Image(logo, 130, 13, 71) if File.exists?(logo)
    if File.exists?(logo): Line(@leftmargin, 35, 200, 35) else Line(@leftmargin, 10, 200, 10) end
    SetY(40)
  end

  # Invoice Footer
  def Footer
    SetDrawColor(0)
    Line(@leftmargin, 265, 200, 265)
    PrintFooterAddress(@invoice.sender_address)
  end

  def AddPage(orientation='', invoice=nil)
		raise "Invoices with multiple pages are not supported at the moment, sorry..." if !@invoice.nil?
    @invoice ||= invoice
    raise "Please provide valid Invoice Object to FPDF_INVOICE::AddPage" if invoice.nil? && @invoice.nil?
    SetFont('vera')
    SetFillColor(210)
    @lh = 5 #lineheight
    @leftmargin = 20
    SetLeftMargin(@leftmargin)
    SetAutoPageBreak(true, @lh)
    super(orientation)
  end

  def BuildInvoice(invoice)
    SetFontSize(10)
    PrintAddress(invoice.receiver_address)
    Ln(15)
    SetFont('verab', '', 13)
    MyCell("Rechnung Nr. "+invoice.formated_number)
    SetFont('vera', '', 10)
    Ln(5)
    SetX(@leftmargin)
    MyWrite(invoice.description)
    Ln(15)
    #
    # Items
    data = []
    invoice.items.each do |item|
      data << [item.amount.to_s.gsub('.', ','), replace_UTF8(item.title), replace_UTF8(to_currency(item.price)), replace_UTF8(to_currency(item.amount * item.price))]
    end
    columns = [
      {:title => 'Std', :bg_color => 1, :title_alignment => 'C', :aligment => 'C', :width => 20},
      {:title => 'Bezeichnung', :bg_color => 1, :width => 110-@leftmargin},
      {:title => 'Einzelpreis', :bg_color => 1, :title_alignment => 'R', :aligment => 'R', :width => 35},
      {:title => 'Gesamtpreis', :bg_color => 1, :title_alignment => 'R', :aligment => 'R', :width => 35}
    ]
    SetDrawColor(210)
    table(data, columns, {:line_height => 7})
    #
    # Sums
    data = []
    data << ["Zwischensumme:", replace_UTF8(to_currency(invoice.net_amount))]
    invoice.tax_rates.each do |tax_rate, tax_amount|
      data << ["zzgl. MwSt (%s%%):" % tax_rate, replace_UTF8(to_currency(tax_amount))]
    end
    data << ["Endbetrag:", replace_UTF8(to_currency(invoice.gross_amount))]
    
    columns = [
      {:title => nil, :width => 40, :aligment => 'R'},
      {:title => nil, :width => 25, :aligment => 'R'}
    ]
    Ln(3)
    SetDrawColor(255) # no border
    table(data, columns, {:line_height => 7, :x_pos => 135})
    #
    # Body Text
    Ln(10)
    add_body_text(invoice)
    #
    # Dates
    data = [
      ["Bestellt am:", DateFormat(invoice.order_date)],
      ["Lieferdatum:", DateFormat(invoice.shipping_date)],
      ["Rechnungsdatum:", DateFormat(invoice.billing_date)]
    ]
    columns = [
      {:title => nil, :width => 40},
      {:title => nil, :width => 25, :aligment => 'R'}
    ]
    SetY(75)
    SetDrawColor(255) # no border
    table(data, columns, {:line_height => 5, :x_pos => 135})
  end

  def MyCell(string)
    string = replace_UTF8(string)
    Cell(0, @lh, string, 0, 1)
  end

  def MyWrite(string)
    string = replace_UTF8(string)
    Write(@lh, string)
  end

  def DateFormat(date)
    date.strftime("%d.%m.%Y") unless date.blank?
  end

  # workaround... fpdf doesn't do utf-8
  def replace_UTF8(field)
    ic_ignore = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'UTF-8')
    field = ic_ignore.iconv(field)
    ic_ignore.close  
    field
  end

  private
  def PrintAddress(address)
    MyCell("Firma") if address.company?
    MyCell(address.company) if address.company?
    if address.title?: MyCell(address.title+" "+address.name) else MyCell(address.name) end
    MyCell(address.street) if address.street?
    Ln(@lh)
    MyCell(address.postcode+" "+address.city) if address.postcode? && address.city?
    MyCell(address.country) if address.country?
  end

  # we just use a table to print the address in the footer...
  def PrintFooterAddress(address)
    data = [
      [
        if address.company?: replace_UTF8(address.company) else '' end, 
        if address.phone?: "Tel "+replace_UTF8(address.phone) else '' end,
        "Bankverbindung:",
        if address.tax_number?: "Steuernr: "+replace_UTF8(address.tax_number) else '' end
      ],
      [
        if address.title?: replace_UTF8(address.title+" "+address.name) else replace_UTF8(address.name) end,
        if address.fax?: "Fax "+replace_UTF8(address.fax) else '' end,
        if address.bank_name?: replace_UTF8(address.bank_name) else '' end,
        ""
      ],
      [
        if address.street?: replace_UTF8(address.street) else '' end,
        if address.email?: replace_UTF8(address.email) else '' end,
        if address.bank_number?: "BLZ "+replace_UTF8(address.bank_number) else '' end,
        ""
      ],
      [
        if address.postcode && address.city?: replace_UTF8(address.postcode+" "+address.city) else '' end,
        if address.website?: replace_UTF8(address.website) else '' end,
        if address.account_number?: "KTO "+replace_UTF8(address.account_number) else '' end,
        if address.iban?: "IBAN "+replace_UTF8(address.iban) else '' end
      ]
    ]
    columns = [
      {:title => nil, :width => 46},
      {:title => nil, :width => 46},
      {:title => nil, :width => 35},
      {:title => nil, :width => 63}
    ]
    # output footer
    SetFontSize(8)
    SetXY(@leftmargin, -30)
    SetDrawColor(255) # no border
    table(data, columns, {:line_height => 5})
  end
  
  def add_body_text(invoice)
    MyWrite("Vielen Dank für Ihren Auftrag.\n\nFür die von uns erbrachten Leistungen erlauben wir uns, Ihnen o.g. Positionen in Rechnung zu stellen. Bitte überweisen Sie den Gesamtbetrag von ")
    SetFont('verab')
    MyWrite(to_currency(invoice.gross_amount))
    SetFont('vera')
    MyWrite(" innerhalb von 10 Tagen auf das unten angegebene Konto.\n\nTragen Sie dabei im Betreff der Überweisung bitte die Rechnungsnummer ")
    SetFont('verab')
    MyWrite(invoice.formated_number)
    SetFont('vera')
    MyWrite(" ein.\n\n")
    MyWrite("Mit freundlichen Grüßen,\nIhr ")
    MyWrite(invoice.sender_address.name)
  end
  
end

