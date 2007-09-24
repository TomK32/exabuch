class Invoice < ActiveRecord::Base

	has_one :total, :dependent => :destroy
	has_many :items, :dependent => :destroy
	has_many :address_mappings
  has_many :addresses, :through => :address_mappings
  validates_presence_of :number, :title
  validates_uniqueness_of :number
  after_save :update_total

  def net_amount
    self.total.total
  end

  def tax
    self.total.tax
  end

  def tax_amount
    self.total.with_tax - self.total.total
  end

  def gross_amount
    self.total.with_tax
  end
  
  def update_total
    sum = 0
    self.items.each do |item|
      item.amount=0 if item.amount.nil?
      item.price=0 if item.price.nil?
      sum += item.amount * item.price
    end
    self.total.total = sum
    self.total.save!
  end

end
