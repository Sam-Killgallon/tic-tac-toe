#!/usr/bin/env ruby

require_relative 'tic_tac_toe'

def want_to_play?
  print 'Do you want to play? again (y/n): '
  answer = $stdin.gets.chomp
  answer == 'y'
end

def play!
  game = TicTacToe.new('X', 'O')
  game.start
end

# Play on first run, after game prompt for additional games
play!
while want_to_play?
  play!
end

