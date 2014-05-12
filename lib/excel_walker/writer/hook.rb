module ExcelWalker
  module Writer

    class Hook
      attr_reader :max, :offset
      attr_accessor :style

      def initialize(condition)
        @matcher = case true
                     when condition.is_a?(Range), condition.is_a?(Array)
                       @max = condition.max
                       proc { |row_num| condition.include?(row_num) }
                     when condition.is_a?(Fixnum)
                       @max = condition
                       proc { |row_num| condition === row_num }
                     else
                       raise ArgumentError.new('Can only take Range, Integers or Arrays')
                   end
        @row_index = 0
      end

      def match?(row_num)
        @matcher[row_num]
      end

      def after_column(offset)
        @offset = offset
        self
      end

      def fill(&block)
        @filler = block
      end

      def run(row_num)
        cells = Cells.new(style)
        @filler[cells, @row_index, row_num]
        cells.build
        @row_index += 1
        cells
      end
    end

  end
end