# chowdabot

This is a slowly forming slack app intended for #not-only-chowda to organize meals. It uses Launch Academy's Sinatra ActiveRecord Starter Kit.


#Configuring Multiple Environments

Chowdabot can load multiple environment variable sets when its server boots, to support testing and running a live instance from the same server, or to support multiple Slacks or multiple channels on the same Slack from a single server. You can add and configure multiple environments as follows:

SLACK_CONFIGS must be a space-delimited list of strings. Ex: "DEV PROD"

SLASH_COMMAND_AUTH_TOKEN_ is the authentication token you receive from Slack for your custom slash command integration
INCOMING_WEBHOOK_URL_ is the incoming webhook URL you receive from Slack for your incoming webhook integration
CHANNEL_ is the name of the channel the incoming webhook will post to.

Each of these variable names should have the name of each environment appended to them, and each environment referenced in SLACK_CONFIGS requires the full set.

An example set of environment variables:

```
SLACK_CONFIGS="DEV PROD"

SLASH_COMMAND_AUTH_TOKEN_DEV=...
INCOMING_WEBHOOK_URL_DEV=...
CHANNEL_DEV='#dev-channel-example'

SLASH_COMMAND_AUTH_TOKEN_PROD=...
INCOMING_WEBHOOK_URL_PROD=...
CHANNEL_PROD='#prod-channel-example'
```
