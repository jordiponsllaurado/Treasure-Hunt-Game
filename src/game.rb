require_relative 'board'

module Game

  MAX_ATTEMPTS = 5

  TREASURE_ONE = 1
  TREASURE_TWO = 2

  HOT = 'HOT HOT HOT!!!'
  WARM = 'WARM!'
  COLD = 'COLD!!!'
  GAME_FINISHED = 'SUCCESS, YOU FINISHED THE GAME!!!!!!!!!!!!!!'
  SUCCESS_AND_FINISH = 'SUCCESS, YOU FINISHED THE GAME WITHOUT ALL THE TREASURES!!!!!!!!!!!!!!'
  SUCCESS_AND_CONTINUE = 'SUCCESS, LETS FIND MORE TREASURES!!!!!!!!!!!!!!'
  GAME_OVER = 'GAME OVER!!!'

  def self.create_game
    DBHelper.create_db_table
    create_treasures
    DBHelper.reset_attempts
    # TODO reset active game
  end

  def self.send_coord(x, y)
    # TODO check if the game is active
    DBHelper.increment_attempts
    if DBHelper.get_attempts >= MAX_ATTEMPTS
      return GAME_OVER
    end
    if DBHelper.get_treasure(TREASURE_ONE).first
      result = get_result(TREASURE_ONE, x, y)
      if DBHelper.get_treasure(TREASURE_TWO) && result.eql?(COLD)
        result = get_result(TREASURE_TWO, x, y)
      end
    else
      result = get_result(TREASURE_TWO, x, y)
    end
    result
  end

  def self.get_treasure(treasure)
    result = DBHelper.get_treasure(treasure)
    treasure_x = result.first[:pos_x]
    treasure_y =  result.first[:pos_y]
    {x: treasure_x, y: treasure_y}
  end

  private

  def self.get_result(treasure_number, x, y)
    treasure = get_treasure(treasure_number)
    zone_x =  (x - treasure[:x]).abs
    zone_y = (y - treasure[:y]).abs
    if zone_x.eql?(0) && zone_y.eql?(0)
      number_treasures = DBHelper.get_treasures.count
      if number_treasures > 1
        continue_game?(treasure_number, x, y)
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

  def self.continue_game?(treasure_number, x, y)
    puts 'Do you want to continue? (Y/N)'
    continue = STDIN.gets.chomp
    if continue.eql? 'N'
      # TODO set player status to finish
      SUCCESS_AND_FINISH
    else
      DBHelper.delete_treasure(treasure_number, x, y)
      SUCCESS_AND_CONTINUE
    end
  end

  def self.create_treasures
    treasure_one = Board.random_first_treasure
    treasure_two = Board.random_second_treasure(treasure_one)
    create_treasure(TREASURE_ONE, treasure_one)
    create_treasure(TREASURE_TWO, treasure_two)
  end

  private

  def self.create_treasure(treasure_number, treasure)
    if DBHelper.get_treasure(treasure_number).first
      DBHelper.update_treasure(treasure_number, treasure[:x], treasure[:y])
    else
      DBHelper.set_treasure(treasure_number, treasure[:x], treasure[:y])
    end
  end

end