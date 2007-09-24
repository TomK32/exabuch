# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def to_currency(val=0, precision=2, unit="€", separator=",", delimiter=".")
    number_with_delimiter(number_with_precision(val, precision), delimiter, separator)+" "+unit
  end
  
end
