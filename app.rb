require 'yaml'

CONFIG = YAML.load_file('config.yml')

require 'http'
require 'sinatra'
require './lib/curb_server_throw'
require './lib/game'

post '/play' do
  content_type 'application/json'

  player_hand = JSON.parse(request.body.read)['choice']
  opponent_hand = CurbServerThrow.fetch!
  game = Game.new(player_hand, opponent_hand).call

  if game.success?
    status 200
    { player_hand: player_hand, opponent_hand: opponent_hand, result: game.result }.to_json
  else
    status 422
    { error: game.error_message }.to_json
  end
end
