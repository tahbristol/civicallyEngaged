require './config/environment'
require 'sinatra/flash'
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

  post '/officials' do
    @official = Official.create(name: params[:name], party: params[:party], phone: params[:phone], url: params[:url], position: params[:position], photoUrl: params[:photoUrl])
    @official.save
    content_type :json
    @official.to_json
  end

  post '/officials/send' do
    if params[:toNumber].present? && params[:officials].present?
    to_numbers = params[:toNumber].split(" ")
    officials = params[:officials][:to_send]
  else
    session[:message] = "Whoops, enter a phone number and check a box to send a text."
    redirect to '/'
  end
    client = Twilio::REST::Client.new(
      account_sid = ENV['TWILIO_ACCOUNT_SID'],
       auth_token = ENV['TWILIO_AUTH_TOKEN']
    )
    to_numbers.each do |number|
      if valid_number?(number.gsub("-"," "))
        officials.each do |official|
          @official = Official.find(official)
          client.messages.create(
            to: number,
            from: ENV['TWILIO_NUMBER_ONE'],
            body: "#{@official.name}, #{@official.party}, #{@official.phone}, #{@official.url}"
          )
        end
        session[:message] = 'Text message sent!'
      else
        session[:message] = 'Enter a valid number to recieve the text.'
      end
    end
    redirect to '/'
  end

  post '/officials/delete' do
    Official.destroy_all
    @official = []
    content_type :json
    'none'.to_json
  end

  helpers do
    def valid_number?(number)
      phone_client = Twilio::REST::Client.new(
         ENV['TWILIO_ACCOUNT_SID'],
         ENV['TWILIO_AUTH_TOKEN']
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
