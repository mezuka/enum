require 'enum/version'
require 'enum/token_not_found_error'
require 'enum/base'
require 'enum/predicates'

module Enum
  def self.[](*ary)
    Class.new(Base) do
      values(*ary)
    end
  end
end
