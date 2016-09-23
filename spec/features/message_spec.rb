require 'spec_helper'

feature "Bot echos back the message given" do
  scenario "Bot gets a message" do
    response = post "/", {token: ENV['SLACK_TOKEN'], text:'test'}
    expect response.body.should include('test')
  end
end
