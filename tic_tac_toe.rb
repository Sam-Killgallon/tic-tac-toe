require_relative 'game_board'
require 'colorize'

class TicTacToe
  def initialize(symbol_one, symbol_two)
    @player_one = symbol_one.blue
    @player_two = symbol_two.yellow
    @current_player = player_one
    @board = GameBoard.new
  end

  def start
    draw_board

    until game_over?
      position = get_input
      board.mark(*position, current_player)
      draw_board
      next_player!
    end

    if board.winner
      puts "\n\nPlayer #{board.winner} won the game!".green
    else
      puts "Ran out of spaces to play! Its a draw".red
    end
  rescue OutOfBounds, AlreadyTaken => e
    puts e.message
    retry
  end

  def get_input
    print "Player #{current_player} - Select a cell (Enter x,y starting from 0,0 in the top left corner): "
    $stdin.gets.chomp.split(',').map! { |coord| coord.to_i }
  end

  def next_player!
    if current_player == player_one
      self.current_player = player_two
    else
      self.current_player = player_one
    end
  end

  def draw_board
    puts ''
    board.draw
    puts ''
  end

  def game_over?
    board.winner || board.full?
  end

  private
  attr_accessor :current_player
  attr_reader :player_one, :player_two, :board
end
