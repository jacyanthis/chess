require_relative 'piece'
require_relative 'pieces/piece_subclasses'
require_relative 'emptyspace'


class Board
  attr_accessor :grid, :taken_pieces

  def initialize(duped = false)
    @sentinel = EmptySpace.new
    @grid = Array.new(8) { Array.new(8) { @sentinel } }
    @taken_pieces = []
    populate_board unless duped
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, new_piece)
    row, col = pos
    grid[row][col] = new_piece
  end

  def pop_pawns
    grid[1].each_with_index do |_, col_idx|
      self[[1, col_idx]] = Pawn.new([1, col_idx], self, :red)
    end

    grid[6].each_with_index do |_, col_idx|
      self[[6, col_idx]] = Pawn.new([6, col_idx], self, :blue)
    end
  end

  def pop_other
    grid[0] = [
      Rook.new([0,0], self, :red),
      Knight.new([0,1], self, :red),
      Bishop.new([0,2], self, :red),
      Queen.new([0,3], self, :red),
      King.new([0,4], self, :red),
      Bishop.new([0,5], self, :red),
      Knight.new([0,6], self, :red),
      Rook.new([0,7], self, :red)
    ]

    grid[7] = [
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
    pop_other
  end

  def execute_move(move)
    start, finish = move
    puts "i am moving from #{start} to #{finish}"
    taken_pieces << self[finish] if occupied?(finish)
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
    on_board?(pos) && self[pos].color == opponent_color(color)
  end

  def checkmate?(color)
    in_check?(color) && no_valid_moves(color)
  end

  def checkable?(color)
    all_pieces = grid.flatten.select do |piece|
      piece.color == color
    end

    ugly_moves = all_pieces.map do |piece|
      my_valid_moves = piece.valid_moves.select do |move|
        puts "my piece is #{piece.class} and my move is #{move}"
        duped_board = deep_dup_board
        puts "my duped board is #{duped_board.object_id} and my original was #{self.object_id}"
        duped_board.execute_move([piece.pos, move])
        puts "i think i am: #{duped_board.in_check?(opponent_color(color))} (in check)"
        duped_board.in_check?(opponent_color(color))
      end
      puts "my valid moves (#{piece}) are #{my_valid_moves}"
      my_valid_moves
    end

    puts ugly_moves.to_s
    if ugly_moves.count > 1
      flattened = ugly_moves.flatten(1)
    else
      flattened = [ugly_moves]
    end
    puts flattened.to_s
    compacted = flattened.compact
    puts compacted.to_s
    compacted
  end


  def stalemate?(color)
    !in_check?(color) && no_valid_moves(color)
  end

  def two_kings_left?
    grid.flatten.select do |piece|
      piece.occupied?
    end.count == 2
  end

  def no_valid_moves(color)
    opponent_pieces(opponent_color(color)).all? {|piece| piece.valid_moves.empty?}
  end

  def in_check?(color)
    king_pos = find_king_pos(color)
    opponent_pieces(color).any? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def find_king_pos(color)
    king = grid.flatten.find do |piece|
      piece.class == King && piece.color == color
    end

    king.pos
  end

  def opponent_pieces(color)
    grid.flatten.select do |piece|
      piece.color == opponent_color(color)
    end
  end

  def opponent_color(color)
    color == :red ? :blue : :red
  end

  def all_valid_moves(color)
    all_pieces = grid.flatten.select do |piece|
      piece.color == color
    end

    all_pieces.map do |piece|
      piece.valid_moves.map do |move|
        [piece.pos, move]
      end
    end.flatten(1)

  end

  def deep_dup_board
    new_board = Board.new(false)
    new_grid = deep_dup_grid(grid, new_board)
    new_board.grid = new_grid
    new_board
  end

  def deep_dup_array(array, new_board)
    array.map do |piece|
      piece.dup(new_board)
    end
  end

  def deep_dup_grid(array, new_board)
    return deep_dup_array(array, new_board) if array.none? {|el| el.is_a?(Array) }
    array.map {|el| deep_dup_grid(el, new_board)}
  end

end
