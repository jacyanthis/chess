class EmptySpace

  def to_s
    "   "
  end

  def occupied?
    false
  end

  def valid_moves
    []
  end

  def moves
    []
  end

  def color
    :none
  end

  def dup(new_board)
    self
  end

end
