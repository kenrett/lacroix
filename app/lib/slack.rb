require 'faraday'
require 'json'

class Slack
  attr_accessor :request, :channel, :text, :username, :icon_url, :params, :attachments

  def initialize(opts = {})
    # Default Slack channel based on environment.
    @text = opts.fetch(:text, 'Testing!')
    @action_text = opts.fetch(:action_text, 'Choose an action')
    @actions = opts.fetch(:actions, [])
    @attachments = []
    @callback_id = opts.fetch(:callback_id, 'lacroix')

    # format attachments
    if @actions.any?
      attachments = []
      @actions.each_slice(5) do |a|
        attachments << {
          color: '#3AA3E3',
          text: '',
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
    # this will raise a ActiveRecord::RecordNotFound exception if the Auth data can't be found
    auth = Auth.where(team_id: slack_team_id).first
    raise ArgumentError.new('No authorizations found for this workspace. Please go through the /provision flow first') if auth.nil?

    body = get_slack_args
    body[:channel] = slack_user_id
    body[:as_user] = true

    call_slack_api_json('chat.postMessage', body, auth.bot_access_token)
  end

  private

  # Centralized location to call the Slack API with a JSON payload.
  # - `body` is a hash of arguments that will be formatted as JSON
  # - `access_token` is a Slack token that will be passed as an HTTP header bearer token to Slack
  def call_slack_api_json(api_method, body = {}, access_token)
    conn = Faraday.new(:url => 'https://slack.com/api/') do |c|
      c.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn.response :logger if Rails.env.development?

    conn.post do |req|
      req.url api_method
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{access_token}"
      req.body = body.to_json
    end
  end

end
