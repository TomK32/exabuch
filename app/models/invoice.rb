class Invoice < ActiveRecord::Base

	has_many :items, :dependent => :destroy
	has_many :address_mappings
  has_many :addresses, :through => :address_mappings
  validates_presence_of :number, :title
  validates_uniqueness_of :number

  def tax_amount
    self.gross_amount - self.net_amount
  end
  
  def net_amount
    sum = 0
    self.items.each do |item|
      item.amount=0 if item.amount.nil?
      item.price=0 if item.price.nil?
      sum += item.amount * item.price
    end
    sum
  end

  def gross_amount
    sum = 0
    self.items.each do |item|
      item.amount=0 if item.amount.nil?
      item.price=0 if item.price.nil?
      sum += item.amount * (item.price+item.price/100.0*item.tax)
    end
    sum
  end

end
