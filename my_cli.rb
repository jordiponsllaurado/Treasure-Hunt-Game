require 'thor'
require 'sequel'
require 'sqlite3'

class MyCLI < Thor

  DB = Sequel.sqlite('treasure.db')

  desc 'play', 'Creates a new map'
  def play
    treasure_x = rand(10)
    treasure_y = rand(10)

    unless DB.table_exists? :map
      DB.create_table(:map) do
        primary_key :id
        String :name
        Integer :pos_x
        Integer :pos_y
      end
    end

    ds = DB[:map]
    if ds.where(:name => 'treasure').first
      ds.where(:name => 'treasure').update(:pos_x => treasure_x, :pos_y => treasure_y)
    else
      ds.insert(:name => 'treasure', :pos_x => treasure_x, :pos_y => treasure_y)
    end
  end

  desc 'position X Y', 'say if the treasure is there'
  def position(x, y)
    if !x.to_i.between?(0, 10) || !y.to_i.between?(0, 10)
      puts 'Coordinates out of the map!'
    else
      ds = DB[:map]
      result = ds.where(:name => 'treasure')
      treasure_x = result.first[:pos_x]
      treasure_y =  result.first[:pos_y]
      zone_x =  (x.to_i - treasure_x).abs
      zone_y = (y.to_i - treasure_y).abs
      print_results(zone_x, zone_y)
    end
  end

  desc 'solution', 'it says the solution'
  def solution
    ds = DB[:map]
    result = ds.where(:name => 'treasure')
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