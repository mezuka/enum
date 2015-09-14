require 'test_helper'

describe Enum::Predicates do
  describe Table do
    describe '#side_is? is generated and matches the table state with a given token' do
      before do
        @table = Table.new
      end

      describe '#side is nil' do
        before do
          @table.side = nil
        end

        specify { assert_equal false, @table.side_is?(:left) }
        specify { assert_equal false, @table.side_is?(nil) }
      end

      describe '#side is left' do
        before do
          @table.side = Side.take(:left)
        end

        specify { assert_equal true, @table.side_is?(:left) }
        specify { assert_equal false, @table.side_is?(:right) }
        specify { assert_equal false, @table.side_is?(nil) }
        specify do
          assert_raises Enum::TokenNotFoundError do
            @table.side_is?(:invalid)
          end
        end
      end

      describe '#side is invalid' do
        before do
          @table.side = 'invalid'
        end

        specify do
          assert_raises Enum::TokenNotFoundError do
            @table.side_is?(:left)
          end
        end

        specify { assert_equal false, @table.side_is?(nil) }
      end
    end
  end
end
