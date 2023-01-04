require 'battlesnake'

class Player
  attr_reader :data, :board, :player, :logger

  DIRECTIONS = ['up', 'down', 'left', 'right']

  def initialize(data, logger)
    @data = data
    @board = Battlesnake::Board.new(data['board'])
    @player = Battlesnake::Snake.new(data['you'])

    @logger = logger
  end

  def move
    nearby_food || find_empty
  end

  private

  def available_directions
    return @available_directions if defined?(@available_directions)
    @available_directions = board.available_directions(player.head).shuffle
  end

  def nearby_food
    available_directions.detect{ |location| board.food?(location) }
  end

  def find_empty
    available_directions.first
  end

  # def nearest_available_wall
  #   DIRECTIONS.select{ |d| available?(send(d)) }.min_by do |d|
  #     distance_to_wall(d)
  #   end
  # end
end