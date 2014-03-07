class CorrectAnswerBehavior

  def was_correctly_answered
    if @in_penalty_box[@current_player]
      if @is_getting_out_of_penalty_box
        puts "#{@players[@current_player]} got out of penalty box"
        puts 'Answer was correct!!!!'
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."
        winner = did_player_win()
        @current_player += 1
        @current_player = 0 if @current_player == @players.length
        puts "Player is now #{@players[@current_player]}"
        winner
      else
        puts "#{@players[@current_player]} stays in penalty box"
        @current_player += 1
        @current_player = 0 if @current_player == @players.length
        puts "Player is now #{@players[@current_player]}"
        true
      end
    else
      puts "Answer was correct!!!!"
      @purses[@current_player] += 1
      puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."
      winner = did_player_win
      @current_player += 1
      @current_player = 0 if @current_player == @players.length
      puts "Player is now #{@players[@current_player]}"
      return winner
    end
  end
private
  def did_player_win
    !(@purses[@current_player] == 6)
  end

public
  def initialize seed = nil
    srand(seed) if seed
    @players = %w[Alice Bob Cecil]
    @purses = @players.map { rand(3) + 5 }
    @in_penalty_box = @players.map { rand(2) == 0 }
    @current_player = rand(@players.count)
    @is_getting_out_of_penalty_box = @in_penalty_box[@current_player] && rand(2) == 0
  end
end
