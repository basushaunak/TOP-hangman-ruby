require 'json'

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
  attr_reader :moves_left, :guess, :save_game, :saved_games
  def initialize(secret_word, guess="",moves_left=10)
    @secret_word = secret_word
    @moves_left = 10
    @guess = guess.rjust(@secret_word.length,"-")
    @score = 0
    @won = false
    @lost = false
    @save_game = false
    @guess_list = []
    @game_start = Time.now()
    @saved_games = []
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
      if @guess.downcase.include?(chr) || @guess_list.include?(chr)
        puts "You have already entered that letter!"
        next
      end
      @guess_list.push(chr)
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
      if !@save_game
        draw_hangman()
        @lost = true
        @score = @score - 1
      end
    end
  end

  public

  def new_game(secret_word, guess="",moves_left=10)
    @secret_word = secret_word
    @moves_left = 10
    @guess = guess.rjust(@secret_word.length,"-")
    @won = false
    @lost = false
    @guess_list = []
    @game_start = Time.now()
  end

  public

  def save(file_name="game.sav")
    if @saved_games.empty?
      begin
        file = File.open(file_name,"a+")
        save_game = false
      rescue
        return -1
      end
      game_data = JSON.dump({"game_start" => @game_start, "secret_word" => @secret_word, "guess" => @guess, "moves_left" => @moves_left, "guess_list" => @guess_list, "score" => @score})
      file.puts game_data
      return 0
    else
      begin
        file = File.open(file_name,"w")
        save_game = false
      rescue
        return -1
      end
      @saved_games.each do |row|
        if row["game_start"] == @game_start
          row["game_start"] = @game_start
          row["secret_word"] = @secret_word
          row["guess"] = @guess
          row["moves_left"] = @moves_left
          row["guess_list"] = @guess_list
          row["score"] = @score
        end
        file.puts JSON.dump(row)
      end
      return 0
    end

  end

  public

  def load(file_name="game.sav")
    @saved_games = []
    begin
      temp = File.readlines(file_name)
      temp.each do |row|
        @saved_games.push(JSON.load(row))
      end
      puts "List of saved games in #{file_name}:"
      @saved_games.each_with_index do |row, idx|
        puts "#{idx+1}: #{row["game_start"][0..-7]}"
        if (idx+1)%20 == 0
          p "Press enter for next screen "
          temp = gets()
        end
      end
      #Asking twice to enter the number. Why?
      while true
        p "Please enter a number from left column & press 'Enter' to load that game."
        begin
          input = gets.chomp.to_i
          idx = input - 1
        rescue
          puts "You must enter a valid number from the list shared above"
          idx = -1
          next
        end
        if idx < 0 || idx >= @saved_games.length
          puts "You must enter a valid number from the list shared above"
          next
        end
        break
      end
      return load_game_data(idx)
    rescue
#      puts "Unable to open #{file_name} / file is not in proper format"
      return -1
    end
  end

  private

  def load_game_data(idx)
    begin
      @game_start = @saved_games[idx]["game_start"]
      @secret_word = @saved_games[idx]["secret_word"]
      @guess = @saved_games[idx]["guess"]
      @moves_left = @saved_games[idx]["moves_left"]
      @guess_list = @saved_games[idx]["guess_list"]
      @score = @saved_games[idx]["score"]
      return 0
    rescue
      return -1
    end
  end
end

words = File.readlines("5desk.txt")
words = trimwords(words,5,10)
word = words[rand(words.length-1)].strip
game = Hangman.new(word)

puts "Welcome to the classic Hangman Game!"
p "Would you like to open a saved game (Type y/Y and press 'Enter' to load)? "
ans = gets.chomp.downcase
if ans == 'y'
  # if you want you can pass a name of file to game.load method, otherwise it will use default file name - game.sav
  if game.load() != 0
    puts "Sorry! Unable to load game. Starting a new game"
  end
end
game.play
if game.save_game
  # if you want you can input a file name instead of using the default file name.
  file_name = "game.sav"
  if game.save(file_name) == 0
    puts "Game saved successfuly (#{file_name})"
  else
    puts "Game save failed! #{file_name} or folder is read-only?"
  end
end


