require 'sinatra'
require 'http'
require 'yaml'

CONFIG = YAML.load_file('config.yml')

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

class Game
  RULES = {
    'rock' => 'scissors',
    'scissors' => 'paper',
    'paper' => 'rock'
  }

  def initialize(player_hand, opponent_hand)
    @player_hand = player_hand
    @opponent_hand = opponent_hand
  end

  def call
    if !RULES.keys.include?(@player_hand)
      return OpenStruct.new(success?: false, error_message: "Available options: #{Game::RULES.keys.join(', ')}")
    elsif !RULES.keys.include?(@opponent_hand)
      return OpenStruct.new(success?: true, result: 'win')
    end

    result =
      if @player_hand == @opponent_hand
        'draw'
      elsif RULES[@player_hand] == @opponent_hand
        'win'
      else
        'loss'
      end

    OpenStruct.new(success?: true, result: result)
  end
end

class CurbServerThrow
  HOST = CONFIG['host']

  class NetworkError < StandardError; end

  def self.fetch!
    response = client.get("#{HOST}")
    raise NetworkError, response unless response.status.success?

    data = JSON.parse(response)

    data['body']
  rescue NetworkError
    Game::RULES.keys.sample
  end

  private

  def client
    HTTP.timeout(10)
  end
end
