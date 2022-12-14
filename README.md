# rock-paper-scissors-game
Application that allows a user to play rock-paper-scissors against curbrockpaperscissors

- Install dependencies

`bundle install`

- Run a server

`bundle exec puma config.ru`

- Run specs

`rspec`

- API usage

`curl -H "Content-Type: application/json" -X POST -d '{"choice": "rock"}' 'localhost:9292/play'`

Rules

# Rock beats scissors
- Scissors beats paper
- Paper beats rock
- Identical throws tie (rock == rock, etc.)
