require './app'
require 'minitest/autorun'
require 'rack/test'

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_the_draw
    post '/play', choice: 'rock'
    assert_equal 'draw', JSON.parse(last_response.body)['result']
    assert_equal 'rock', JSON.parse(last_response.body)['player_hand']
    assert_equal 'rock', JSON.parse(last_response.body)['opponent_hand']
    assert_equal 200, last_response.status
  end

  def test_invalid_choice
    post '/play', choice: 'kolodec'
    assert_equal "Available options: #{Game::RULES.keys.join(', ')}", JSON.parse(last_response.body)['error']
    assert_equal 422, last_response.status
  end
end
