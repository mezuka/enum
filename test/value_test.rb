require 'test_helper'

describe Enum::Value do
  describe '#klass' do
    describe 'returns Base child' do
      specify { assert_equal Side, Side.new(:left).klass }
    end
  end

  describe '#enum_value' do
    describe 'sends symbol or string to Base#enum' do
      specify { assert_equal 'right', Side.new(:right).send(:enum_value, :right) }
      specify { assert_equal 'right', Side.new(:right).send(:enum_value, 'right') }
    end
    
    describe 'sends integer to Base#index' do
      specify { assert_equal 'right', Side.new(:right).send(:enum_value, 1) }
    end
    
    describe 'sends self.stored_value as default' do
       specify { assert_equal 'whole', Side.new(:whole).send(:enum_value) }
    end
    
    describe 'wihtout :suppress_read_errors' do
      describe 'raises TokenNotFoundError if given invalid token' do
        specify do
          assert_raises Enum::TokenNotFoundError do
            Side.new(:right).send(:enum_value, :invalid)
          end
        end
      end
      
      describe 'returns nil given out-of-bounds integer' do
        specify { assert_nil Side.new(:right).send(:enum_value, 9) }
      end
    end
    
    describe 'with :suppress_read_errors' do
      describe 'returns any given invalid token' do
        specify do
          suppressed = Suppressed.new(:right)
          assert_equal :invalid, suppressed.send(:enum_value, :invalid)
        end
      end
    end
  end
  
end # Enum::Value