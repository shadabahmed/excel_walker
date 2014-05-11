require 'set'
module ExcelWalker
  module Reader
    class Hook
      def initialize(condition)
        @matcher = case true
                     when condition.respond_to?(:call)
                       condition
                     when condition.is_a?(Array), condition.is_a?(Range)
                       proc { |row_num| condition.include?(row_num) }
                     when condition.is_a?(Fixnum)
                       proc { |row_num| condition === row_num }
                   end
      end

      def columns(cols_condition = nil, &block)
        cols_condition = block if block_given?
        @cols_extractor =
            case cols_condition.class.name
              when 'Array'
                cols_set = Set.new(cols_condition)
                proc { |row| row.values.select.with_index { |_, idx| cols_set.include?(idx + 1) } }
              when 'Fixnum'
                proc { |row| row.values[cols_condition - 1] }
              when 'Range'
                proc { |row| row.values[(cols_condition.min - 1)..(cols_condition.max - 1)] }
              when 'Proc'
                proc { |row| cols_condition[row.values] }
            end
        self
      end

      alias pluck_columns columns

      def run(&block)
        @run_block = block
      end

      def match?(row_num, sheet_num)
        @matcher[row_num, sheet_num]
      end

      def call(row, row_num, sheet, sheet_num)
        data = extract_columns(row, row_num, sheet, sheet_num)
        @run_block[data, row_num, sheet, sheet_num]
      end

      protected

      def extract_columns(*args)
        @cols_extractor[*args]
      end
    end
  end
end