class Player
  DIRECTIONS = ['up', 'down', 'left', 'right']

  class << self
    def move(data)
      board = data['board']
      you = data['you']

      DIRECTIONS[rand(DIRECTIONS.size).to_i]
    end
  end
end