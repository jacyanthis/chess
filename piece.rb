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

  attr_accessor :color, :pos, :board

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def dup(new_board)
    self.class.new(pos, new_board, color)
  end

  def occupied?
    true
  end

  def move(new_pos)
    self.pos = new_pos

    self
  end

  def valid_moves
    moves.reject do |move|
      duped_board = board.deep_dup_board
      duped_board.execute_move([pos, move])

      duped_board.in_check?(color)
    end
  end

end
