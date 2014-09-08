require 'set'
module ExcelWalker
  module Reader
    class Hook
      def initialize(condition)
        @matcher = case true
                     when condition.is_a?(Proc)
                       condition
                     when condition.is_a?(Array), condition.is_a?(Range)
                       proc { |row_num| condition.include?(row_num) }
                     when condition.is_a?(Fixnum)
                       proc { |row_num| condition === row_num }
                     else
                       raise ArgumentError.new('Can only take Array, Number, Range or a Block')
                   end
      end

      def columns(cols_matcher = nil, &block)
        cols_matcher = block if block_given?
        @cols_extractor =
            case true
              when cols_matcher.is_a?(Array)
                proc { |row| cols_matcher.collect{|idx| row[idx - 1]} }
              when cols_matcher.is_a?(Fixnum)
                proc { |row| row[cols_matcher - 1] }
              when cols_matcher.is_a?(Range)
                proc { |row| row[(cols_matcher.min - 1)..(cols_matcher.max - 1)] }
              when cols_matcher.is_a?(Proc)
                proc { |row| cols_matcher[row] }
              when cols_matcher.is_a?(Hash)
                cols_idxs = cols_matcher.values
                cols_names = cols_matcher.keys
                proc { |row| Hash[cols_names.zip(cols_idxs.collect{|idx| row[idx - 1]})] }
              else
                raise ArgumentError.new('Can only take Array, Number, Range or a Block')
            end
        self
      end

      alias pluck_columns columns

      def run(&block)
        @run_block = block
      end

      def match?(row_num, sheet_num = nil)
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