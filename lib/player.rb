require 'battlesnake'

class Player
  attr_reader :data, :board, :player, :logger

  # Pathfinding gets exponentially slower the longer the distance. Battlesnake
  # will only wait 500ms for your response.
  MAX_PATH_DISTANCE = 6

  def initialize(data, logger)
    @data = data
    @board = Battlesnake::Board.new(data['board'])
    @player = Battlesnake::Snake.new(data['you'])

    @logger = logger
  end

  def play
    {move: move}
  end

  ##
  # This method needs to return your move - one of "up", "down", "left", or "right".
  # You can use the helper methods below, build your own, or explore the
  # battlesnake gem to see what else you can use.
  def move
    "up"
  end

  private

  # Returns a random direction where the next cell is empty.
  def adjacent_empty
    random_directions.first
  end

  # Returns the direction that appears to have the most open space available.
  # Later in the game when snakes are bigger, this is more important to avoid
  # choosing a direction that forces a dead end.
  def most_empty
    fills = board.flood_fills(player.head, max: 10)
    fills.max_by{ |direction, spaces| spaces.size }.first
  end

  # Returns the direction occupied by the given snake's tail end piece, if it
  # is immediately adjacent to our snake's head. This can be useful for "chasing
  # your own tail", which is a safe way to know that the space will be available
  # on the next turn, and can theoretically be followed indefinitely.
  def adjacent_tail(snake)
    return nil if snake.body.size < 4
    tail = snake.body.last

    locations = directions_to_locations(player.head, Battlesnake::Location::DIRECTIONS)

    location = locations.detect do |location|
      location.as_json == tail.as_json
    end

    return nil if location.nil?
    direction_to([snake.head, location])
  end

  # Returns the direction of food, if it is immediately adjacent to our snake's head.
  def adjacent_food
    return @adjacent_food if defined?(@adjacent_food)
    @adjacent_food = direction_to(shortest_path_to(board.food, max_distance: 1))
  end

  # Returns the direction we should start travelling to get closer to the nearest food.
  def nearest_food
    direction_to(shortest_path_to(board.food))
  end

  ###
  # Methods below ere are helpers for the finder methods above.
  ###

  # Returns the directions we could go that are currently available (empty).
  # Of course, this is NOT a guarantee, because each round every snake is going to
  # move at the exact same time.
  def available_directions
    return @available_directions if defined?(@available_directions)
    @available_directions = board.available_directions(player.head)
  end

  # Returns the list of available directions in random order.
  def random_directions
    available_directions.shuffle
  end

  # Returns the shortest path (list of directions) to any of the given locations.
  # This is time-consuming, so to speed things up we can limit how far away we look.
  def shortest_path_to(locations, max_distance: MAX_PATH_DISTANCE)
    Array(locations).map do |location|
      board.find_path(player.head, location, max_distance: max_distance)
    end.compact.min_by(&:size)
  end

  def direction_to(path)
    return nil if path.nil?
    path[0].direction(path[1])
  end

  def direction_to_location(location, direction)
    location.move(direction)
  end

  def directions_to_locations(location, directions)
    directions.map{ |d| direction_to_location(location, d) }
  end
end
