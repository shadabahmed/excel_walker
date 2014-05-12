require 'spec_helper'

module ExcelWalker::Writer
  describe Hook do
    subject(:hook) { Hook.new(0..100) }
    it 'raises error on wrong initializaion' do
      expect { Hook.new('string') }.to raise_error(ArgumentError, 'Can only take Range, Integers or Arrays')
    end

    describe '#match?' do
      context 'array condition for rows' do
        subject(:hook) { Hook.new([1, 2, 3]) }
        it 'gives correct output on match' do
          expect(hook.match?(2)).to be_true
          expect(hook.match?(0)).to be_false
        end
      end

      context 'range condition for rows' do
        subject(:hook) { Hook.new(1..3) }
        it 'gives correct output on match' do
          expect(hook.match?(2)).to be_true
          expect(hook.match?(0)).to be_false
        end
      end

      context 'number condition for rows' do
        subject(:hook) { Hook.new(2) }
        it 'gives correct output on match' do
          expect(hook.match?(2)).to be_true
          expect(hook.match?(3)).to be_false
        end
      end
    end

    describe '#max' do
      it 'gives the correct value of max row number for the hook' do
        expect(Hook.new(0..100).max).to eq 100
        expect(Hook.new([0, 1, 110]).max).to eq 110
        expect(Hook.new(200).max).to eq 200
      end
    end

    describe '#after_column' do
      it 'assigns the block to run when hook is executed' do
        hook.after_column(10)
        expect(hook.instance_variable_get('@offset')).to eq 10
      end
    end


    describe '#fill' do
      let(:hook_lambda) { proc {} }
      it 'assigns the block to run when hook is executed' do
        hook.fill(&hook_lambda)
        expect(hook.instance_variable_get('@filler')).to eq hook_lambda
      end
    end

    describe '#run' do
      let(:hook_block) { double }
      let(:cells) { double(build: nil) }
      before { subject.fill { |a, b, c| hook_block.call(a, b, c) } }
      subject { hook.after_column(10) }
      it 'sends correct data to the hooked block' do
        Cells.should_receive(:new).times.exactly(2).and_return(cells)
        #first run
        hook_block.should_receive(:call).with(cells, 0, 5)
        expect(subject.run(5)).to eq cells
        #second run
        hook_block.should_receive(:call).with(cells, 1, 6)
        expect(subject.run(6)).to eq cells
      end
    end

  end
end