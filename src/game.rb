module Game

  MIN_X_BOARD = 0
  MAX_X_BOARD = 10

  MIN_Y_BOARD = 0
  MAX_Y_BOARD = 10

  def self.create_game
    DBHelper.create_db_table

    treasure_x = rand(MAX_X_BOARD)
    treasure_y = rand(MAX_Y_BOARD)
    if DBHelper.get_treasure.first
      DBHelper.update_treasure(treasure_x, treasure_y)
    else
      DBHelper.set_treasure(treasure_x, treasure_y)
    end
  end

  def self.check_boundaries(x, y)
    x.between?(MIN_X_BOARD, MAX_X_BOARD) && y.between?(MIN_Y_BOARD, MAX_Y_BOARD)
  end

  def self.send_coord(x, y)
    result = DBHelper.get_treasure
    treasure_x = result.first[:pos_x]
    treasure_y =  result.first[:pos_y]
    zone_x =  (x - treasure_x).abs
    zone_y = (y - treasure_y).abs
    get_result(zone_x, zone_y)
  end

  def self.get_treasure
    result = DBHelper.get_treasure
    treasure_x = result.first[:pos_x]
    treasure_y =  result.first[:pos_y]
    [treasure_x, treasure_y]
  end

  private

  def self.get_result(zone_x, zone_y)
    if zone_x.eql?(0) && zone_y.eql?(0)
      'SUCESS!!!!!!!!!!!!!!'
    elsif zone_x < 2 && zone_y < 2
      'HOT HOT HOT!!!'
    elsif zone_x < 3 && zone_y < 3
      'WARM!'
    else
      'COLD!!!'
    end
  end
end