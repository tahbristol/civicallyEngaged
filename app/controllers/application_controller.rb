require './config/environment'
class ApplicationController < Sinatra::Base
  register Sinatra::Reloader
  configure do
    enable :sessions
    set :session_secret, "my_application_secret"
    set :public_folder, Proc.new{File.join(root,"../../public")}
    set :views, 'app/views'
  end

 get '/'do
 #binding.pry
  erb :index
 end

 post '/officials' do
  # binding.pry
   @official = Official.new(name: params[:name], party: params[:party], phone: params[:phone], url: params[:url], position: params[:position], photoUrl: params[:photoUrl])

  content_type :json
  @official.to_json

 end


end
