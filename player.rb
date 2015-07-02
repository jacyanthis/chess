class Player
  attr_accessor :game, :display, :color

  def initialize(game, display, color)
    @game = game
    @display = display
    @color = color
  end
end

class Human < Player

  def get_move
    first_move = display.cursor_loop(:pick).map {|x| x}
    second_move = display.cursor_loop(:place, first_move.map {|x| x})
    [first_move, second_move]
  end
end

class Computer < Player

end
