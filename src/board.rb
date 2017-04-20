module Board

  MIN_BOARD = 0
  MAX_BOARD = 10

  TREASURES_DISTANCE = 2

  def self.check_boundaries(x, y)
    x.between?(MIN_BOARD, MAX_BOARD) && y.between?(MIN_BOARD, MAX_BOARD)
  end

  def self.random_first_treasure
    {x: rand(MAX_BOARD), y: rand(MAX_BOARD)}
  end

  def self.random_second_treasure(treasure_one)
    matrix = Board.possible_treasure_positions(treasure_one)
    random_x = rand(matrix.length)
    random_y = rand(matrix[random_x].length)
    treasure_two_x = matrix[random_x][random_y][:x]
    treasure_two_y = matrix[random_x][random_y][:y]
    {x: treasure_two_x, y: treasure_two_y}
  end

  private

  def self.board_positions
    matrix = Array.new(MAX_BOARD){ Array.new(MAX_BOARD) }
    matrix.each_with_index do |rows, index_x|
      rows.each_with_index { |_, index_y| matrix[index_x][index_y] = {x: index_x, y: index_y} }
    end
    matrix
  end

  def self.get_limits(direction)
    from = direction - TREASURES_DISTANCE
    from = MIN_BOARD if from < MIN_BOARD
    to = direction + TREASURES_DISTANCE
    to = MAX_BOARD - 1 if to >= MAX_BOARD
    {from: from, to: to}
  end

  def self.possible_treasure_positions(treasure_one)
    matrix = board_positions

    x_limits = get_limits(treasure_one[:x])
    y_limits = get_limits(treasure_one[:y])

    (x_limits[:from]..x_limits[:to]).each do |x|
      (y_limits[:from]..y_limits[:to]).each do |y|
        matrix[x][y] = nil
      end
    end
    matrix.each { |row| row.compact! }
  end
end