module API
  class TwilioRequest

    attr_accessor :key, :secret, :account_sid, :phone_number

    def initialize
      self.key         = ENV['TWILIO_API_KEY']
      self.secret      = ENV['TWILIO_API_SECRET']
      self.account_sid = ENV['TWILIO_ACCOUNT_SID']
      self.phone_number = ENV['TWILIO_NUMBER_ONE']
      client
    end

    def client
      Twilio::REST::Client.new(key, secret, account_sid)
    end

    def send_text(send_to_number, message)
      client.messages.create(
        to:   send_to_number,
        from: phone_number,
        body: message
      )
    end

    def valid_number?(number_to_validate, validate_by, value)
      result = client.lookups.v1.phone_numbers(number_to_validate).fetch(type: validate_by)
      result.send(validate_by)['type'] === value
      rescue => error
        false
    end
  end
end