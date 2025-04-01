class TwilioResponse < ApplicationRecord
  belongs_to :twilio_request
  
  validates :response_body, presence: true
  validates :http_status, presence: true
  
  # Delegate associations to request
  delegate :account, :user, to: :twilio_request
  
  # Extract important data from response
  before_save :extract_data_from_response
  
  private
  
  def extract_data_from_response
    return unless response_body.present?
    
    parsed_body = JSON.parse(response_body)
    
    # Extract important fields based on the endpoint
    case twilio_request.endpoint
    when 'sms'
      self.message_sid = parsed_body['sid']
      self.status = parsed_body['status']
    when 'voc'
      self.call_sid = parsed_body['sid']
      self.status = parsed_body['status']
    when 'ver'
      self.verification_sid = parsed_body['sid']
      self.status = parsed_body['status']
    end
  rescue JSON::ParserError
    # Handle non-JSON responses
    self.status = 'error'
  end
end

