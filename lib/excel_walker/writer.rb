require 'axlsx'
require 'excel_walker/writer/cells'
require 'excel_walker/writer/hook'
require 'excel_walker/writer/sheet_builder'

module ExcelWalker
  module Writer

    def self.create(file_path)
      Writer.new(file_path)
    end

    class Writer
      def initialize(file_path)

      end

      def new_sheet(sheet_name)

      end

      def save

      end
    end
  end
end