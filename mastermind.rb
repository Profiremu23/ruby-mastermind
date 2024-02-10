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
  attr_accessor :colours, :turn
  attr_reader :board_state

  def initialize
    @board_state = Array.new(4) { Cell.new }
    @colours = %w[red blue yellow purple green orange black white]
    @turn = 1
  end

  def update_cell(index, colour)
    board_state[index].symbol = colour
  end

  def print_board
    print "\n| #{board_state[0]} | #{board_state[1]} | #{board_state[2]} | #{board_state[3]} |\n"
  end
end

# Defining Mastermind game mechanics
class Game < GameBoard
  attr_reader :colour_code

  def initialize
    super
    @colour_code = Array.new(4) { Cell.new }
  end

  def colour_code_generator
    colour_code[0].symbol = @colours.sample
    colour_code[1].symbol = @colours.sample
    colour_code[2].symbol = @colours.sample
    colour_code[3].symbol = @colours.sample
  end
end

p mastermind = Game.new
mastermind.colour_code_generator
p mastermind.colour_code
