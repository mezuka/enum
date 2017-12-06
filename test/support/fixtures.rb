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


module Room
  class Side < Enum::Base
    values :left, :right
  end
end

class Suppressed < Enum::Base
  values :left, :right, :whole
  suppress_read_errors true
end

class LoadAnyValue < Enum::Base
  values :left, :right, :whole
  default :ANY
  suppress_read_errors true
end