require 'thor'
require 'sequel'
require 'sqlite3'

require_relative 'db_helper'
require_relative 'game'

class MyCLI < Thor

  desc 'play', 'Creates a new map'
  def play
    Game.create_game
  end

  desc 'position X Y', 'say if the treasure is there'
  def position(x, y)
    if Game.check_boundaries(x.to_i, y.to_i)
      puts Game.send_coord(x.to_i, y.to_i)
    else
      puts 'Coordinates out of the map!'
    end
  end

  desc 'solution', 'it says the solution'
  def solution
    treasure = Game.get_treasure
    puts treasure[0].to_s + ' ' + treasure[1].to_s
  end
end

MyCLI.start(ARGV)