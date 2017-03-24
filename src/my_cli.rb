require 'thor'
require 'sequel'
require 'sqlite3'

require_relative 'db_helper'

class MyCLI < Thor

  desc 'play', 'Creates a new map'
  def play
    DBHelper.create_db_table

    treasure_x = rand(10)
    treasure_y = rand(10)
    if DBHelper.get_treasure.first
      DBHelper.update_treause(treasure_x, treasure_y)
    else
      DBHelper.set_treasure(treasure_x, treasure_y)
    end
  end

  desc 'position X Y', 'say if the treasure is there'
  def position(x, y)
    if !x.to_i.between?(0, 10) || !y.to_i.between?(0, 10)
      puts 'Coordinates out of the map!'
    else
      result = DBHelper.get_treasure
      treasure_x = result.first[:pos_x]
      treasure_y =  result.first[:pos_y]
      zone_x =  (x.to_i - treasure_x).abs
      zone_y = (y.to_i - treasure_y).abs
      print_results(zone_x, zone_y)
    end
  end

  desc 'solution', 'it says the solution'
  def solution
    result = DBHelper.get_treasure
    treasure_x = result.first[:pos_x]
    treasure_y =  result.first[:pos_y]
    puts treasure_x.to_s + ' ' + treasure_y.to_s
  end

  private

  def print_results(zone_x, zone_y)
    if zone_x.eql?(0) && zone_y.eql?(0)
      puts 'SUCESS!!!!!!!!!!!!!!'
    elsif zone_x < 2 && zone_y < 2
      puts 'HOT HOT HOT!!!'
    elsif zone_x < 3 && zone_y < 3
      puts 'WARM!'
    else
      puts 'COLD!!!'
    end
  end
end

MyCLI.start(ARGV)