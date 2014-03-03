require_relative 'refactoring_example'

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
