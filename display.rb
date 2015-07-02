require_relative 'board'
require_relative 'cursor_input'
require "colorize"


class Display
  attr_accessor :pos, :board, :game

  def initialize(board, game)
    @board = board
    @pos = [0, 0]
    @game = game
  end

  def render
    system("clear")
    pos_moves = board[pos].moves
    (0...8).each do |row_idx|
      (0...8).each do |col_idx|
        if pos == [row_idx, col_idx]
          print board[[row_idx, col_idx]].to_s.colorize(:background => :light_green)
        elsif pos_moves.include?([row_idx, col_idx])
          if board[[row_idx, col_idx]].occupied?
            print board[[row_idx, col_idx]].to_s.colorize(:background => :yellow)
          else
            print board[[row_idx, col_idx]].to_s.colorize(:background => :cyan)
          end
        elsif (row_idx + col_idx).even?
          print board[[row_idx, col_idx]].to_s.colorize(:background => :white)
        else
          print board[[row_idx, col_idx]].to_s.colorize(:background => :black)
        end
      end
      puts
    end
  end

  def cursor_loop(pick_or_place, first_pos = nil)
    first_pos.freeze
    loop do
      render
      if pick_or_place == :pick
        puts "Please select a piece to move, #{game.current_color}."
      else
        puts "Please select a location to move the piece from #{first_pos}"
        puts "You can move it to any of these locations: #{board[first_pos].moves}"
      end
      puts ""
      puts "Please use the arrow keys to select a position."
      puts "Press 'enter' to select a piece or a move location."
      puts "Press 's' to save or 'q' to quit."
      command = show_single_key
      if command == :return
        return pos if pick_or_place == :pick && board[pos].color == game.current_color
        return pos if pick_or_place == :place #&& board[first_pos].moves.include?(pos)
      elsif command == :"\"s\""
        offer_save
        break
      elsif command == :"\"q\""
        exit 0
      elsif command == :up && board.on_board?([pos[0] - 1, pos[1]])
        self.pos[0] -= 1
      elsif command == :down && board.on_board?([pos[0] + 1, pos[1]])
        self.pos[0] += 1
      elsif command == :left && board.on_board?([pos[0], pos[1] - 1])
        self.pos[1] -= 1
      elsif command == :right && board.on_board?([pos[0], pos[1] + 1])
        self.pos[1] += 1
      end
    end
  end

end
