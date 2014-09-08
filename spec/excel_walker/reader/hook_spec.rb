require 'spec_helper'

module ExcelWalker::Reader
  describe Hook do
    subject(:hook) { Hook.new(proc { true }) }
    it 'raises error on wrong initializaion' do
      expect { Hook.new('string') }.to raise_error(ArgumentError, 'Can only take Array, Number, Range or a Block')
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

      context 'proc condition for rows' do
        subject(:hook) { Hook.new(proc { |x, y| x == y && y == 2 }) }
        it 'gives correct output on match' do
          expect(hook.match?(2, 2)).to be_true
          expect(hook.match?(2, 3)).to be_false
        end
      end
    end

    describe '#run' do
      let(:hook_lambda) { proc {} }
      it 'assigns the block to run when hook is executed' do
        hook.run(&hook_lambda)
        expect(hook.instance_variable_get('@run_block')).to eq hook_lambda
      end
    end

    describe '#columns' do
      it 'only takes array, number, proc or range as input' do
        expect{ Hook.new(1).columns('string') }.to raise_error(ArgumentError, 'Can only take Array, Number, Range or a Block')
      end
    end

    describe '#call' do
      let(:collection) { (1..100).to_a }
      let(:hook_block) { double }
      before { subject.run { |a, b, c, d| hook_block.call(a, b, c, d) } }

      context 'array column numbers matcher' do
        subject { hook.columns([1, 2, 4]) }
        it 'sends correct data to the hooked block' do
          hook_block.should_receive(:call).with([1, 2, 4], 'b', 'c', 'd')
          subject.call(collection, 'b', 'c', 'd')
        end
      end

      context 'range column numbers matcher' do
        subject { hook.columns(6..9) }
        it 'sends correct data to the hooked block' do
          hook_block.should_receive(:call).with([6, 7, 8, 9], 'b', 'c', 'd')
          subject.call(collection, 'b', 'c', 'd')
        end
      end

      context 'number column matcher' do
        subject { hook.columns(11) }
        it 'sends correct data to the hooked block' do
          hook_block.should_receive(:call).with(11, 'b', 'c', 'd')
          subject.call(collection, 'b', 'c', 'd')
        end
      end

      context 'proc column matcher' do
        subject { hook.columns {|row| row[96] }  }
        it 'sends correct data to the hooked block' do
          hook_block.should_receive(:call).with(97, 'b', 'c', 'd')
          subject.call(collection, 'b', 'c', 'd')
        end
      end

      context 'hash column matcher' do
        subject { hook.columns(first: 1, second: 2, twentieth: 20, last: 100) }
        it 'sends correct data to the hooked block' do
          hook_block.should_receive(:call).with({first: 1, second: 2, twentieth: 20, last: 100}, 'b', 'c', 'd')
          subject.call(collection, 'b', 'c', 'd')
        end
      end
    end

  end
end