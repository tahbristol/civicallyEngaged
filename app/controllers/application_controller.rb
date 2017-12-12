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
    erb :index
  end

  post '/officials' do
    @official = Official.create(name: params[:name], party: params[:party], phone: params[:phone], url: params[:url], position: params[:position], photoUrl: params[:photoUrl])
    @official.save
    content_type :json
    @official.to_json
  end

  post '/officials/send' do
    numbers = params[:toNumber].split('-')
    officials = params[:officials][:to_send]

    client = Twilio::REST::Client.new(
      account_sid = ENV['TWILIO_ACCOUNT_SID'],
      auth_token = ENV['TWILIO_AUTH_TOKEN']
    )

    numbers.each do |number|
      officials.each do |official|
        @official = Official.find(official)

        client.messages.create(
          to: number,
          from: ENV['TWILIO_NUMBER_ONE'],
          body: "#{@official.name}, #{@official.party}, #{@official.phone}, #{@official.url}"
        )
      end
      # flash[:text_sent] = 'Officials have been sent to your phone.'
    end
    redirect to '/'
  end

  post '/officials/delete' do
    Official.destroy_all
    @official = []
    content_type :json
    'none'.to_json
  end
end
