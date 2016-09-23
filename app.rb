require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'json'
require 'dotenv'

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

get '/' do
  @title = "Hello World"
  erb :index
end

post '/' do
  raise(InvalidTokenError) unless params[:token] == ENV['SLACK_TOKEN']

  json_message = {
    "response_type": "in_channel",
    "text": "<!channel> " + params['text']
  }.to_json

  content_type :json
  json_message
end
