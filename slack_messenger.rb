require 'httparty'

class SlackMessenger

  def self.adminize_message(message_data)
    message = {
      "username": "chowdabot",
      "channel": message_data[:channel],
      "text": "<!channel> @#{message_data[:user]} says: #{message_data[:text]}",
      "link_names": 1
    }

    message
  end

  def self.post_message(message, webhook_url)
    HTTParty.post(
      webhook_url,
      :body => message,
      :headers => {
        'Content-type' => 'application/json'
      }
    )
  end
end
