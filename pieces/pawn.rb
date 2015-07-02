class Pawn < Piece
  attr_accessor :moved

  def initialize(pos, board, color, moved = false)
    super(pos, board, color)
    @moved = moved
  end

  def dup(new_board)
    self.class.new(pos, new_board, color, moved)
  end

  def move(pos)
    self.moved = true
    super
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
    if color == :blue
      attackable_pos = [[pos[0] - 1, pos[1] + 1] , [pos[0] - 1, pos[1] - 1]]
    else
      attackable_pos = [[pos[0] + 1, pos[1] + 1] , [pos[0] + 1, pos[1] - 1]]
    end

    attackable_pos.select { |pos| board.attackable?(pos, color)}
  end

  def moves
    pawn_attack + forward_moves
  end

  def to_s
    " ♟ ".colorize(color)
  end
end
