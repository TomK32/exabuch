class Invoice < ActiveRecord::Base

	has_many :items, :dependent => :destroy
  belongs_to :sender_address, :class_name => "Address"
  belongs_to :receiver_address, :class_name => "Address"

  validates_presence_of :number, :title
  validates_uniqueness_of :number
  validates_presence_of :sender
  validates_presence_of :receiver
  attr_protected :user_id

  def tax_amount
    self.gross_amount - self.net_amount
  end

  def tax_rates
    # currently checks if all items have the same tax-rate
    # and returns that - throws error if tax-rates are mixed,
    # what is used in PDF-Generation
    tax_rates = {}
    self.items.each do |item|
      tax_rates[item.tax] ||= 0 
      tax_rates[item.tax] += (item.price * item.amount * item.tax / 100.0)
    end
    tax_rates
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

  def formated_number
    self.billing_date.strftime("%Y-%m-")+format("%06d", self.number).to_s
  end

end
