# This is a refactoring exercise.
#
# What to do?
#
# I. Simple refactoring
#    1. Look at the code of the class CorrectAnswerBehavior
#    2. Try to see what it does by running `ruby refactoring_example.rb`
#    3. Record characterisation tests by running `ruby refactoring_example.rb --record`
#    4. Make the code beautiful;)
#    5. You are allowed to modify only the code between markers (REFACTORING START/REFACTORING END).
#    6. Test must pass! You can run them with command `ruby refactoring_example.rb --record`
#    7. For suggestions of other exercises based on this code...
#        a) Follow http://twitter.com/programmingwod or
#        b) like https://www.facebook.com/ProgrammingWorkout or
#        c) signup to http://programmingworkout.com
#
# II. Two minute commits.
#    1. Same as Simple Refactoring but you work in two minute iterations.
#       a) Start timer. (2 minutes)
#       b) Refactor.
#       c) Commit if tests pass.
#       d) Revert all uncommitted changes when timer rings. NO EXCEPTIONS!!!
#       e) Repeat
#
# III. Refactor moar!
#   1. You are now allowed to refactor code between markers (REFACTORING START/REFACTORING END 2).
#   2. Tests with fixtures before refactoring need to pass.
#   3. Does it change anything for you? Hint: You can add some code outside CorrectAnswerBehavior class.
#
# Usage:
#  ruby refactoring_example.rb [-h|--help|help]       - shows help screen.
#  ruby refactoring_example.rb [-c|--clean|clean]     - clean recorded results of simulation.
#  ruby refactoring_example.rb [-r|--record|record]   - records 5000 results of simulation.
#  ruby refactoring_example.rb [-t|--test|test]       - tests against 5000 recorded results of simulation.
#  ruby refactoring_example.rb <ANY_NUMBER>           - shows result of simulation initialized with <ANY_NUMBER>.
#  ruby refactoring_example.rb                        - shows result of random simulation.
#
# License: MIT (see at the end of the file)
# This code is based on Trivia Game example used in Legacy Code Retreats
# You can find it at https://github.com/jbrains/trivia

# ------------------------------ REFACTORING START ------------------------------
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
      puts "Answer was corrent!!!!"
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

# ------------------------------ REFACTORING END ------------------------------

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

# ------------------------------ REFACTORING END 2 ------------------------------
require 'fileutils'
module FixtureHandler
  def self.clear_fixtures
    FileUtils.rm_rf(fixtures_dir)
  end

  def self.create_fixture_dir
    FileUtils.mkdir(fixtures_dir)
  end

  def self.write_fixture index, text
    File.open(fixture_path(index), "w") do |file|
      file.write(text)
    end
  end

  def self.fixture_exists? index
    File.exists?(fixture_path(index))
  end

  def self.read_fixture index
    File.read(fixture_path(index))
  end

  def self.fixture_path index
    "#{fixtures_dir}/#{index}.txt"
  end

  def self.fixtures_dir
    "#{File.expand_path(File.dirname(__FILE__))}/fixtures"
  end
end

module StdOutToStringRedirector
  require 'stringio'
  def self.redirect_stdout_to_string
    sio = StringIO.new
    old_stdout, $stdout = $stdout, sio
    yield
    $stdout = old_stdout
    sio.string
  end
end

SIMULATIONS_COUNT = 5000
def run_simulation index = nil
  result = CorrectAnswerBehavior.new(index).was_correctly_answered
  puts "result was #{result}"
end

def capture_simulation_output index
  StdOutToStringRedirector.redirect_stdout_to_string do
    run_simulation(index)
  end
end

def clean_fixtures
  FixtureHandler.clear_fixtures
end

def record_fixtures
  SIMULATIONS_COUNT.times do |index|
    raise "You need to clean recorded simulation results first!" if FixtureHandler.fixture_exists?(index)
  end
  FixtureHandler.create_fixture_dir
  SIMULATIONS_COUNT.times do |index|
    FixtureHandler.write_fixture(index, capture_simulation_output(index))
  end
rescue RuntimeError => e
  puts "ERROR!!!"
  puts e.message
end

require "minitest"
class TestOutput < Minitest::Test
  def test_output
    SIMULATIONS_COUNT.times do |index|
      raise "You need to record simulation results first!" unless FixtureHandler.fixture_exists?(index)
      assert_equal(FixtureHandler.read_fixture(index), capture_simulation_output(index))
    end
    puts "OK."
  rescue RuntimeError => e
    puts "ERROR!!!"
    puts e.message
  end
end

case ARGV[0].to_s.downcase
when "-h", "--help", "help"
  puts "Usage:"
  puts "  ruby #{__FILE__} [-h|--help|help]       - shows help screen."
  puts "  ruby #{__FILE__} [-c|--clean|clean]     - clean recorded results of simulation."
  puts "  ruby #{__FILE__} [-r|--record|record]   - records #{SIMULATIONS_COUNT} results of simulation."
  puts "  ruby #{__FILE__} [-t|--test|test]       - tests against #{SIMULATIONS_COUNT} recorded results of simulation."
  puts "  ruby #{__FILE__} <ANY_NUMBER>           - shows result of simulation initialized with <ANY_NUMBER>."
  puts "  ruby #{__FILE__}                        - shows result of random simulation."
when "-c", "--clean", "clean"
  clean_fixtures
when "-r", "--record", "record"
  record_fixtures
when "-t", "--test", "test"
  Minitest.run
when /\d(.\d+)?/
  run_simulation ARGV[0].to_f
else
  run_simulation
end


# Copyright © 2012 Michal Taszycki
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

