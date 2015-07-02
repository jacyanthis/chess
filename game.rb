require_relative 'display'
require_relative 'player'

#TODO add player names, retain possible moves in render after piece picked up

class ChessGame
  attr_accessor :board, :display, :players

  def self.pick_mode
    system 'clear'
    puts "Select your mode from the following:"
    puts "1 - Player vs. Player"
    puts "2 - Player vs. Computer"
    puts "3 - Computer vs. Computer"
    mode = gets.chomp
    case mode
    when "1"
      ChessGame.new(:human, :human).run
    when "2"
      ChessGame.new(:human, :computer).run
    when "3"
      ChessGame.new(:computer, :computer).run
    end
  end

  def initialize(player1, player2)
    @board = Board.new
    @display = Display.new(board, self)
    @players = [make_player(player1, :blue), make_player(player2, :red)]
  end

  def make_player(player, color)
    player == :human ? Human.new(self, display, color) : Computer.new(self, display, color)
  end

  def current_player
    players.first
  end

  def current_color
    current_player.color
  end

  def run
    turn until game_over?
    game_over_message
  end

  def turn
    move = current_player.get_move
    execute_move(move)
    switch_turn
  end

  def execute_move(move)
    board.execute_move(move)
  end

  def switch_turn
    players.rotate!
  end

  def game_over?
    board.won?
  end

  def game_over_message
    #TODO game over message
  end

end

ChessGame.pick_mode
