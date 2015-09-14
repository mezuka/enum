module Enum
  module Predicates
    def enumerize(field, enum)
      define_method("#{field}_is?") do |other|
        if (field_value = public_send(field)) && other
          enum.take(field_value) == enum.take(other)
        else
          false
        end
      end
    end
  end
end
