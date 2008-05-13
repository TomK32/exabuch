class Address < ActiveRecord::Base
  attr_protected :user_id
  belongs_to :customer
  has_many :invoices, :foreign_key => 'receiver_address_id'
  
  def short_info
    [company, [postcode, city].reject{|a| a.blank?}.join(" ")].reject{|a| a.blank?}.join(", ")
  end
end
