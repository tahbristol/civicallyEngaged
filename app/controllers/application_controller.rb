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
    @message = session[:message] ? session[:message] : ''
    session.delete(:message)
    erb :index
  end

  post '/officials/queryAPI' do
    json_data = Official.fetch_all_for_address(params[:address])
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

    twilio_client = API::TwilioRequest.new

    to_numbers.each do |number|
      if twilio_client.valid_number?(number, 'carrier', 'mobile')
        officials.each do |official|
          message = "#{official['name']}, #{official['party']}, #{official['phone']}, #{official['url']}, #{official['email']}"
          twilio_client.send_text(number, message)
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
  end
end
