require 'set'

module Enum
  class Base < BasicObject
    class << self
      def inherited(child)
        return if self == Enum

        init_child_class(child)
      end

      def start_index=(index)
        @start_index = index
      end

      def values(*ary)
        ary.each { |val| add_value(val.to_s) }
      end

      def all
        history
      end

      def token(t)
        ts = t.to_s
        unless store.include?(ts)
          raise(TokenNotFoundError, "token '#{t}'' not found in the enum #{self}")
        end
        ts
      end

      def name(t)
        translate(token(t))
      end

      protected

      def store
        @store ||= Set.new
      end

      def store=(hash)
        @store = hash
      end

      def history
        @history ||= Array.new
      end

      def history=(ary)
        @history ||= ary
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

      def start_index
        @start_index ||= 0
      end

      def init_child_class(child)
        child.store = self.store.clone
        child.history = self.history.clone
      end

    end
  end
end
