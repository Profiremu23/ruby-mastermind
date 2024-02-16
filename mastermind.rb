# frozen_string_literal: true

# Defining the Mastermind game board
class GameBoard
  attr_accessor :colours, :turn
  attr_reader :guesser_code

  def initialize
    @guesser_code = Array.new(4)
    @colours = %w[red blue yellow purple green orange black white]
    @entered_colour = ' '
    @i = 0
    @ind = 0
    @index = 0
    @matches = 0
    @turn = 12
  end

  def update_cell(index, colour)
    guesser_code[index] = colour
  end

  def print_board
    print "\n| #{guesser_code[0]} | #{guesser_code[1]} | #{guesser_code[2]} | #{guesser_code[3]} |\n\n"
  end
end

# Defining the Mastermind game mechanics
class Game < GameBoard
  attr_reader :colour_code, :matching_code

  def initialize
    super
    @colour_code = Array.new(4)
    @matching_code = []
  end

  def guesser_code_clearer
    guesser_code[0] = nil
    guesser_code[1] = nil
    guesser_code[2] = nil
    guesser_code[3] = nil
  end

  def matching_code_clearer
    matching_code[0] = nil
    matching_code[1] = nil
    matching_code[2] = nil
    matching_code[3] = nil
  end

  def colour_code_generator
    colour_code[0] = @colours.sample
    colour_code[1] = @colours.sample
    colour_code[2] = @colours.sample
    colour_code[3] = @colours.sample
  end

  def print_colour_code
    print "| #{colour_code[0]} | #{colour_code[1]} | #{colour_code[2]} | #{colour_code[3]} |\n\n"
  end

  def print_matching_code
    print "| #{matching_code[0]} | #{matching_code[1]} | #{matching_code[2]} | #{matching_code[3]} |\n\n"
  end

  def colour_code_matching
    4.times do
      if @guesser_code[@ind] == colour_code[@ind]
        @matching_code << 'white'
        @matches += 1
      else
        4.times do
          if @colour_code.include?(@guesser_code[@ind]) == true && (@guesser_code[@ind] = colour_code[@i] == false)
            @matching_code << 'black'
          else
            @matching_code << ' '
          end
          @i += 1
        end
      end
      @ind += 1
    end
    puts "#{@matches} colours with their exact locations have been found"
    print_matching_code
    @matches = 0
    @ind = 0
  end

  def mastermind_winning_condition
    if @matches == 4
      puts "Congratulations! You have successfully guessed your given colour code in #{@turn} turns!"
      print_colour_code
    elsif @turn < 13 && @matches < 4
      puts 'Your summitted code does not fully match with the mystery code!'
      colour_code_matching
      @turn += 1
      guesser_code_clearer
      colour_code_guesser
    else
      puts 'Sorry! You have failed to successfully guess your given colour code within 12 turns, the solution was:'
      print_colour_code
    end
  end

  def colour_code_guesser
    puts "\nGuess #{@turn} out of 12"

    until @guesser_code[0].nil? == false && @guesser_code[1].nil? == false && @guesser_code[2].nil? == false && @guesser_code[3].nil? == false
      print 'Please enter an index to place your colour in: '
      @index = gets.chomp.to_i
      until @index.negative? == false && @index < 4
        puts 'The entered given index value is out of range!'
        @index = gets.chomp.to_i
      end

      print "Please enter a colour for your chosen index (#{@index}): "
      @entered_colour = gets.chomp
      until @entered_colour == colours[0] || @entered_colour == colours[1] || @entered_colour == colours[2] || @entered_colour == colours[3] || @entered_colour == colours[4] || @entered_colour == colours[5] || @entered_colour == colours[6] || @entered_colour == colours[7]
        puts 'The entered given colour is invalid!'
        @entered_colour = gets.chomp
      end

      puts update_cell(@index, @entered_colour)
      print_board
    end
    mastermind_winning_condition
  end

  def mastermind_game
    colour_code_generator
    colour_code_guesser
  end
end

mastermind = Game.new
mastermind.mastermind_game
