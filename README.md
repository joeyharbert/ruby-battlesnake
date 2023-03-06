# Ruby Version of BattleSnake

Welcome! [Lincoln Ruby Labs](https://www.meetup.com/lincoln-ruby/) is a meetup for ruby developers in Lincoln, Nebraska. We meet on the first Tuesday of every month, and lately we have been playing [Battlesnake](https://battlesnamke.com) - a fun online game where each person codes their own simple player app in the form of an API.

**NOTE:** You're welcome to join our meetup and play even if you choose to use a different language. This repo is provided to help those who wish to get a jump start using Ruby, but it may also be helpful as a template for those wishing to implement a player app in the language of their choice.

Take a look at Battlesnake's [Quickstart Guide](https://docs.battlesnake.com/quickstart) which walks you through "creating a battlesnake in five minutes" using Python, and hosting your app for free on [Repl.it](https://repl.it).

## How to Use This Repo

This repo uses ruby, and provides both the API layer (via [Sinatra](https://sinatrarb.com)) and the Repl.it configuration. To use it, follow these simple steps. Rather than repeat the info from Battlesnake's startup guide, we'll only address the elements specific to this repo here.

1. Fork this repository so you have your own copy in GitHub.
2. For local development, copy `.env.example` to `.env` and make your changes. These are mostly just to customize your snake's appearance, and are optional.
3. Make changes to the `move` method in `lib/player.rb`. This method just needs to return a string: "up", "down", "left", or "right" depending on where you want your snake to move next. How it decides where to move will be your secret sauce!
4. Add, commit, and push your changes back to GitHub.
5. In Repl.it, create your new application instance, and point it to your GitHub repo. If you've already done this, you'll need to click a few buttons to get it to pull in your most recent changes, and restart the app.
6. Launch a new game in Battlesnake using your player, and any others you wish to add!

## What Does My Player App Need to Do?

Your player app needs to respond to HTTP requests from battlesnake.com. Battlesnake will send a JSON payload containing all the details of the current game board, along with details about your player (health, locations occupied by your snake's body, etc). Your app's response should be a JSON payload as well, and it can be this simple:

~~~JSON
{
  "move": "up"
}
~~~

You only need to tell Battlesnake which direction you want your player snake to move next - up, down, left or right. As mentioned above, you only need to modify the `move` method in `lib/player.rb` to return one of the four valid directions. There provided boilerplate code does the work of turning this into a valid JSON response and sending it back to Battlesnake.

The interface is dead simple, but the fun is developing strategies that will outlive your fellow players! Here are some sample strategies just to get you started. These will NOT win you any battles (probably) but will give you an idea of how to build better strategies.

### Move in a Random Direction

This is simple, but you will die if another player or you are occupying the space in this direction!

~~~ruby
def move
  # These are the acceptable directions.
  directions = ["up", "down", "left", "right"]
  
  # Number of directions
  direction_count = directions.size
  
  # Pick a spot on this list at random.
  index = rand(direction_count)
  
  # Return the direction at this spot on the list.
  directions[index]
end
~~~

### Move in a Random AVAILABLE Direction

The player class provides a method `available_directions` which only returns directions to spaces that are empty, or contain happy things like food. This is not fool-proof; each player is asked for their move before any players' moves are made. So two players can decide to move into the same square, causing a collision.

~~~ruby
def move
  # Number of available directions
  direction_count = available_directions.size
  
  # Pick a spot on this list at random.
  index = rand(direction_count)
  
  # Return the direction at this spot on the list.
  available_directions[index]
end
~~~

### Just Rotate in a Clockwise Circle

The `data` JSON object passed to the player class contains everything that Battlesnake sends to you, to help you make your decision. `data["turn"]` is the current turn number. Using the `modulo` operator, you can just cycle through the allowed directions in any order you want. Of course, this ignores the possibilty of running into other players, but you'll last for a little while. You will also eventually go hungry, because enough food is unlikely to spawn in such a small area.

~~~ruby
def move
  # The acceptable directions, in the order we want to use them (clockwise).
  directions = ["up", "right", "down", "left"]
  
  # Number of available directions
  direction_count = directions.size
  
  # The current turn number.
  turn = data["turn"]
  
  # The modulo of the turn number; for four turns, cycles through 0, 1, 2, 3, 0, 1, 2, 3, etc.
  index = turn % direction_count

  # Return the direction at this spot on the list.
  directions[index]
end
~~~

### Building Complex Strategies

Take a look at the provided methods in `lib/player.rb` file. They are useful building blocks, and well commented. Next, you can look into the [Battlesnake Gem Documentation](https://github.com/bellmyer/battlesnake) to learn how to build more useful helpers, since this repo uses that gem.


## Questions?

Feel free to reach out to one of the organizers of the meetup. Reach out early, so you can show up ready to play! You'll have more fun if your setup is already working before you arrive.