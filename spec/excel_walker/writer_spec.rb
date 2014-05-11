require 'spec_helper'

module ExcelWalker
  describe Writer do
    describe '.create' do
      before { Writer::Writer.stub(new: :writer)  }
      it 'should create a new instance of writer' do
        expect(Writer.create('path')).to eq :writer
      end
    end
  end
end