module ExcelWalker
  module Reader
    class Reader
      def initialize(file_path)
        @xl = Creek::Book.new(file_path)
        @hooks = {}
        @max_rows = {}
        @current_sheet = 1
        @max_sheets = 1
      end

      def for_sheet(sheet_num)
        @current_sheet = sheet_num
        @max_sheets = sheet_num if sheet_num > @max_sheets
        self
      end

      alias set_sheet for_sheet

      def max_rows(max)
        @max_rows[@current_sheet] = max
        self
      end

      def on_row(condition = nil, &block)
        condition = block if block_given?
        Hook.new(condition).tap do |hook|
          @hooks[@current_sheet] ||= []
          @hooks[@current_sheet] << hook
        end
      end

      alias on_rows on_row

      def hooks
        @hooks[@current_sheet]
      end

      def start
        sheet_num = 0
        sheets_done = []
        begin
          @xl.sheets.each do |sheet|
            sheet_num += 1
            break if sheet_num > @max_sheets
            process_rows(sheet, sheet_num)
            sheets_done << sheet.name
          end
        rescue StopIteration
        end
        sheets_done
      ensure
        @xl.close
      end

      alias walk start

      def exit
        raise StopIteration.new
      end

      protected

      def process_rows(sheet, sheet_num)
        row_num = 0
        sheet.rows.each do |row|
          row_num += 1
          break if @max_rows[sheet_num] && row_num > @max_rows[sheet_num]
          @hooks[sheet_num].each do |hook|
            hook.call(row.values, row_num, sheet, sheet_num) if hook.match?(row_num, sheet_num)
          end
        end
      end
    end
  end
end