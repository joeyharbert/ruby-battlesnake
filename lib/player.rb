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
    nearby_food || nearest_available_wall || find_empty
  end

  private

  def find_empty
    candidate = send(direction)

    direction.nil? || !available?(candidate) ? random : candidate
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
      food?(send(d))
    end
  end

  def nearest_available_wall
    DIRECTIONS.select{ |d| available?(send(d)) }.min_by do |d|
      distance_to_wall(d)
    end
  end

  def distance_to_wall(d)
    case d
    when 'up'
      height - 1 - head['y']
    when 'down'
      head['y']
    when 'right'
      width - 1 - head['x']
    when 'left'
      head['x']
    end
  end

  def food?(coords)
    foods.include?(coords)
  end

  def random
    DIRECTIONS.shuffle.detect{ |d| available?(send(d)) } || 'down'
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
    coords['x'] < 0 || coords['y'] < 0 || coords['x'] >= width || coords['y'] >= height
  end

  def head
    return @head if defined?(@head)
    @head = player['body'].first
  end

  def neck
    return @neck if defined?(@neck)
    @neck = player['body'][1]
  end

  def height
    return @height if defined?(@height)
    @height = board['height']
  end

  def width
    return @width if defined?(@width)
    @width = board['width']
  end
end