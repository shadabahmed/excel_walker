module ExcelWalker
  module Writer

    class Cells
      attr_accessor :width, :default_style, :data, :styles

      def initialize(default_style)
        @default_style = default_style
        @data, @styles, @width = [], [], 0
      end

      def set_data_at(range, cell_data)
        range = [range] if range.is_a?(Fixnum)
        range.each do |i|
          data[i] = cell_data
        end
      end

      def set_style_at(range, cell_style)
        range = [range] if range.is_a?(Fixnum)
        range.each do |i|
          styles[i] = cell_style
        end
      end

      def build
        build_data
        build_styles
      end

      private

      def build_data
        if data.empty? && @width > 0
          @data = [nil]*@width
        end
      end

      def build_styles
        final_styles = [@default_style]*@data.length
        0.upto(styles.length - 1).each do |idx|
          final_styles[idx] = @styles[idx] if @styles[idx]
        end
        @styles = final_styles
      end
    end

  end
end