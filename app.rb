require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'json'

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

InvalidTokenError = Class.new(Exception)

get '/' do
  @title = "Hello World"
  erb :index
end

post '/' do
  raise(InvalidTokenError) unless params[:token] == ENV['SLACK_TOKEN']

  content_type :json
  {
    "response_type": "in_channel",
    "text": "<!channel> " + params['text']
  }.to_json
end
