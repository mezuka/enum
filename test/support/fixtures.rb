class Side < Enum::Base
  values :left, :right, :whole
end

class NewSide < Side
  values :center
end


class Table
  extend Enum::Predicates

  attr_accessor :side

  enumerize :side, Side
end
