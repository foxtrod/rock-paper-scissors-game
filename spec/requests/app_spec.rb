require 'spec_helper'
require './app'

set :environment, :test

describe 'App', type: :request do
  context 'when opponent throws a rock' do
    before do
      expect(CurbServerThrow).to receive(:fetch!).and_return('rock')
    end

    context 'when draw conditions are met' do
      it 'returns a draw' do
        post 'play', { choice: 'rock' }.to_json
        expect(JSON.parse(last_response.body)).to eq(success_response('rock', 'rock', 'draw'))
        expect(last_response.status).to eq(200)
      end
    end

    context 'when win conditions are met' do
      it 'returns a win' do
        post 'play', { choice: 'paper' }.to_json
        expect(JSON.parse(last_response.body)).to eq(success_response('paper', 'rock', 'win'))
        expect(last_response.status).to eq(200)
      end
    end

    context 'when loss conditions are met' do
      it 'returns a loss' do
        post 'play', { choice: 'scissors' }.to_json
        expect(JSON.parse(last_response.body)).to eq(success_response('scissors', 'rock', 'loss'))
        expect(last_response.status).to eq(200)
      end
    end

    context 'when player missed the throw' do
      it 'return an error' do
        post 'play', { choice: '' }.to_json
        expect(JSON.parse(last_response.body)).to eq({'error' => 'Available options: rock, scissors, paper'})
        expect(last_response.status).to eq(422)
      end
    end
  end

  context 'when opponent pulls up cheat options' do
    it 'returns a win' do
      expect(CurbServerThrow).to receive(:fetch!).and_return('kolodec')
      post 'play', { choice: 'scissors' }.to_json
      expect(JSON.parse(last_response.body)).to eq(success_response('scissors', 'kolodec', 'win'))
      expect(last_response.status).to eq(200)
    end
  end
end

def success_response(player, opponent, result)
  {
    'player_hand' => player,
    'opponent_hand' => opponent,
    'result' => result
  }
end
