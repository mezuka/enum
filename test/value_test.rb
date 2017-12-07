require 'test_helper'

describe Enum::Value do
  describe '.default_value' do; end
  
  describe '.suppress_read_errors' do; end
  
  describe '#initialize' do; end

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
  end # #enum_value
  
  describe '#to_s' do
    describe 'gets enum_value as string' do
      specify { assert_instance_of String, Side.new(:left).send(:to_s) }
      specify { assert_equal 'left', Side.new(:left).send(:to_s) }
    end
  end
  
  describe '#to_sym' do
    describe 'gets enum_value as symbol' do
      specify { assert_instance_of Symbol, Side.new(:left).send(:to_sym) }
      specify { assert_equal :left, Side.new(:left).send(:to_sym) }
    end
    
    describe 'returns nil if enum_value does not repond_to to_sym' do
      specify { assert_nil LoadAnyValue.new(nil).send(:to_sym) }
    end
  end
  
  describe '#value' do
    describe 'gets enum_value of self' do
      specify { assert_equal 'left', Side.new(:left).send(:value) }
    end
  end
  
  describe '#nil?' do
    describe 'returns true if @stored_value is nil' do
      specify { assert LoadAnyValue.new(nil).send(:nil?) }
      specify { assert_equal false, LoadAnyValue.new(:something).send(:nil?) }
    end
  end
  
  describe '#valid?' do
    describe 'returns true if @stored_value is valid enum' do
      specify { assert LoadAnyValue.new(:left).send(:valid?) }
      specify { assert_equal false, LoadAnyValue.new(nil).send(:valid?) }
    end
  end
  
  describe '#index' do
    describe 'returns index of given valid token' do
      specify { assert_equal 2, Side.new(:left).send(:index, :whole) }
    end
    
    describe 'raises TokenNotFoundError if token invalid' do
      specify do
        assert_raises Enum::TokenNotFoundError do
          Side.new(:left).send(:index, :invalid)
        end
      end
    end
    
    describe 'returns index of @stored_value' do
      specify { assert_equal 1, Side.new(:right).send(:index) }
    end
    
    describe 'returns nil if token invalid with suppress_read_errors' do
      specify { assert_nil LoadAnyValue.new(:right).send(:index, :invalid) }
    end
  end
  
  describe '#<=>' do
    describe 'comparable with symbol' do
      specify { assert_equal -1, Side.new(:right) <=> :whole }
      specify { assert_equal 0, Side.new(:right) <=> :right }
      specify { assert_equal 1, Side.new(:right) <=> :left }
    end
    
    describe 'comparable with string' do
      specify { assert_equal -1, Side.new(:right) <=> 'whole' }
      specify { assert_equal 0, Side.new(:right) <=> 'right' }
      specify { assert_equal 1, Side.new(:right) <=> 'left' }
    end
    
    describe 'comparable with integer' do
      specify { assert_equal -1, Side.new(:right) <=> 2 }
      specify { assert_equal 0, Side.new(:right) <=> 1 }
      specify { assert_equal 1, Side.new(:right) <=> 0 }
    end
    
    describe 'comparable with other Value object of same enum class' do
      specify { assert_equal -1, Side.new(:right) <=> Side.new(:whole) }
      specify { assert_equal 0, Side.new(:right) <=> Side.new(:right) }
      specify { assert_equal 1, Side.new(:right) <=> Side.new(:left) }
    end
    
    describe 'returns nil if uncomarable with other' do
      specify { assert_nil Side.new(:right) <=> Object.new }
      specify { assert_nil Side.new(:right) <=> nil }
      specify { assert_nil Side.new(:right) <=> LoadAnyValue.new(:right) }
    end
  end
  
end # Enum::Value