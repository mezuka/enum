class Side < Enum::Base
  values :left, :right, :whole
end

class NewSide < Side
  values :center
end
