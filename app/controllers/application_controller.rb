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
  erb :index
 end

end
