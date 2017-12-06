require 'set'
require 'forwardable'

module Enum
  class Base < BasicObject
    class << self
      def inherited(child)
        return if self == Enum

        init_child_class(child)
      end

      def values(*ary)
        ary.each { |val| add_value(val.to_s) }
      end

      def all
        history
      end

      def indexes
        (0...store.size).to_a
      end

      def include?(token)
        store.include?(token.to_s)
      end

      def enums(*tokens)
        tokens.map { |token| enum(token) }
      end

      def enum(t)
        ts = t.to_s
        unless store.include?(ts)
          raise(TokenNotFoundError, "token '#{t}'' not found in the enum #{self}")
        end
        ts
      end

      # Allow Class.name to work if no args are given.
      def name(*t)
        if t.empty?
          super
        else
          translate(enum(t[0]))
        end
      end

      def index(token)
        history.index(enum(token))
      end
      
      # Get a new Value instance
      def new(new_value)
        new_instance = self::Value.new(new_value)
        new_instance
      end
      
      # Render value given interger, string, or symbol.
      def [](val)
        case
        when val.is_a?(::Integer)
          self.all[val]
        when val.is_a?(::Symbol) || val.is_a?(::String)
          self.enum(val)
        else
          self.enum(val)
        end
      end

      protected

      def store
        @store ||= Set.new
      end

      def store=(set)
        @store = set
      end

      def history
        @history ||= Array.new
      end

      def history=(ary)
        @history = ary
      end

      def translate(token, options = {})
        I18n.t(token, scope: "enum.#{self}", exception_handler: proc do
          if superclass == Enum::Base
            I18n.t(token, options.merge(scope: "enum.#{self}"))
          else
            superclass.translate(token, exception_handler: proc do
              I18n.t(token, scope: "enum.#{self}")
            end)
          end
        end)
      end

      private

      def add_value(val)
        store.add(val)
        history.push(val)
      end

      def init_child_class(child)
        class << child
          extend ::Forwardable
          def_delegators :'self::Value', :default, :supress_read_errors
        end
        child.const_set :Value, ::Class.new(::Enum::Value)
        child::Value.klass = child
        
        child.store = self.store.clone
        child.history = self.history.clone
      end

    end
  end
end
