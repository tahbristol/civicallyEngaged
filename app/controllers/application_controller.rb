require './config/environment'
require 'sinatra/flash'
require 'net/http'
class ApplicationController < Sinatra::Base
  register Sinatra::Reloader
  configure do
    enable :sessions
    set :session_secret, 'my_application_secret'
    set :public_folder, proc { File.join(root, '../../public') }
    set :views, 'app/views'
  end

  get '/' do
    @officials = Official.all
    @message = session[:message] ? session[:message] : ''
    session.delete(:message)
    erb :index
  end

  post '/officials/queryAPI' do
    address = params[:address]
    uri = URI("https://www.googleapis.com/civicinfo/v2/representatives?address=#{address}&key=#{ENV['GOOGLE_API_KEY']}")
    data = Net::HTTP.get(uri)
    json_data = Official.save_officials(data)
    content_type :json
    JSON.generate(json_data)
  end

  post '/officials/send' do
    result = ''
    if params[:toNumber].present? && params[:officials].present?
    to_numbers = params[:toNumber].split(',')
    officials = JSON.parse(params[:officials])
    else
      session[:message] = "Whoops, enter a phone number and check a box to send a text."
      redirect to '/'
    end

    client = Twilio::REST::Client.new(ENV['TWILIO_API_KEY'],ENV['TWILIO_API_SECRET'],ENV['TWILIO_ACCOUNT_SID'])
    to_numbers.each do |number|
      if valid_number?(number)

        officials.each do |official|
          client.messages.create(
            to: number,
            from: ENV['TWILIO_NUMBER_ONE'],
            body: "#{official['name']}, #{official['party']}, #{official['phone']}, #{official['url']}, #{official['email']}"
          )
        end
        result = 'Text message sent!'
      else
        result = 'Enter a valid number to recieve the text.'
      end
    end

    content_type :json
    JSON.generate({ message: result})
  end

  helpers do
    def valid_number?(number)
      phone_client = Twilio::REST::Client.new(
         ENV['TWILIO_API_KEY'],
         ENV['TWILIO_API_SECRET'],
         ENV['TWILIO_ACCOUNT_SID']
      )
      
      begin
        number = phone_client.lookups.v1.phone_numbers(number).fetch(type: 'carrier')
        number.carrier['type'] === 'mobile'
      rescue Twilio::REST::RestError => error
        @error = error
        return false
      end
    end
  end
end
