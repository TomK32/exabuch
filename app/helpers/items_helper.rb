module ItemsHelper

  def price_amount_column(record)
    to_currency(record.price_amount)
  end
  def price_column(record)
    to_currency(record.price)
  end
  
  def gross_amount(record)
    to_currency(record.gross_amount)
  end
  
end
