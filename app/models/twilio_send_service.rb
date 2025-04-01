class TwilioSendService
  include HTTParty
  include Memoist
  
  base_uri 'https://api.twilio.com/2010-04-01'
  
  attr_reader :data, :response, :request
  
  def initialize(response_or_data)
    if response_or_data.is_a?(TwilioResponse)
      @response = response_or_data
      @data = JSON.parse(response.response_body)
      @request = response.twilio_request
    else
      @data = response_or_data
    end
  end
  
  def self.send_sms(account, to:, body:, from: nil, user: nil)
    # Create request record
    request = TwilioRequest.create!(
      account: account,
      user: user,
      endpoint: 'send_sms',
      api_version: '2010-04-01',
      request_body: {
        To: to,
        Body: body,
        From: from || account.twilio_phone_number
      }.to_json
    )
    
    # Make API call
    auth = { username: ENV['TWILIO_ACCOUNT_SID'], password: ENV['TWILIO_AUTH_TOKEN'] }
    http_response = post(
      "/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/Messages.json",
      body: {
        To: to,
        Body: body,
        From: from || account.twilio_phone_number
      },
      basic_auth: auth
    )
    
    # Create response record
    response = TwilioResponse.create!(
      twilio_request: request,
      http_status: http_response.code,
      response_body: http_response.body
    )
    
    # Return service instance
    new(response)
  end
  
  # Helper methods to extract data
  def message_sid
    data.dig('sid')
  end
  memoize :message_sid
  
  def status
    data.dig('status')
  end
  memoize :status
  
  def error_code
    data.dig('error_code')
  end
  memoize :error_code
  
  def error_message
    data.dig('error_message')
  end
  memoize :error_message
  
  def successful?
    !error_code.present?
  end
  memoize :successful?
end

