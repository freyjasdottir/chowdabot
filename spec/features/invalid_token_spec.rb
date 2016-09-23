require 'spec_helper'

feature "Bot validates slack team token" do
  scenario "an invalid token is sent" do
    expect{ post "/", {token: "notavalidtoken"} }.to raise_error(InvalidTokenError)
  end

  scenario "a valid token is sent" do
    expect{ post "/", {token: ENV['SLACK_TOKEN'], text:'hello'} }.not_to raise_error
  end
end
