class Invoice < ActiveRecord::Base

	has_many :items, :dependent => :destroy
  has_one :sender, :class_name => "AddressMapping", :foreign_key => "invoice_sender_id"
  has_one :receiver, :class_name => "AddressMapping", :foreign_key => "invoice_receiver_id"
	#has_many :address_mappings
  #has_many :addresses, :through => :address_mappings
  validates_presence_of :number, :title
  validates_uniqueness_of :number
  validates_presence_of :sender
  validates_presence_of :receiver

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
