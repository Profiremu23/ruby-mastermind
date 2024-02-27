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
    @player_role = ' '
    @turn = 1
  end

  def update_cell(index, colour)
    if @player_role == 'I am the creator'
      colour_code[index] = colour
    elsif @player_role == 'I am the solver'
      guesser_code[index] = colour
    end
  end

  def print_board
    print "\n| #{guesser_code[0]} | #{guesser_code[1]} | #{guesser_code[2]} | #{guesser_code[3]} |\n\n"
  end
end

# Defining the Mastermind game mechanics
class Game < GameBoard
  attr_reader :colour_code, :colour_blacklist, :matching_code

  def initialize
    super
    @colour_code = Array.new(4)
    @matching_code = Array.new(4)
    @computer_memory_code = Array.new(4)
    @colour_blacklist = Array.new(4) { Array.new }
  end

  # Basic Mastermind game logic
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
    print "Matching palette: #{matching_code[0]}#{matching_code[1]}#{matching_code[2]}#{matching_code[3]}\n\n"
  end

  def colour_code_matching
    4.times do
      if @guesser_code[@ind] == colour_code[@ind]
        @matching_code[@ind] = 'white '
      elsif @guesser_code[@ind] != colour_code[@ind] && colour_code.include?(@guesser_code[@ind])
        @matching_code[@ind] = 'black '
      else
        @matching_code[@ind] = ''
      end
      @ind += 1
    end
    print_matching_code
    @ind = 0
  end

  def mastermind_winning_condition
    if @guesser_code == @colour_code
      puts "Congratulations! You have successfully solved the mystery code in #{@turn} turns!"
      print_colour_code
    elsif @turn < 12
      puts 'The summitted code does not fully match with the mystery code!'
      @turn += 1
      guesser_code_clearer
      player_role_reminder
      matching_code_clearer
    else
      puts 'Sorry! You have failed to successfully solve the mystery code within 12 turns, the solution was:'
      print_colour_code
    end
  end

  # Choosing the player's role in Mastermind
  def player_role_selection
    print "Please choose between the two rules you can take in Mastermind:\nEnter 'I am the creator' if you want to make the secret colour code for a computer player to solve it,\n or type 'I am the solver' if you want to solve the (randomly generated) secret colour code\n"
    @player_role = gets.chomp
    if @player_role == 'I am the creator'
      player_colour_code_creator
    elsif @player_role == 'I am the solver'
      colour_code_generator
      player_colour_code_guesser
    else
      puts 'Your answer is invalid! Please try again!'
      @player_role = gets.chomp
    end
  end

  # Memorizing the player's role in a given game
  def player_role_reminder
    if @player_role == 'I am the creator'
      computer_colour_code_guesser
    elsif @player_role == 'I am the solver'
      player_colour_code_guesser
    end
  end

  # Game mechanics for the player
  def player_colour_code_creator
    until @colour_code[0].nil? == false && @colour_code[1].nil? == false && @colour_code[2].nil? == false && @colour_code[3].nil? == false
      print 'Please enter an index to place your colour for your colour code: '
      @index = gets.chomp.to_i
      until @index.negative? == false && @index < 4
        puts 'The entered given index value is out of range!'
        @index = gets.chomp.to_i
      end

      print "Please enter a colour for your chosen index (#{@index}) within your colour code: "
      @entered_colour = gets.chomp
      until @entered_colour == colours[0] || @entered_colour == colours[1] || @entered_colour == colours[2] || @entered_colour == colours[3] || @entered_colour == colours[4] || @entered_colour == colours[5] || @entered_colour == colours[6] || @entered_colour == colours[7]
        puts 'The entered given colour is invalid!'
        @entered_colour = gets.chomp
      end

      puts update_cell(@index, @entered_colour)
      print_colour_code
    end
    computer_colour_code_guesser
  end

  def player_colour_code_guesser
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
    colour_code_matching
    mastermind_winning_condition
  end

  # Game mechanics for the AI
  def computer_colour_code_guesser
    puts "\nGuess #{@turn} out of 12"
    4.times do
      if @computer_memory_code[@i].nil?
        if @colour_blacklist[@i].count.zero?
          @guesser_code[@i] = @colours.sample
        else
          @colour_blacklist[@i].count do
            @colours.delete(@colour_blacklist[@i][@ind])
            @ind += 1
          end
          @colours.compact!
          @guesser_code[@i] = @colours.sample
          @ind = 0
        end
      else
        @guesser_code[@i] = @computer_memory_code[@i]
      end
      @i += 1
    end
    @colours = %w[red blue yellow purple green orange black white]
    @i = 0
    puts 'Your computer has made a guess with the following code:'
    print_board
    computer_guessing_memory
    colour_code_matching
    mastermind_winning_condition
  end

  def computer_guessing_memory
    4.times do
      if @guesser_code[@ind] == colour_code[@ind]
        @computer_memory_code[@ind] = @guesser_code[@ind]
      else
        @colour_blacklist[@ind].push(@guesser_code[@ind])
      end
      @ind += 1
    end
    @ind = 0
  end

  # Initializing the game
  def mastermind_game
    player_role_selection
  end
end

mastermind = Game.new
mastermind.mastermind_game
