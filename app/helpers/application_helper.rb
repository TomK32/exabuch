# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def to_currency(val=0, precision=2, unit="€", separator=",", delimiter=".")
    number_with_delimiter(number_with_precision(val, precision), delimiter, separator)+" "+unit
  end

  # simple translation for AS
  def as_(*args)
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
        when "Update"
          return "Aktualisieren"
        when "Cancel"
          return "Abbrechen"
        when "Close"
          return "Schließen"
        when "Create Another"
          return "Weiteres Element"
        when "Create"
          return "Anlegen"
      end
    end
    super
  end
  
  def number_to_euro(amount)
    number_to_currency(amount, :unit => '€ ', :separator => ',', :delimiter => '.')
  end
  
  def link_to_destroy title, confirm_message, url, fallback_url
    url = url_for(url) unless url.is_a?(String)
    fallback_url = url_for(fallback_url) unless fallback_url.is_a?(String)
    link_to_function title, "confirm_destroy(this, '#{escape_javascript url}', '#{escape_javascript confirm_message}', '#{escape_javascript form_authenticity_token}')", :href => fallback_url
  end
end
