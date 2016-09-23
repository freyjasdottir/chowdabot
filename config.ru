# This file is used by Rack-based servers to start the application.

require './app'
require 'dotenv'
Dotenv.load
run Sinatra::Application
