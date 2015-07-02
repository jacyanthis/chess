require_relative 'board'
require_relative 'cursor_input'
require 'colorize'


class Display
  attr_accessor :cursor, :board, :game

  def initialize(board, game)
    @board = board
    @cursor = [0, 0]
    @game = game
  end

  def game_over_message
    render
    if board.checkmate?(game.current_color)
      puts "Checkmate, #{board.opponent_color(current_color)} wins."
    else
      puts "It's a stalemate!"
    end
  end

  def display_modes
    system 'clear'
    puts "Select your mode from the following:"
    puts "1 - Player vs. Player"
    puts "2 - Player vs. Computer"
    puts "3 - Computer vs. Computer"
    puts "4 - Load a game"
  end

  def find_taken(color)
    result = ""
    board.taken_pieces.select{ |piece| piece.color == color}.each do |piece|
      result += piece.to_s
    end

    result.split(" ").join(" ")
  end

  def render(first_pos = nil)
    if first_pos.nil?
      highlighted_positions = board[cursor].valid_moves
    else
      highlighted_positions = board[first_pos].valid_moves
    end
    system("clear")
    puts "   #{('A'..'H').to_a.join("  ")}"
    (0...8).each do |row_idx|
      print "#{8 - row_idx} "
      (0...8).each do |col_idx|
        if cursor == [row_idx, col_idx]
          print board[[row_idx, col_idx]].to_s.colorize(:background => :light_green)
        elsif highlighted_positions.include?([row_idx, col_idx])
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

      if row_idx == 0
        puts "   #{find_taken(:red)}"
      elsif row_idx == 7
        puts "   #{find_taken(:blue)}"
      else
        puts
      end
    end
  end

  def cursor_loop(pick_or_place, first_pos = nil)
    loop do
      render(first_pos)

      if pick_or_place == :pick && board[cursor].valid_moves.empty? && board.occupied?(cursor)
        puts "Cannot move this piece. (It is either blocked or would leave you in check!)"
      else
        puts
      end

      if game.board.in_check?(game.current_color)
        puts "#{game.current_color.to_s.capitalize}, you are in CHECK! You must get out of check."
      end

      if pick_or_place == :pick
        puts "\n\nPlease select a piece to move, #{game.current_color}."
      else
        puts "\nPlease select a position to move the #{board[first_pos].class}"
        puts "To pick up another piece, press 'e'"
      end
      puts ""
      puts "Please use the arrow keys to select a position."
      puts "Press 'enter' to select a piece or a move location."
      puts "Press 's' to save or 'q' to quit."
      command = show_single_key

      if command == :"\"d\""
        debugger
      end

      if command == :return
        return cursor.dup if pick_or_place == :pick && board[cursor].color == game.current_color ||
          pick_or_place == :place && board[first_pos].valid_moves.include?(cursor)
      elsif command == :"\"s\""
        game.save
      elsif command == :"\"e\""
        return :e
      elsif command == :"\"q\""
        exit 0
      elsif command == :up && board.on_board?([cursor[0] - 1, cursor[1]])
        self.cursor[0] -= 1
      elsif command == :down && board.on_board?([cursor[0] + 1, cursor[1]])
        self.cursor[0] += 1
      elsif command == :left && board.on_board?([cursor[0], cursor[1] - 1])
        self.cursor[1] -= 1
      elsif command == :right && board.on_board?([cursor[0], cursor[1] + 1])
        self.cursor[1] += 1
      end
    end
  end

end
