class CurbServerThrow
  HOST = CONFIG['host']

  class NetworkError < StandardError; end

  class << self
    def fetch!
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
end
