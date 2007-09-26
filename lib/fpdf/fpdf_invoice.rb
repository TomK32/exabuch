# Module for generating PDF files with FPDF that have a header with Image (Logo)
# and a line underneath
#

module FPDF_INVOICE
  
  # Invoice Header
  def Header
    SetDrawColor(0)
    SetLineWidth(0.2)
    Image('public/images/logo.png', 130, 13, 73.73)
    Line(5, 35, 205, 35)
    SetY(40)
  end

  def AddPage
    SetFont('times')
    SetFontSize(12)
    @lh = 5
    super
  end

  def BuildInvoice(invoice)
    AddFont('Vera', '', 'Vera.rb')
    SetFont('Vera', '', 12)
    PrintAddress(invoice.receiver.address)
    Ln(15)
    SetFontSize(15)
    MyCell("Rechnung")
    Ln(15)
    SetFontSize(12)
    MyCell("Bestellt am: "+DateFormat(invoice.order_date))
    MyCell("Lieferdatum: "+DateFormat(invoice.shipping_date))
    Ln(15)
    data = []
    invoice.items.each do |item|
      data << [item.amount.to_s.gsub('.', ','), replace_UTF8(item.title), replace_UTF8(to_currency(item.price)), replace_UTF8(to_currency(item.amount * item.price))]
    end
    columns = [
      {:title => 'Menge', :title_alignment => 'C', :aligment => 'C', :width => 20},
      {:title => 'Bezeichnung', :width => 100},
      {:title => 'Einzelpreis', :title_alignment => 'R', :aligment => 'R', :width => 35},
      {:title => 'Gesamtpreis', :title_alignment => 'R', :aligment => 'R', :width => 35}
    ]
    table(data, columns, {:line_height => 7})
  end

  def MyCell(string)
    string = replace_UTF8(string)
    Cell(0, @lh, string, 0, 1)
  end

  def DateFormat(date)
    date.strftime("%d.%m.%Y")
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
    if address.title? then MyCell(address.title+" "+address.name) else MyCell(address.name) end
    MyCell(address.street+" "+address.street_number) if address.street?
    MyCell(address.postcode+" "+address.city) if address.postcode? && address.city?
    MyCell(address.country) if address.country?
  end
  
end

