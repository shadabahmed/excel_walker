require 'spec_helper'

module ExcelWalker::Writer
  describe Cells do
    subject(:cells) { Cells.new(:style) }

    describe '#set_data_at' do
      it 'sets data at specified position' do
        cells.set_data_at(2, :data)
        expect(cells.data).to eq [nil, nil, :data]
      end

      it 'sets data at specified range' do
        cells.set_data_at(4..6, :data)
        expect(cells.data).to eq [nil, nil, nil, nil, :data, :data, :data]
      end
    end

    describe '#set_style_at' do
      it 'sets style at specified position' do
        cells.set_style_at(2, :style)
        expect(cells.styles).to eq [nil, nil, :style]
      end

      it 'sets data at specified range' do
        cells.set_style_at(4..6, :style)
        expect(cells.styles).to eq [nil, nil, nil, nil, :style, :style, :style]
      end
    end

    describe '#build' do

      context 'when no data is set but width is set' do
        it 'maps style for each data cell' do
          cells.width = 4
          cells.build
          expect(cells.styles).to eq [:style, :style, :style, :style]
        end
      end

      context 'when data is set' do
        it 'maps style for each data cell' do
          cells.set_data_at(3..5, :data)
          cells.build
          expect(cells.data).to eq [nil, nil, nil, :data, :data, :data]
          expect(cells.styles).to eq [:style, :style, :style, :style, :style, :style]
        end
      end

      context 'when both data and styles are set' do
        it 'maps style for each data cell' do
          cells.set_data_at(3..5, :data)
          cells.set_style_at([2, 3, 5], :new_style)
          cells.build
          expect(cells.styles).to eq [:style, :style, :new_style, :new_style, :style, :new_style]
        end
      end
    end
  end
end