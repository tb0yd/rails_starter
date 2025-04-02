class TwilioRequest < ApplicationRecord
  belongs_to :account
  belongs_to :user, optional: true
  
  has_many :twilio_responses
  
  validates :endpoint, presence: true
  validates :api_version, presence: true
  validates :request_body, presence: true
  
  enum endpoint: { 
    send_sms: :send_sms, 
    send_voice: :send_voice, 
    verify: :verify 
  }
end

