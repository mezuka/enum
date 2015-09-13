require 'test_helper'

describe Enum::Base do
  describe Side do
    describe '#name' do
      it 'raises exception on getting name as string' do
        assert_raises NameError do
          Side.name(:left)
        end
      end

      it 'raises exception on getting name as symbol' do
        assert_raises NameError do
          Side.name('left')
        end
      end
    end
  end
end
