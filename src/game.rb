module Game

  MIN_X_BOARD = 0
  MAX_X_BOARD = 10

  MIN_Y_BOARD = 0
  MAX_Y_BOARD = 10

  MAX_ATTEMPTS = 5

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

  def self.check_boundaries(x, y)
    x.between?(MIN_X_BOARD, MAX_X_BOARD) && y.between?(MIN_Y_BOARD, MAX_Y_BOARD)
  end

  def self.send_coord(x, y)
    # TODO check if the game is active
    DBHelper.increment_attempts
    if DBHelper.get_attempts >= MAX_ATTEMPTS
      return GAME_OVER
    end
    if DBHelper.get_treasure(1).first
      result = get_result(1, x, y)
      if DBHelper.get_treasure(2) && result.eql?(COLD)
        result = get_result(2, x, y)
      end
    else
      result = get_result(2, x, y)
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
    treasure_one_x = rand(MAX_X_BOARD)
    treasure_one_y = rand(MAX_Y_BOARD)
    matrix = Array.new(10){ Array.new(10) }
    matrix.each_with_index do |rows, index_x|
      rows.each_with_index { |_, index_y| matrix[index_x][index_y] = {x: index_x, y: index_y} }
    end
    from_x = treasure_one_x - 2
    from_x = 0 if from_x < 0
    to_x = treasure_one_x + 2
    to_x = 9 if to_x > 9

    from_y = treasure_one_y - 2
    from_y = 0 if from_y < 0
    to_y = treasure_one_y + 2
    to_y = 9 if to_x > 9
    for x  in from_x..to_x
      for y in from_y..to_y
        matrix[x][y] = nil
      end
    end
    matrix
    matrix.each do |row|
      row.compact!
    end
    matrix
    random_x = rand(matrix.length)
    random_y = rand(matrix[random_x].length)
    treasure_two_x = matrix[random_x][random_y][:x]
    treasure_two_y = matrix[random_x][random_y][:y]
    if DBHelper.get_treasure(1).first
      DBHelper.update_treasure(1, treasure_one_x, treasure_one_y)
    else
      DBHelper.set_treasure(1, treasure_one_x, treasure_one_y)
    end
    if DBHelper.get_treasure(2).first
      DBHelper.update_treasure(2, treasure_two_x, treasure_two_y)
    else
      DBHelper.set_treasure(2, treasure_two_x, treasure_two_y)
    end
  end
end