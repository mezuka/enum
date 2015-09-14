require 'set'

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

      def take(*tokens)
        tokens.map { |token| enum(token) }
      end

      def enum(t)
        ts = t.to_s
        unless store.include?(ts)
          raise(TokenNotFoundError, "token '#{t}'' not found in the enum #{self}")
        end
        ts
      end

      def name(t)
        translate(enum(t))
      end

      def index(token)
        history.index(enum(token))
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
        child.store = self.store.clone
        child.history = self.history.clone
      end

    end
  end
end
