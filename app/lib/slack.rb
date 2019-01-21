require 'faraday'
require 'faraday_middleware'
require 'json'
require 'mimemagic'

#
# Basic wrapper for Slack API to sending messages and files.
# You can either send messages via the Slack API, or format them for response _back_
# to Slack when interacting with Slash commands or other actions
# When responding back to Slack actions use Slack::get_slack_args
# When proactively sending messages you can use Slack::post_to_bot_dm
#
# Simplest usage to just send some text:
#   slack = Slack.new({text: "Hellow wurld"})
#   slack.post_to_bot_dm('U12345', 'T123455')
#
# Sending a message with a button
#   slack = Slack.new({text: 'Click me!', actions: [{name: 'some button', text: 'click me!', value: 1234, type: 'button'}]})
#   slack.post_to_bot_dm('U12345', 'T123455')
#
# Sending a file with a message
#   slack = Slack.new({text: 'Here is a pic!', filepath: '/path/to/file.jpg'})
#   slack.post_file_to_bot_dm('U12345', 'T123455')
#


class Slack
  attr_accessor :request, :channel, :text, :params, :attachments, :filepath

  def initialize(opts = {})
    # Default Slack channel based on environment.
    @text = opts.fetch(:text, 'Testing!')
    @action_text = opts.fetch(:action_text, 'Choose an action')
    @actions = opts.fetch(:actions, [])
    @attachments = []
    @filepath = opts.fetch(:filepath, nil)
    @callback_id = opts.fetch(:callback_id, 'lacroix')

    # format attachments
    if @actions.any?
      attachments = []
      @actions.each_slice(5) do |a|
        attachments << {
          color: '#3AA3E3',
          text: '', # "#{a[0][:name].titleize}",
          callback_id: 'lacroix',
          actions: a
        }
      end
      @attachments = attachments
    end

  end

  # return the args formatted for sending to Slack
  def get_slack_args
    {
      text: @text,
      attachments: @attachments
    }
  end

  # simple post to the Slack LaCroix Bot DM channel (aka "App DM").
  # Pass an encoded Slack user_id (e.g. U12345) and an encoded Slack team_id (e.g. T1245)
  # The given workspace must already have gone through the OAuth flow and stored a bot token in our side first.
  # You can do this by going to /provision and authorizing the app on your workspace
  #
  # For example, here is a simple call to this method
  #     slack = Slack.new({text: "Hi there good sir"})
  #     slack.post_to_bot_dm('U04GFUB4R', 'T04GF0BAF')
  #
  def post_to_bot_dm(slack_user_id, slack_team_id)
    auth = get_user_auth(slack_team_id)

    body = get_slack_args
    body[:channel] = slack_user_id
    body[:as_user] = true

    call_slack_api_json('chat.postMessage', body, auth.bot_access_token)
  end

  # Same as above, but post a file instead of just a method
  # Technically file uploads are different from just message sending, and use a different Slack API,
  # but we could just combine these actions into one method for simplicity. If so, just need to refactor
  # The caveat is that file uploads require a Slack channel ID, so we need to call two Slack APIs here
  # instead of just one when we want to send a single message.
  def post_file_to_bot_dm(slack_user_id, slack_team_id)
    auth = get_user_auth(slack_team_id)
    mime = MimeMagic.by_magic(File.open(@filepath))
    dm_channel = nil

    # First we need to figure out the DM channel for the given user
    body = {
      user: slack_user_id
    }
    dm_data = JSON.parse(call_slack_api_json('im.open', body, auth.bot_access_token).body)
    raise ArgumentError.new("Received error from Slack API: #{dm_data['error']}") if dm_data['ok'] == false
    dm_channel = dm_data['channel']['id']
    raise ArgumentError.new("Unable to find DM channel between bot and user #{slack_user_id}") if dm_channel.nil?

    body = {
      channels: dm_channel,
      file: Faraday::UploadIO.new(@filepath, mime.type),
      initial_comment: @text
    }

    call_slack_api_json('files.upload', body, auth.bot_access_token)
  end

  private

  # Find an auth row for the given team and return it
  def get_user_auth(slack_team_id)
    # this will raise a ActiveRecord::RecordNotFound exception if the Auth data can't be found
    auth = Auth.where(team_id: slack_team_id).first
    raise ArgumentError.new('No authorizations found for this workspace. Please go through the /provision flow first') if auth.nil?
    auth
  end

  # Centralized location to call the Slack API
  # This will automatically format the API request to the right type depending on the use case (multipart/form-data or application/json)
  # - `api_method` is the Slack API to call
  # - `body` is a hash of arguments
  # - `access_token` is a Slack token that will be passed as an HTTP header bearer token to Slack
  def call_slack_api_json(api_method, body = {}, access_token)
    request_type = body.key?(:file) ? :multipart : :json
    conn = Faraday.new(:url => 'https://slack.com/api/') do |c|
      c.request request_type
      c.adapter Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn.response :logger if Rails.env.development?

    conn.post do |req|
      req.url api_method
      req.headers['Authorization'] = "Bearer #{access_token}"
      req.body = body
    end
  end

end
