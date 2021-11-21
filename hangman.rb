def trimwords(incoming_words,minlen,maxlen)
  outgoing_words = []
  incoming_words.each do |word|
    if word.length >= minlen && word.length <= maxlen
      outgoing_words.push(word)
    end
  end
  return outgoing_words
end

class Hangman
  attr_reader :moves_left, :guess
  def initialize(secret_word, guess="",moves_left=10)
    @secret_word = secret_word
    @moves_left = 10
    @guess = guess.rjust(@secret_word.length,"-")
    @score = 0
    @won = false
    @lost = false
    @save_game = false
    @guss_list = []
    @game_start = Time.now()
  end

  private 

  def draw_hangman ()
    Gem.win_platform? ? (system "cls") : (system "clear")
    case moves_left
    when 0
      puts "    ________"
      puts "    |/      |"
      puts "    |      (_)"
      puts "    |      /|\\"
      puts "    |       |"
      puts "    |      / \\"
      puts "    | You were HANGED"
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 1
      puts "    ________"
      puts "    |/      |"
      puts "    |      (_)"
      puts "    |      /|\\"
      puts "    |       "
      puts "    |      "
      puts "    |"
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 2
      puts "    ________"
      puts "    |/      |"
      puts "    |      (_)"
      puts "    |      "
      puts "    |       "
      puts "    |      "
      puts "    |"
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 3
      puts "    ________"
      puts "    |/      "
      puts "    |      "
      puts "    |      "
      puts "    |       "
      puts "    |      "
      puts "    |"
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 4
      puts "    "
      puts "    |      "
      puts "    |      "
      puts "    |      "
      puts "    |       "
      puts "    |      "
      puts "    |"
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 5
      puts "    "
      puts "          "
      puts "    |      "
      puts "    |      "
      puts "    |       "
      puts "    |      "
      puts "    |"
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 6
      puts "    "
      puts "          "
      puts "          "
      puts "    |      "
      puts "    |       "
      puts "    |      "
      puts "    |"
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 7
      puts "    "
      puts "          "
      puts "          "
      puts "          "
      puts "           "
      puts "    |      "
      puts "    |"
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 8
      puts "    "
      puts "          "
      puts "          "
      puts "          "
      puts "           "
      puts "          "
      puts "    "
      puts "____|___"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    when 9
      puts "    "
      puts "          "
      puts "          "
      puts "          "
      puts "           "
      puts "          "
      puts "    "
      puts "____"
      puts "Word guessed: #{@guess}"
      puts "Moves left: #{@moves_left}"
    else
      puts "Word guessed: #{@guess}"
      puts "Make a guess (Moves Left: #{@moves_left})"
    end
  end

  public

  def play
    puts "*****Playing*****"
    while @moves_left > 0
      print "Enter a letter and press 'Enter' key: "
      chr = gets.chomp.downcase
      if chr == "save"
        @save_game = true
        break
      end
      if chr.length > 1
        chr = chr[0]
        puts "You have entered more than one letter! Using the first letter."
      end
      if !(chr >= 'a' && chr <= 'z')
        puts "You must enter a letter (a-z / A-Z)."
        next
      end
      if @guess.downcase.include?(chr) || @guss_list.include?(chr)
        puts "You have already entered that letter!"
        next
      end
      @guss_list.push(chr)
      if !@secret_word.downcase.include?(chr)
        @moves_left = @moves_left - 1
        draw_hangman()
        next
      end
      for i in 0..@secret_word.length-1 do
        if @secret_word[i].downcase == chr
          @guess[i] = @secret_word[i]
        end
      end
      draw_hangman()
      if @guess.include?("-") == false
        puts "Congratulations! You won!!!"
        @won = true
        @lost = false
        @score = @score + 1
        break
      end
    end
    if !@won
      draw_hangman()
      @lost = true
      @score = @score - 1
    end
  end

  public

  def new_game(secret_word, guess="",moves_left=10)
    @secret_word = secret_word
    @moves_left = 10
    @guess = guess.rjust(@secret_word.length,"-")
    @won = false
    @lost = false
    @guss_list = []
    @game_start = Time.now()
  end
end

words = File.readlines("5desk.txt")
words = trimwords(words,5,10)
word = words[rand(words.length-1)].strip
puts "Selected word: #{word}"
game = Hangman.new(word)
game.play

