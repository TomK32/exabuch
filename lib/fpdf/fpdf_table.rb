# Fpdf::Table module
# Based on Table with MultiCells script by Olivier Plathey 
# Author: Bojan Mihelac http://source.mihelac.org

module Fpdf
  module Table
    def table(data, columns = nil, options = {})
      table_width = options[:table_width] || (210 - @rMargin - @lMargin);
      line_height = options[:line_height] || 5
      widths = []
      no_width_columns = 0
      current_width = 0
      columns ||= Array.new(data[0].size, {})
      titles = []
      columns.each do | column | 
        titles << column[:title]
        if column[:width] 
          widths << column[:width]
          current_width += column[:width]
        else
          widths << nil
          no_width_columns += 1
        end
      end
      if (no_width_columns > 0)
        default_width = (table_width - current_width) / no_width_columns
        widths.collect! {|width| width ||= default_width }
      end
      if (titles.nitems > 0)
        h = max_height(widths, columns.map {|item| item[:title]}, line_height)
        columns.each_index do |i|
          x = self.GetX
          y = self.GetY
          self.Rect(x, y, widths[i], h);
          MultiCell(widths[i], line_height, columns[i][:title], 0, columns[i][:title_alignment] || 'L', columns[i][:bg_color] || 0)
          self.SetXY(x+widths[i], y)
        end
        self.Ln(h)
      end

      data.each do |row|
        h = max_height(widths, row, line_height)
        check_page_break(h)
        first = true
        row.each_index do |i|
          aligment = columns[i][:aligment] || "L"
          if options[:x_pos] && first == true then
            x = options[:x_pos]
          else
            x = self.GetX
          end
          y = self.GetY
          self.SetX(x)
          self.Rect(x, y, widths[i], h);
          self.MultiCell(widths[i], line_height, row[i], 0, aligment)
          self.SetXY(x+widths[i], y)
          first = false
        end
        self.Ln(h)
        if options[:x_pos]: SetX(options[:x_pos]) end
      end
    end
    
    def check_page_break(h)
      if (self.GetY + h > @PageBreakTrigger)
        AddPage(@CurOrientation)
      end
    end
    
    def max_height(widths, contents, line_height)
      arr = []
      widths.each_index do |i|
        arr << nb_lines(widths[i], contents[i])
      end
      h = arr.max * line_height
    end
    
    def nb_lines(width, text)
      cw = @CurrentFont['cw']
      width = @w - @rMargin - @x  if (width == 0)
      wmax = (width - 2 * @cMargin) * 1000 / @FontSize
      s = text.gsub("\r", '')
      nb = s.length
      nb -= 1 if nb > 0 && s[nb-1] == "\n"
      sep = -1
      i, j, l = 0, 0, 0
      nl = 1
      while i < nb
        c = s[i].chr
        if (c == "\n")
          i += 1
          sep = -1
          j = 1
          l = 0
          nl += 1
          next
        end
        sep = i if (c == ' ')
        l += cw[c[0]]
        if (l > wmax)
          if (sep == -1)
            i += 1 if i == j
          else
            i = sep +1
          end
          sep = -1
          j = i
          l = 0
          nl += 1
        else
          i += 1
        end
      end
      nl
    end
  end
end

