class Player
  attr_reader :name, :purses
  attr_writer :purses
  def initialize(name, purses)
    @name = name
    @purses = purses
  end

  def reward!
    @purses += 1
  end
end

class CorrectAnswerBehavior
  def initialize(seed = nil)
    srand(seed) if seed
    @players = %w[Alice Bob Cecil].map {|name| Player.new(name, (rand(3) + 5)) }
    @in_penalty_box = @players.map { rand(2) == 0 }
    @current_player_index = rand(@players.count)
    @is_getting_out_of_penalty_box = @in_penalty_box[@current_player_index] && rand(2) == 0
  end

  def was_correctly_answered
    if @in_penalty_box[@current_player_index]
      if @is_getting_out_of_penalty_box
        puts "#{current_player.name} got out of penalty box"
        puts 'Answer was correct!!!!'
        current_player.reward!
        puts "#{current_player.name} now has #{current_player.purses} Gold Coins."
        winner = did_player_win()
        change_current_player!
        puts "Player is now #{current_player.name}"
        winner
      else
        puts "#{current_player.name} stays in penalty box"
        change_current_player!
        puts "Player is now #{current_player.name}"
        true
      end
    else
      puts "Answer was correct!!!!"
      current_player.reward!
      puts "#{current_player.name} now has #{current_player.purses} Gold Coins."
      winner = did_player_win
      change_current_player!
      puts "Player is now #{current_player.name}"
      return winner
    end
  end

  def current_player
    @players[@current_player_index]
  end

  def change_current_player!
    @current_player_index += 1
    @current_player_index = 0 if @current_player_index == @players.length
  end

  private

  def did_player_win
    !(current_player.purses == 6)
  end
end
