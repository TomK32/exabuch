class Total < ActiveRecord::Base

  attr_accessor :total
  belongs_to :invoice
  validates_presence_of :tax

  def with_tax
    self.total + self.total/100*self.tax
  end

  def total
    # we calculate with cents, but we display in full
    self.total_in_cents/100.0
  end

  def total=(val)
    self.total_in_cents = val.to_f*100
  end
  
end
