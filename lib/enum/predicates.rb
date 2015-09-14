module Enum
  module Predicates
    def enumerize(field, enum)
      define_method("#{field}_is?") do |other|
        if (field_value = public_send(field)) && other
          enum.enum(field_value) == enum.enum(other)
        else
          false
        end
      end

      define_method("#{field}_any?") do |*others|
        others.all? { |other| enum.enum(other) } # make sure that all others values are valid enums
        others.any? { |other| public_send("#{field}_is?", other) }
      end
    end
  end
end
