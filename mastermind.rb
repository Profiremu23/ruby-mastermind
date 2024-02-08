# frozen_string_literal: true

# Defining the cells that makes up the game board
class Cell
  attr_accessor :symbol

  def initialize
    @symbol = nil
  end

  def free?
    symbol.nil?
  end

  def to_s
    symbol || ' '
  end
end

# Defining the Mastermind game board
class GameBoard
  attr_accessor :turn
  attr_reader :board_state

  def initialize
    @board_state = Array.new(4) { Cell.new }
    @turn = 1
  end

  def update_cell(index, colour)
    board_state[index].symbol = colour
  end

  def print_board
    print "\n| #{board_state[0]} | #{board_state[1]} | #{board_state[2]} | #{board_state[3]} |\n"
  end
end

p mastermind = GameBoard.new
p mastermind.update_cell(1, "purple")
p mastermind.print_board
