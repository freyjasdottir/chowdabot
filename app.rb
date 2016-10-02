require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'json'
require 'dotenv'
require 'httparty'

enable :sessions

configure :development, :test do
  require 'pry'
end

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

Dotenv.load

InvalidTokenError = Class.new(Exception)

def adminize_message(msg)
  message = {
    "username": "chowdabot",
    "channel": "#not-only-chowda",
    "text": "<!channel> " + msg
  }.to_json

  HTTParty.post(
    ENV['INCOMING_WEBHOOK_URL'],
    :body => message,
    :headers => {
      'Content-type' => 'application/json'
    }
  )
end

get '/' do
  @title = "Hello World"
  erb :index
end

post '/' do
  if params[:token] == ENV['SLASH_COMMAND_AUTH_TOKEN']
    adminize_message(params['text'])
    status 200
  else
    raise InvalidTokenError
    status 401
  end
end
