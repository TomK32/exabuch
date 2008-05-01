class Address < ActiveRecord::Base
  attr_protected :user_id
  
  def short_info
    return "%s, %s %s" % [company, postcode, city]
  end
end
