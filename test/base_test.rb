require 'test_helper'

describe Enum::Base do
  describe Side do
    describe '#indexes' do
      describe 'returns defined indexes' do
        specify { assert_equal [0, 1, 2], Side.indexes }
      end
    end

    describe '#take' do
      describe 'returns given tokens safely' do
        specify { assert_equal ['left', 'right'], Side.take(:left, :right) }
        specify { assert_equal ['left', 'right'], Side.take('left', :right) }
        specify { assert_equal ['left', 'right'], Side.take(:left, 'right') }
        specify { assert_equal ['left', 'right'], Side.take('left', 'right') }

        specify do
          assert_raises Enum::TokenNotFoundError do
            Side.take(:left, :invalid)
          end
        end
      end
    end

    describe '#include?' do
      describe 'returns boolean result in any case' do
        specify { assert_equal true, Side.include?(:left) }
        specify { assert_equal true, Side.include?('left') }
        specify { assert_equal false, Side.include?(:invalid) }
      end
    end

    describe '#enum' do
      it 'returns defined token as string by symbol' do
        assert_equal 'left', Side.enum(:left)
      end

      it 'returns defined token as string by string' do
        assert_equal 'left', Side.enum('left')
      end

      it 'raises exception on getting not defined token on getting token as string' do
        assert_raises Enum::TokenNotFoundError do
          Side.enum('invalid')
        end
      end

      it 'raises exception on getting not defined token on getting token as symbol' do
        assert_raises Enum::TokenNotFoundError do
          Side.enum(:invalid)
        end
      end
    end

    describe '#all' do
      it 'returns the defined values in order of their definition' do
        assert_equal ['left', 'right', 'whole'], Side.all
      end
    end

    describe '#name' do
      it 'returns translation when the translation available on string argument' do
        assert_equal 'This is a left side', Side.name('left')
      end

      it 'returns translation when the translation available on symbol argument' do
        assert_equal 'This is a left side', Side.name(:left)
      end

      it 'returns translation missing text when the translation unavailable on string argument' do
        assert_equal 'translation missing: en.enum.Side.right', Side.name('right')
      end

      it 'returns translation missing text when the translation unavailable on symbol argument' do
        assert_equal 'translation missing: en.enum.Side.right', Side.name(:right)
      end
    end

    describe '#find_index' do
      describe 'returns index for given token' do
        specify { assert_equal 0, Side.index('left') }
        specify { assert_equal 0, Side.index(:left) }
        specify { assert_equal 1, Side.index('right') }
        specify { assert_equal 1, Side.index(:right) }
        specify { assert_equal 2, Side.index('whole') }
        specify { assert_equal 2, Side.index(:whole) }
        specify do
          assert_raises Enum::TokenNotFoundError do
            Side.enum(:invalid)
          end
        end
        specify do
          assert_raises Enum::TokenNotFoundError do
            Side.enum('invalid')
          end
        end
      end
    end
  end

  describe NewSide do
    describe '#all' do
      it 'returns the parent tokens and itself tokens' do
        assert_equal ['left', 'right', 'whole', 'center'], NewSide.all
      end
    end

    describe '#enum' do
      describe "has parent's tokens and itselves" do
        specify { assert_equal 'left', NewSide.enum(:left) }
        specify { assert_equal 'right', NewSide.enum(:right) }
        specify { assert_equal 'whole', NewSide.enum(:whole) }
        specify { assert_equal 'center', NewSide.enum(:center) }
        specify do
          assert_raises Enum::TokenNotFoundError do
            NewSide.enum(:invalid)
          end
        end
        specify do
          assert_raises Enum::TokenNotFoundError do
            NewSide.enum('invalid')
          end
        end
      end
    end

    describe '#name' do
      describe "has parent's translation and itself" do
        specify { assert_equal 'This is a left side', NewSide.name('left') }
        specify { assert_equal 'This is a left side', NewSide.name(:left) }
        specify { assert_equal 'translation missing: en.enum.NewSide.right', NewSide.name('right') }
        specify { assert_equal 'translation missing: en.enum.NewSide.right', NewSide.name(:right) }
      end
    end

    describe '#find_index' do
      describe 'returns index for given token' do
        specify { assert_equal 0, NewSide.index('left') }
        specify { assert_equal 0, NewSide.index(:left) }
        specify { assert_equal 1, NewSide.index('right') }
        specify { assert_equal 1, NewSide.index(:right) }
        specify { assert_equal 2, NewSide.index('whole') }
        specify { assert_equal 2, NewSide.index(:whole) }
        specify { assert_equal 3, NewSide.index('center') }
        specify { assert_equal 3, NewSide.index(:center) }
        specify do
          assert_raises Enum::TokenNotFoundError do
            NewSide.enum(:invalid)
          end
        end
        specify do
          assert_raises Enum::TokenNotFoundError do
            NewSide.enum('invalid')
          end
        end
      end
    end
  end
end
