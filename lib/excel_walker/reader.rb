require 'creek'
require 'excel_walker/reader/hook'
require 'excel_walker/reader/reader'

module ExcelWalker
  module Reader
    def self.create(file_path)
      Reader.new(file_path)
    end
  end
end