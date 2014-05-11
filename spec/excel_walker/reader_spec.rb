require 'spec_helper'

module ExcelWalker
  describe Reader do
    describe '.create' do
      before { Reader::Reader.stub(new: :reader)  }
      it 'should create a new instance of writer' do
        expect(Reader.create('path')).to eq :reader
      end
    end
  end
end