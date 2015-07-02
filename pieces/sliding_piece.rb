class SlidingPiece < Piece

  def diagonal_moves
    DIAGONAL_STEPS.map { |step| move_in_direction(step) }.flatten(1)
  end

  def hor_vert_moves
    HOR_VERT_STEPS.map { |step| move_in_direction(step) }.flatten(1)
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
