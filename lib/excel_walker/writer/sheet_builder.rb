module ExcelWalker
  module Writer
    class SheetBuilder
      def initialize(workbook, name)
        @workbook = workbook
        @name = name
        @sheet = @workbook.add_worksheet(:name => @name)
        @hooks = []
        @max_rows = 0
      end

      delegate :add_style, to: '@workbook.styles'
      delegate :pane, to: '@sheet.sheet_view'
      delegate :column_widths, to: '@sheet'

      def create_pane(x , y)
        @sheet.sheet_view.pane do |pane|
          pane.top_left_cell = "#{(64 + x).chr}#{y}"
          pane.state = :frozen_split
          pane.y_split = x - 1
          pane.x_split = y - 1
          pane.active_pane = :bottom_right
        end
      end

      def on_rows(range, opts = {style: nil})
        Hook.new(range).tap do |hook|
          hook.style = opts[:style]
          @max_rows = hook.max if hook.max > @max_rows
          @hooks << hook
        end
      end

      alias on_row on_rows

      def merge_array(arr1, arr2, offset)
        offset.upto(arr2.length - 1 + offset).with_index do |offset_idx, idx|
          arr1[offset_idx] = arr2[idx]
        end
      end

      def build
        1.upto(@max_rows) do |row_num|
          row, styles = [], []
          @hooks.each do |hook|
            if hook.match?(row_num)
              cells = hook.run(row_num)
              merge_array(row, cells.data, hook.offset)
              merge_array(styles, cells.styles, hook.offset)
            end
          end
          @sheet.add_row row, style: styles
        end
      end
    end
  end
end