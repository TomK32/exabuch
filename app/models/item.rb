class Item < ActiveRecord::Base

  attr_accessor :price
  belongs_to :invoice
  validates_presence_of :tax
  
  def tax_amount
    (self.price * self.tax) / 100.0 * self.amount
  end

  def price_amount
    return price * self.amount
  end
  def price
    return 0 if self.price_in_cents.nil?
    return self.price_in_cents/100.0
  end

  def price=(val)
    self.price_in_cents = val.to_f*100
  end
  
  def gross_amount
    self.price * self.amount * self.tax / 100.0
  end

end
