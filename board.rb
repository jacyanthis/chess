require_relative 'piece'
require_relative 'emptyspace'


class Board
  attr_accessor :grid

  def initialize
    @sentinel = EmptySpace.new
    @grid = Array.new(8) { Array.new(8) { @sentinel } }
    populate_board
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, new_piece)
    row, col = pos
    @grid[row][col] = new_piece
  end

  def pop_pawns
    puts self
    @grid[1].each_with_index do |_, col_idx|
      self[[1, col_idx]] = Pawn.new([1, col_idx], self, :red)
    end

    @grid[6].each_with_index do |_, col_idx|
      self[[6, col_idx]] = Pawn.new([6, col_idx], self, :blue)
    end
  end

  def pop_other
    @grid[0] = [
      Rook.new([0,0], self, :red),
      Knight.new([0,1], self, :red),
      Bishop.new([0,2], self, :red),
      Queen.new([0,3], self, :red),
      King.new([0,4], self, :red),
      Bishop.new([0,5], self, :red),
      Knight.new([0,6], self, :red),
      Rook.new([0,7], self, :red)
    ]

    @grid[7] = [
      Rook.new([7,0], self, :blue),
      Knight.new([7,1], self, :blue),
      Bishop.new([7,2], self, :blue),
      Queen.new([7,3], self, :blue),
      King.new([7,4], self, :blue),
      Bishop.new([7,5], self, :blue),
      Knight.new([7,6], self, :blue),
      Rook.new([7,7], self, :blue)
    ]
  end

  def populate_board
    pop_pawns
    # self[[5, 4]] = Knight.new([5, 4], self, :red)
    pop_other
  end

  def execute_move(move)
    start, finish = move
    puts move
    self[finish] = self[start].move(finish)
    self[start] = @sentinel
  end

  def blocked?(pos)
    !on_board?(pos) || occupied?(pos)
  end

  def on_board?(pos)
    (0...8).include?(pos[0]) && (0...8).include?(pos[1])
  end

  def occupied?(pos)
    self[pos].occupied?
  end

  def attackable?(pos, color)
    on_board?(pos) && occupied?(pos) && self[pos].color != color
  end

  def won?
    #TODO won
    false
  end

end
