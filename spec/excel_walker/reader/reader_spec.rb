require 'spec_helper'
module ExcelWalker::Reader
  describe Reader do
    let(:sheet1) { double(name: 'sheet1', rows: [Hash[(1..10).to_a.zip(%w[a b c d e f g h i k])]]*100) }
    let(:sheet2) { double(name: 'sheet2', rows: [Hash[(1..10).to_a.zip(%w[q r s t u v w x y z])]]*100) }
    let(:sheets) { [sheet1, sheet2] }
    let(:book) { double(sheets: sheets, close: true) }
    before :each do
      Creek::Book.stub(new: book)
    end
    let(:hook1) { double }
    let(:hook2) { double }
    subject(:exl) { Reader.new(:random) }

    context 'one worksheet' do
      before do
        exl.on_row(4).columns(3).run { |data, row_num| hook1.call(data, row_num) }
        exl.on_row([5, 6]).columns([3, 4]).run { |data, row_num| hook1.call(data, row_num) }
        exl.on_row(5..100).columns(4..20).run { |data, row_num| hook2.call(data, row_num) }
      end
      it 'calls the hooks correctly' do
        hook1.should_receive(:call).with('c', 4)
        hook1.should_receive(:call).with(['c', 'd'], 5)
        hook1.should_receive(:call).with(['c', 'd'], 6)
        hook2.should_receive(:call).exactly(96).times
        expect(exl.start).to eq ['sheet1']
      end
    end

    context 'one worksheet - block syntax for row matchers and columns plucker' do
      before do
        exl.on_row { |row_num| row_num == 5 }.columns { |row| row[9] }.run { |data, row_num| hook1.call(data, row_num) }
        exl.from_row(99).columns { |row| row[9] }.run { |data, row_num| hook1.call(data, row_num) }
      end
      it 'calls the hooks correctly' do
        hook1.should_receive(:call).with('k', 5)
        hook1.should_receive(:call).with('k', 99)
        hook1.should_receive(:call).with('k', 100)
        expect(exl.start).to eq ['sheet1']
      end
    end

    context 'two worksheets' do
      before do
        exl.for_sheet(1).on_row([5, 6]).columns([3, 4]).run { |data, row_num| hook1.call(data, row_num) }
        exl.for_sheet(2).on_row([6, 7]).columns([6, 7]).run { |data, row_num| hook2.call(data, row_num) }
      end
      it 'calls the hooks correctly' do
        hook1.should_receive(:call).with(['c', 'd'], 5)
        hook1.should_receive(:call).with(['c', 'd'], 6)
        hook2.should_receive(:call).with(['v', 'w'], 6)
        hook2.should_receive(:call).with(['v', 'w'], 7)
        expect(exl.start).to eq ['sheet1', 'sheet2']
      end
    end

    context 'one worksheet with row limit' do
      before do
        exl.for_sheet(1).max_rows(20)
        exl.on_row(5..100).columns(4..20).run { |data, row_num| hook1.call(data, row_num) }
      end
      it 'calls the hooks correctly' do
        hook1.should_receive(:call).exactly(16).times
        expect(exl.start).to eq ['sheet1']
      end
    end

    context 'one worksheet - clearing the hooks' do
      before do
        exl.on_row(5..100).columns(4..20).run { |data, row_num| hook1.call(data, row_num) }
        exl.hooks.clear
      end
      it 'should not call any hooks' do
        hook1.should_not_receive(:call)
        expect(exl.start).to eq ['sheet1']
      end
    end

    context 'one worksheet with exit clause in one of the blocks' do
      before do
        exl.on_row(5..100).columns(4..20).run { |data, row_num| hook1.call(data, row_num) }
        exl.on_row(75).columns(4..20).run { exl.exit }
      end
      it 'calls the hooks correctly' do
        hook1.should_receive(:call).exactly(71).times
        expect(exl.start).to eq []
      end
    end

    context 'multiple worksheets with row limit for each' do
      before do
        exl.for_sheet(1).max_rows(40)
        exl.on_row(5..100).columns(4..20).run { |data, row_num| hook1.call(data, row_num) }
        exl.for_sheet(2).max_rows(20)
        exl.on_row(5..100).columns(4..20).run { |data, row_num| hook2.call(data, row_num) }
      end
      it 'calls the hooks correctly' do
        hook1.should_receive(:call).exactly(36).times
        hook2.should_receive(:call).exactly(16).times
        expect(exl.start).to eq ['sheet1', 'sheet2']
      end
    end
  end
end