require 'colorize'
require 'byebug'

class Piece
  DIAGONAL_STEPS = [
    [1, 1],
    [-1, 1],
    [1, -1],
    [-1, -1]
  ]

  HOR_VERT_STEPS = [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1]
  ]
  KNIGHT_STEPS = [
    [2, 1],
    [-2, 1],
    [1, 2],
    [1, -2],
    [2, -1],
    [-2, -1],
    [-1, 2],
    [-1, -2]
  ]

  attr_accessor :color, :pos, :board

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def occupied?
    true
  end

  def move(new_pos)
    self.pos = new_pos

    self
  end

  def moves
    raise "Moves for this piece not defined yet!"
  end

end

class SlidingPiece < Piece

  def diagonal_moves
    resulting_moves = []
    DIAGONAL_STEPS.each { |step| resulting_moves += move_in_direction(step) }
    resulting_moves
  end

  def hor_vert_moves
    resulting_moves = []
    HOR_VERT_STEPS.each { |step| resulting_moves += move_in_direction(step) }
    resulting_moves
  end

  def move_in_direction(step)
    moves = []

    next_pos = [pos[0] + step[0], pos[1] + step[1]]

    until board.blocked?(next_pos)
      moves << next_pos
      next_pos = [next_pos[0] + step[0], next_pos[1] + step[1]]
    end

    if board.attackable?(next_pos, color)
      moves << next_pos
    end

    moves
  end

end

class Rook < SlidingPiece
  def moves
    hor_vert_moves
  end

  def to_s
    " ♜ ".colorize(color)
  end
end

class Bishop < SlidingPiece
  def moves
    diagonal_moves
  end

  def to_s
    " ♝ ".colorize(color)
  end
end

class Queen < SlidingPiece
  def moves
    diagonal_moves + hor_vert_moves
  end

  def to_s
    " ♛ ".colorize(color)
  end
end



class SteppingPiece < Piece
  def moves_from_steps(steps)
    resulting_moves = []
    steps.each do |step|
      new_pos = [pos[0] + step[0], pos[1] + step[1]]
      resulting_moves << new_pos unless board.blocked?(new_pos) && !board.attackable?(new_pos, color)
    end
    resulting_moves
  end
end

class Knight < SteppingPiece
  def moves
    moves_from_steps(KNIGHT_STEPS)
  end

  def to_s
    " ♞ ".colorize(color)
  end
end

class King < SteppingPiece
  def moves
    moves_from_steps(HOR_VERT_STEPS)
  end

  def to_s
    " ♚ ".colorize(color)
  end
end


class Pawn < Piece
  attr_accessor :moved

  def initialize(pos, board, color)
    super(pos, board, color)
    @moved = false
  end

  def move(pos)
    self.moved = true
    super(pos)
  end

  def forward_moves
    moves = []
    steps = 1
    new_pos = color == :blue ? [pos[0] - steps, pos[1]] : [pos[0] + steps, pos[1]]
    until board.blocked?(new_pos) || steps > 2
      moves << new_pos
      steps += 1
      new_pos = color == :blue ? [pos[0] - steps, pos[1]] : [pos[0] + steps, pos[1]]
      break if moved
    end

    moves
  end

  def pawn_attack
    attackable_pos = color == :blue ? [[pos[0] - 1, pos[1] + 1] , [pos[0] - 1, pos[1] - 1]] : [[pos[0] + 1, pos[1] + 1] , [pos[0] + 1, pos[1] - 1]]
    attackable_pos.select { |pos| board.attackable?(pos, color)}
  end

  def moves
    pawn_attack + forward_moves
  end

  def to_s
    " ♟ ".colorize(color)
  end
end
