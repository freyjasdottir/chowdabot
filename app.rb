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

env_configs = {}

ENV['SLACK_CONFIGS'].split(' ').each do |config|
  auth_token = ENV['SLASH_COMMAND_AUTH_TOKEN_' + config]
  incoming_webhook = ENV['INCOMING_WEBHOOK_URL_' + config]
  channel = ENV['CHANNEL_' + config]
  env_configs[auth_token] = {webhook: incoming_webhook, channel: channel}
end

InvalidTokenError = Class.new(Exception)

def adminize_message(webhook, channel, msg)
  message = {
    "username": "chowdabot",
    "channel": channel,
    "text": "<!channel> " + msg,
    "link_names": 1
  }.to_json

  HTTParty.post(
    webhook,
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
  if env_configs.has_key?(params[:token])
    config = env_configs[params[:token]]
    adminize_message(config[:webhook], config[:channel], params['text'])
    status 200
  else
    raise InvalidTokenError
    status 401
  end
end
