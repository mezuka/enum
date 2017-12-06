module Enum
  class Value
    
    include Comparable

    attr_reader :stored_value, :error
    
    class << self
      # subclass-value options
      #   :default => <:ERROR|:ANY|:something|nil>
      #   :read_any_value => <true|false>
      attr_accessor :default, :read_any_value, :klass
    end
    
    def self.inherited(subclass)
      # With no defaults, Value subclass settings will be thus:
      # subclass.read_any_value = nil
      # subclass.default = nil
    end
    
    # Combined getter/setter for 'default'.
    def self.default(*args)
      # Can't use .any? because [nil].any? is false (ruby 2.4),
      # and nil is a valid argument here.
      # [nil].empty? is also false, which is what we want.
      if !args.empty?
        @default = args[0]
      else
        @default
      end
    end
    
    # Combined getter/setter for 'read_any_value'.
    def self.read_any_value(*args)
      if !args.empty?
        @read_any_value = args[0]
      else
        @read_any_value
      end
    end
    
    # Load a primitive (symbol, string, integer) into new enum Value instance,
    # taking into consideration enum constraints, default value setting.
    # Returns frozen Value instance.
    def initialize(new_val) #, enum_class)
      begin
        @stored_value = klass[new_val].to_sym.freeze
      rescue Enum::TokenNotFoundError => _error
        @error = _error.freeze
        case
        when self.class.default == :ERROR
          raise _error
        when self.class.default == :ANY
          @stored_value = new_val.freeze
        else
          @stored_value = self.class.default.freeze
        end
      end
      self.freeze
      self
    end
    
    # Returns the Enum::Base subclass attached through Enum::Value subclass.
    def klass
      self.class.klass
    end
    
    # Convenience method to pass arguments to klass[].
    # Returns enum value given symbol, string, or integer.
    def enum_value(_value=stored_value)
      begin
        klass[_value]
      rescue Enum::TokenNotFoundError => _error
        if self.class.read_any_value
          _value
        else
          raise _error
        end
      end
    end
    private :enum_value

    # Returns result of Enum::Base subclass.enum(self) as string.
    def to_s
      enum_value.to_s
    end
    alias_method :to_str, :to_s

    # Returns result of Enum::Base subclass.enum(self) as symbol.
    def to_sym
      val = enum_value
      val.to_sym if val.respond_to?(:to_sym)
    end
    
    # Returns result of Enum::Base subclass.enum(self).
    def value
      enum_value
    end
    
    # Is stored value nil?
    def nil?
      @stored_value.nil?
    end
    
    # Is stored value valid for this enum class?
    def valid?
      klass.enum(@stored_value)
      true
    rescue Enum::TokenNotFoundError
      false
    end
      
    # This (or other) value's enum index.
    def index(_value=stored_value)
      begin
        klass.index(_value)
      rescue Enum::TokenNotFoundError => _error
        raise _error unless self.class.read_any_value
      end
    end
    alias_method :to_i, :index
    
    # Enable comparisons between Value instances, strings, symbols, and integers.
    def <=>(other)
      case
      when other.is_a?(Symbol)
        index <=> index(other)
      when other.is_a?(String)
        index <=> index(other)
      when other.is_a?(Integer)
        index <=> other
      when other.is_a?(self.class) && other.klass == klass
        index <=> other.index
      else
        # Nil will be uncomparable with strings, symbols, or integers,
        # and will raise exception, as it should.
        nil
      end
    end

  end # Value
end # Enum