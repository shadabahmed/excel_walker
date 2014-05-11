require 'spec_helper'

module ExcelWalker::Reader
  describe Hook do
    let(:array_hook) { Hook.new([1,2,3]) }
    let(:range_hook) { Hook.new(1..3) }
    let(:num_hook) { Hook.new(2) }
    let(:proc_hook) { Hook.new(proc{|x, y| x == y && y == 2}) }

    describe '#match?' do
      it 'matches the hook with the condition' do
        expect(array_hook.match?(2)).to be_true
        expect(array_hook.match?(0)).to be_false
        expect(range_hook.match?(2)).to be_true
        expect(range_hook.match?(0)).to be_false
        expect(num_hook.match?(2)).to be_true
        expect(num_hook.match?(3)).to be_false
        expect(proc_hook.match?(2, 2)).to be_true
        expect(proc_hook.match?(3, 3)).to be_false
      end
    end
  end
end