module Game

  MIN_X_BOARD = 0
  MAX_X_BOARD = 10

  MIN_Y_BOARD = 0
  MAX_Y_BOARD = 10

  HOT = 'HOT HOT HOT!!!'
  WARM = 'WARM!'
  COLD = 'COLD!!!'
  GAME_FINISHED = 'SUCCESS, YOU FINISHED THE GAME!!!!!!!!!!!!!!'
  SUCCESS_AND_FINISH = 'SUCCESS, YOU FINISHED THE GAME WITHOUT ALL THE TREASURES!!!!!!!!!!!!!!'
  SUCCESS_AND_CONTINUE = 'SUCCESS, LETS FIND MORE TREASURES!!!!!!!!!!!!!!'
  GAME_OVER = 'GAME OVER!!!'

  def self.create_game
    DBHelper.create_db_table

    treasure_x = rand(MAX_X_BOARD)
    treasure_y = rand(MAX_Y_BOARD)
    if DBHelper.get_treasures.first
      DBHelper.update_treasure(treasure_x, treasure_y)
    else
      DBHelper.set_treasure(treasure_x, treasure_y)
    end
    DBHelper.reset_attempts
    # TODO reset active game
  end

  def self.check_boundaries(x, y)
    x.between?(MIN_X_BOARD, MAX_X_BOARD) && y.between?(MIN_Y_BOARD, MAX_Y_BOARD)
  end

  def self.send_coord(x, y)
    DBHelper.increment_attempts
    if DBHelper.get_attempts >= 5
      return GAME_OVER
    end
    treasure = get_treasure
    zone_x =  (x - treasure[:x]).abs
    zone_y = (y - treasure[:y]).abs
    get_result(zone_x, zone_y)
  end

  def self.get_treasure
    #TODO which treasure I want to get?
    result = DBHelper.get_treasures
    treasure_x = result.first[:pos_x]
    treasure_y =  result.first[:pos_y]
    {x: treasure_x, y: treasure_y}
  end

  private

  def self.get_result(zone_x, zone_y)
    if zone_x.eql?(0) && zone_y.eql?(0)
      number_treasures = DBHelper.get_treasures.count
      if number_treasures > 1
        continue_game?
      else
        GAME_FINISHED
      end
    elsif zone_x < 2 && zone_y < 2
      HOT
    elsif zone_x < 3 && zone_y < 3
      WARM
    else
      COLD
    end
  end

  def self.continue_game?
    puts 'Do you want to continue? (Y/N)'
    continue = STDIN.gets.chomp
    if continue.eql? 'N'
      # TODO set player status to finish
      SUCCESS_AND_FINISH
    else
      # TODO delete treasure
      SUCCESS_AND_CONTINUE
    end
  end
end