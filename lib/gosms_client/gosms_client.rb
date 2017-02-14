module GosmsClient
  class Client
    BASE_URL = 'https://app.gosms.cz'.freeze
    OAUTH = BASE_URL + '/oauth/v2'
    MSG = BASE_URL + '/api/v1/messages'
    TEST = BASE_URL + '/api/v1/messages/test'
    INFO = BASE_URL + '/api/v1/'

    def initialize(id, secret, channel)
      @client_id = id
      @client_secret = secret
      @channel_id = channel
    end

    # GET /
    def get_credit
      response = token.get(INFO)
      response.parsed['currentCredit']
    end

    # POST /messages
    def send(text, recipients, testMsg = false)
      return if invalid_params? text, recipients
      json = prepare_msg_json text, recipients
      begin
        response = token.post(testMsg ? TEST : MSG, body: json, headers: { 'Content-Type' => 'application/json' })
        details = MessageDetails.new(response.parsed)
      rescue OAuth2::Error => e
        raise Error.new(:test_sms, e.response.parsed)
      end
    end

    # POST /messages/test
    def test_send(text, recipients)
      send(text,recipients, true)
    end

    private

    def invalid_params?(text,recipients)
      return text.nil? || recipients.nil? || is_text_long?(text)
    end

    def prepare_msg_json text, recipients
      {
        message: text,
        recipients: recipients,
        channel: @channel_id
      }.to_json
    end

    def is_text_long?(text)
      text.length > 160
    end

    def token
      if @token.nil? || @token.expired?
        begin
          @token = oauth_client.client_credentials.get_token
        rescue OAuth2::Error => e
          raise Error.new(:bad_token, e.response.parsed)
        end
      end
      @token
    end

    def oauth_client
      @oauth_client ||= OAuth2::Client.new(
        @client_id,
        @client_secret,
        site: OAUTH,
        token_url: 'token',
        raise_errors: true
      )
    end
  end
end
