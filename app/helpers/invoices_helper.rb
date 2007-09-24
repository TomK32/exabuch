module InvoicesHelper

  def billing_date_column(record)
    record.billing_date.strftime("%Y-%m-%d")
  end

  def payment_date_column(record)
    return record.payment_date.strftime("%Y-%m-%d") unless record.billing_date ==  record.payment_date && record.payed == false
    return "-"
  end

  def net_amount_column(record)
    to_currency(record.net_amount)
  end

  def tax_column(record)
    to_currency(record.tax_amount)+" (#{record.tax}%)"
  end
  
  def gross_amount_column(record)
    to_currency(record.gross_amount)
  end
  
end
