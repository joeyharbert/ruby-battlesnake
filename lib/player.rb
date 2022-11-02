class Player
  attr_reader :data, :board, :player, :occupieds, :foods, :logger

  DIRECTIONS = ['up', 'down', 'left', 'right']

  def initialize(data, logger)
    @data = data
    @board = data['board']
    @player = data['you']

    @foods = @board['food']
    @occupieds = @board['snakes'].map{|s| s['body']}.flatten
    @logger = logger
  end

  def move
    nearby_food || find_empty
  end

  private

  def find_empty
    candidate = send(direction)
    logger.info("CANDIDATE: #{candidate.inspect}")

    if direction.nil?
      logger.info("DIRECTION NIL!")
      random
    elsif !available?(candidate)
      logger.info("DIRECTION #{direction.inspect} not available!")
      random
    else
      logger.info("AVAILABLE!")
      candidate
    end
  end

  def direction_of(from_coords, to_coords)
    delta_x = to_coords['x'] - from_coords['x']
    delta_y = to_coords['y'] - from_coords['y']

    if delta_x.abs >= delta_y.abs
      # mostly horizontal
      delta_x > 0 ? 'right' : 'left'
    else
      # mostly vertical
      delta_y > 0 ? 'up' : 'down'
    end
  end

  def nearby_food
    DIRECTIONS.shuffle.detect do |d|
      answer = food?(send(d))

      logger.info("FOOD? #{d}, #{send(d).inspect}, #{answer.inspect}")

      answer
    end
  end

  def food?(coords)
    foods.include?(coords)
  end

  def random
    DIRECTIONS.shuffle.detect do |d|
      answer = available?(send(d))

      logger.info("AVAILABLE? #{d}, #{send(d).inspect}, #{answer.inspect}")

      answer
    end || 'down'
  end

  def direction
    return @direction if defined?(@direction)
    @direction = neck ? direction_of(neck, head) : nil
  end

  def left
    head.merge('x' => head['x'] - 1)
  end

  def right
    head.merge('x' => head['x'] + 1)
  end

  def up
    head.merge('y' => head['y'] + 1)
  end

  def down
    head.merge('y' => head['y'] - 1)
  end

  def available?(coords)
    !occupied?(coords) && !wall?(coords)
  end

  def occupied?(coords)
    occupieds.include?(coords)
  end

  def wall?(coords)
    answer = coords['x'] < 0 || coords['y'] < 0 || coords['x'] >= board['width'] || coords['y'] >= board['height']
    logger.info("WALL? #{coords.inspect}, #{board['width'].inspect},#{board['height'].inspect}: #{answer.inspect}")
    answer
  end

  def head
    return @head if defined?(@head)
    @head = player['body'].first
  end

  def neck
    return @neck if defined?(@neck)
    @neck = player['body'][1]
  end
end