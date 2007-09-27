class Invoice < ActiveRecord::Base

	has_many :items, :dependent => :destroy
  has_one :sender, :class_name => "AddressMapping", :foreign_key => "invoice_sender_id"
  has_one :receiver, :class_name => "AddressMapping", :foreign_key => "invoice_receiver_id"
	#has_many :address_mappings
  #has_many :addresses, :through => :address_mappings
  validates_presence_of :number, :title
  validates_uniqueness_of :number

  def tax_amount
    self.gross_amount - self.net_amount
  end

  def tax_rate
    # currently checks if all items have the same tax-rate
    # and returns that - throws error if tax-rates are mixed,
    # what is used in PDF-Generation
    tax_rate = self.items[0].tax || 0
    self.items.each do |item|
      if item.tax != tax_rate then raise "The Tax-Rates of your Items differ, which is not supported yet. Sorry..." end
    end
    tax_rate
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
