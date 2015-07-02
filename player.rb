class Player
  attr_accessor :game, :display, :color

  def initialize(game, display, color)
    @game = game
    @display = display
    @color = color
  end
end

class Human < Player

  def pick
    display.cursor_loop(:pick)
  end


  def place(first_pos)
    picked_pos = display.cursor_loop(:place, first_pos)

    if picked_pos == :e
      raise ResetError.new
    else
      picked_pos
    end
  end

  def get_move
    begin
      first_pos = pick

      [first_pos, place(first_pos)]
    rescue ResetError => e
      retry
    end
  end
end

class Computer < Player
  def get_move
    options = game.board.all_valid_moves(color)
    attackables = options.select {|move| game.board.attackable?(move[1], color)}
    checkables = game.board.checkable?(color)
    display.render

    if checkables.length > 0
      p checkables.to_s
      puts "The AI is moving!"
      puts "i found checkables: #{checkables}"
      checkables.sample
    elsif attackables.length > 0
      puts "The AI is moving!"
      attackables.sample
    else
      puts "The AI is moving!"
      options.sample
    end


  end
end

class ResetError < StandardError
end
