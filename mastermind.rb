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
    @entered_colour = ' '
    @index = 0
    @turn = 0
  end

  def update_cell(index, colour)
    board_state[index].symbol = colour
  end

  def print_board
    print "\n| #{board_state[0]} | #{board_state[1]} | #{board_state[2]} | #{board_state[3]} |\n"
  end
end

# Defining the Mastermind game mechanics
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

  def print_colour_code
    print "| #{colour_code[0]} | #{colour_code[1]} | #{colour_code[2]} | #{colour_code[3]} |\n\n"
  end

  def mastermind_winning_condition
    if @board_state == @colour_code
      puts "Congratulations! You have successfully guessed your given colour code in #{@turn} turns!"
    elsif turn > 12
      puts 'Sorry! You have failed to successfully guess your given colour code within 12 turns, the solution was:'
      print_colour_code
    else
      colour_code_guesser
      @turn += 1
    end
  end

  def colour_code_guesser
    until @board_state[0].free? == false && @board_state[1].free? == false && @board_state[2].free? == false && @board_state[3].free? == false
      @index = gets.chomp.to_i
      until @index.negative? == false && @index < 4
        puts 'The entered given index value is out of range!'
        @index = gets.chomp.to_i
      end

      @entered_colour = gets.chomp
      until @entered_colour == colours[0] || @entered_colour == colours[1] || @entered_colour == colours[2] || @entered_colour == colours[3] || @entered_colour == colours[4] || @entered_colour == colours[5] || @entered_colour == colours[6] || @entered_colour == colours[7]
        puts 'The entered given colour is invalid!'
        @entered_colour = gets.chomp
      end

      puts update_cell(@index, @entered_colour)
      print_board
    end
  end

  def mastermind_game
    colour_code_generator
    colour_code_guesser
    mastermind_winning_condition
  end
end

mastermind = Game.new
mastermind.mastermind_game
