module ItemsHelper

  def price_column(record)
    to_currency(record.price)
  end
  
end
