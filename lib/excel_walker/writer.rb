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
        @file_path = file_path
        @package = Axlsx::Package.new
        @workbook = @package.workbook
      end

      def new_sheet(sheet_name)
        SheetBuilder.new(@workbook, sheet_name)
      end

      def save
        @package.serialize @file_path
      end
    end
  end
end