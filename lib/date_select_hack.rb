module ActionView
  module Helpers
    class InstanceTag
      def select_year(date, options = {})
        val = date ? (date.kind_of?(Fixnum) ? date : date.year) : ''
        if options[:use_hidden]
          hidden_html(options[:field_name] || 'year', val, options)
        else
          name = options[:field_name] || 'year'
          tag :input, { "type" => "text", "name" => name, "id" => name, "value" => val, :size => 4 }
        end
      end
    end
  end
end