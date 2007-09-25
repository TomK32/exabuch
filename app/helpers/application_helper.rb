# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def to_currency(val=0, precision=2, unit="€", separator=",", delimiter=".")
    number_with_delimiter(number_with_precision(val, precision), delimiter, separator)+" "+unit
  end

  def as_(*args)
    stuff = String.new
    args.each do |arg|
      case arg
        when "hide"
          return "ausblenden"
        when "show"
          return "einblenden"
        when "Replace With New"
          return "Zurücksetzen"
        when "No Entries"
          return "Keine Einträge"
        when "Found"
          return "gefunden"
      end
    end
  end
  
end
