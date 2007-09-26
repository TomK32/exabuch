module InvoicesHelper

  #
  # ActiveScaffold
  #
  def billing_date_column(record)
    record.billing_date.strftime("%Y-%m-%d")
  end

  def order_date_column(record)
    record.order_date.strftime("%Y-%m-%d")
  end

  def shipping_date_column(record)
    record.shipping_date.strftime("%Y-%m-%d")
  end
  
  def payment_date_column(record)
    return record.payment_date.strftime("%Y-%m-%d") unless record.billing_date ==  record.payment_date && record.payed == false
    return "-"
  end

  def net_amount_column(record)
    to_currency(record.net_amount)
  end

  def tax_column(record)
    to_currency(record.tax_amount)#+" (#{record.tax}%)" # :TODO: display tax-amounts present it .items
  end
  
  def gross_amount_column(record)
    to_currency(record.gross_amount)
  end

  def sender_column(record)
    record.sender.address.name
  end

  def receiver_column(record)
    record.receiver.address.name
  end

  def payed_column(record)
    record.payed == true ? "Ja" : "Nein"
  end
  
  def payed_form_column(record, input_name)
    check_box :record, :payed, :name => input_name
  end

  def options_for_association_conditions(association)
    if association.name == :sender || association.name == :receiver
      # we don't want to exchange associations
      ['1 = 0']
    else
      super
    end
  end

  #
  # misc
  #

  def to_filename(string)
    string.downcase.gsub(" ", "_")
  end
  
end
