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
