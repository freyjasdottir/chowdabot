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

env_configs = {}
ENV['SLACK_CONFIGS'].split(' ').each do |config|
  auth_token = ENV['SLASH_COMMAND_AUTH_TOKEN_' + config]
  incoming_webhook = ENV['INCOMING_WEBHOOK_URL_' + config]
  channel = ENV['CHANNEL_' + config]
  env_configs[auth_token] = {webhook: incoming_webhook, channel: channel}
end

InvalidTokenError = Class.new(Exception)

get '/' do
  @title = "Hello World"
  erb :index
end

post '/' do
  if env_configs.has_key?(params[:token])
    config = env_configs[params[:token]]
    message_data =
      { channel: config[:channel],
        user: params[:user_name],
        text: params['text']
      }

    adminized = SlackMessenger.adminize_message(message_data)
    SlackMessenger.post_message(adminized, config[:webhook])
    status 200
  else
    raise InvalidTokenError
    status 401
  end
end
