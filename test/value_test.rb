require 'test_helper'

describe Enum::Value do

  describe '.inherited' do
    describe 'sets subclass.default_value to :ERROR' do
      specify { assert_equal :ERROR, Class.new(Enum::Value).instance_variable_get(:@default_value) }
    end
    describe 'sets subclass.suppress_read_errors to false' do
      specify { assert_equal false, Class.new(Enum::Value).instance_variable_get(:@suppress_read_errors) }
    end
  end
  
  describe '.default_value' do
    before { @side = Class.new(Side) }
    describe 'sets class-level @default_value to args[0] if args[0] exist' do
      specify { @side::Value.default_value(:something); assert_equal :something, @side::Value.instance_variable_get(:@default_value) }
    end
    describe 'returns class-level @default_value if args.empty?' do
      specify { assert_equal :ERROR, @side::Value.instance_variable_get(:@default_value) }
    end
  end
  
  describe '.suppress_read_errors' do
    before { @side = Class.new(Side) }
    describe 'sets class-level @suppress_read_errors to args[0] if args[0] exist' do
      specify { @side::Value.suppress_read_errors(true); assert_equal true, @side::Value.instance_variable_get(:@suppress_read_errors) }
    end
    describe 'returns class-level @suppress_read_errors if args.empty?' do
      specify { assert_equal false, @side::Value.instance_variable_get(:@suppress_read_errors) }
    end
  end
  
  describe '#initialize' do
    describe 'always returns frozen object, unless exception raised' do
      specify { assert Side::Value.allocate.send(:initialize, :left).frozen? }
    end
    
    describe 'given valid enum token' do
      it "sets @stored_value with frozen token" do
        assert_equal :left, Side::Value.allocate.send(:initialize, :left).instance_variable_get(:@stored_value)
        assert Side::Value.allocate.send(:initialize, :left).instance_variable_get(:@stored_value).frozen?
      end
    end
    
    describe 'given invalid enum token' do
      before do
        @side_class = Class.new(Side)
        @val_class = @side_class::Value
        @val_class.default_value :ERROR
        #@invalid_val = @val_class.allocate.send(:initialize, :invalid)
      end

      it 'sets @error with TokenNotFoundError' do
        @val_class.default_value :ANY
        @invalid_val = @val_class.allocate.send(:initialize, :invalid)
        assert_kind_of Enum::TokenNotFoundError, @invalid_val.instance_variable_get(:@error)
      end
      
      describe 'when default_value == :ERROR' do
        it 'raises TokenNotFoundError' do
          assert_raises(Enum::TokenNotFoundError) do
            @val_class.allocate.send(:initialize, :invalid)
          end
        end
      end
      
      describe 'when default_value == :ANY' do
        before do
          @val_class.default_value :ANY
          @invalid_value = @val_class.allocate.send(:initialize, :invalid)
        end
        it 'sets @stored_value = raw_val.freeze' do
          assert_equal :invalid, @invalid_value.instance_variable_get(:@stored_value)
          assert @invalid_value.instance_variable_get(:@stored_value).frozen?
        end
      end
      
      describe 'when default_value is anything else' do
        before do
          @val_class.default_value :none
          @invalid_value = @val_class.allocate.send(:initialize, :invalid)
        end
        it 'sets @stored_value = self.class.default_value.freeze' do
          assert_equal :none, @invalid_value.instance_variable_get(:@stored_value)
          assert @invalid_value.instance_variable_get(:@stored_value).frozen?
        end
      end
    end
  end

  describe '#klass' do
    describe 'returns Base child' do
      specify { assert_equal Side, Side.new(:left).klass }
    end
  end

  describe '#enum_value' do
    describe 'sends symbol or string to Base#enum' do
      specify("with_symbol") { assert_equal 'right', Side.new(:right).send(:enum_value, :right) }
      specify("with_string") { assert_equal 'right', Side.new(:right).send(:enum_value, 'right') }
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
  end # enum_value
  
  describe '#to_s' do
    describe 'gets enum_value as string' do
      specify('is_string') { assert_instance_of String, Side.new(:left).send(:to_s) }
      specify('return_correct_value') { assert_equal 'left', Side.new(:left).send(:to_s) }
    end
  end
  
  describe '#to_sym' do
    describe 'gets enum_value as symbol' do
      specify('is_symbol') { assert_instance_of Symbol, Side.new(:left).send(:to_sym) }
      specify('return_correct_value') { assert_equal :left, Side.new(:left).send(:to_sym) }
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
      specify('given_nil') { assert LoadAnyValue.new(nil).send(:nil?) }
      specify('given_non_nil') { assert_equal false, LoadAnyValue.new(:something).send(:nil?) }
    end
  end
  
  describe '#valid?' do
    describe 'returns true if @stored_value is valid enum' do
      specify('given_valid_value') { assert LoadAnyValue.new(:left).send(:valid?) }
      specify('given_invalid_value') { assert_equal false, LoadAnyValue.new(nil).send(:valid?) }
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
      specify('less_than') { assert_equal -1, Side.new(:right) <=> :whole }
      specify('equal_to') { assert_equal 0, Side.new(:right) <=> :right }
      specify('greater_than') { assert_equal 1, Side.new(:right) <=> :left }
    end
    
    describe 'comparable with string' do
      specify('less_than') { assert_equal -1, Side.new(:right) <=> 'whole' }
      specify('equal_to') { assert_equal 0, Side.new(:right) <=> 'right' }
      specify('greater_than') { assert_equal 1, Side.new(:right) <=> 'left' }
    end
    
    describe 'comparable with integer' do
      specify('less_than') { assert_equal -1, Side.new(:right) <=> 2 }
      specify('equal_to') { assert_equal 0, Side.new(:right) <=> 1 }
      specify('greater_than') { assert_equal 1, Side.new(:right) <=> 0 }
    end
    
    describe 'comparable with other Value object of same enum class' do
      specify('less_than') { assert_equal -1, Side.new(:right) <=> Side.new(:whole) }
      specify('equal_to') { assert_equal 0, Side.new(:right) <=> Side.new(:right) }
      specify('greater_than') { assert_equal 1, Side.new(:right) <=> Side.new(:left) }
    end
    
    describe 'returns nil if uncomarable with other' do
      specify('with_object') { assert_nil Side.new(:right) <=> Object.new }
      specify('with_nil') { assert_nil Side.new(:right) <=> nil }
      specify('with_invalid_other_instance') { assert_nil Side.new(:right) <=> LoadAnyValue.new(:right) }
    end
  end
  
end # Enum::Value