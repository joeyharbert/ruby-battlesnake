# Ruby Version of BattleSnake

Welcome! [Lincoln Ruby Labs](https://www.meetup.com/lincoln-ruby/) is a meetup for ruby developers in Lincoln, Nebraska. We meet on the first Tuesday of every month, and lately we have been playing [Battlesnake](https://battlesnamke.com) - a fun online game where each person codes their own simple player app in the form of an API.

**NOTE:** You're welcome to join our meetup and play even if you choose to use a different language. This repo is provided to help those who wish to get a jump start using Ruby, but it may also be helpful as a template for those wishing to implement a player app in the language of their choice.

Take a look at Battlesnake's [Quickstart Guide](https://docs.battlesnake.com/quickstart) which walks you through "creating a battlesnake in five minutes" using Python, and hosting your app for free on [Repl.it](https://repl.it).

## What Does My Player App Need to Do?

Your player app needs to respond to HTTP requests from battlesnake.com. Battlesnake will send a JSON payload containing all the details of the current game board, along with details about your player (health, locations occupied by your snake's body, etc). Your app's response should be a JSON payload as well, and it can be this simple:

~~~JSON
{
  "move": "up"
}
~~~

You only need to tell Battlesnake which direction you want your player snake to move next - up, down, left or right. The interface is dead simple, but the fun is developing strategies that will outlive your fellow players!

### How to Use This Repo

This repo uses ruby, and provides both the API layer (via [Sinatra](https://sinatrarb.com)) and the Repl.it configuration. To use it, follow these simple steps. Rather than repeat the info from Battlesnake's startup guide, we'll only address the elements specific to this repo here.

1. Fork this repository so you have your own copy in GitHub.
2. For local development, copy `.env.example` to `.env` and make your changes. These are mostly just to customize your snake's appearance, and are optional.
3. Make changes to the `move` method in `lib/player.rb`. This method just needs to return a string: "up", "down", "left", or "right" depending on where you want your snake to move next. How it decides where to move will be your secret sauce!
4. Add, commit, and push your changes back to GitHub.
5. In Repl.it, create your new application instance, and point it to your GitHub repo. If you've already done this, you'll need to click a few buttons to get it to pull in your most recent changes, and restart the app.
6. Launch a new game in Battlesnake using your player, and any others you wish to add!

### Questions?

Feel free to reach out to one of the organizers of the meetup. Reach out early, so you can show up ready to play! You'll have more fun if your setup is already working before you arrive.