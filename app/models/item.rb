class Item < ActiveRecord::Base

  attr_accessor :price
  belongs_to :invoice
  validates_presence_of :tax
  
  def price
    return self.price_in_cents/100.0 unless self.price_in_cents.nil?
    return nil
  end

  def price=(val)
    self.price_in_cents = val.to_f*100
  end

end
