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


  def moves
    moves_from_steps(KNIGHT_STEPS)
  end

  def to_s
    " ♞ ".colorize(color)
  end
end

class King < SteppingPiece
  def moves
    moves_from_steps(HOR_VERT_STEPS) + moves_from_steps(DIAGONAL_STEPS)
  end

  def to_s
    " ♚ ".colorize(color)
  end
end
