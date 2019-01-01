class AuthsController < ApplicationController

  def index

    # First we get the code and state params that Slack sends back to use during the OAuth flow
    params.require([:code, :state])
    oauth_code = params[:code]
    oauth_state = params[:state]

    # Next match a request back to the Slack oauth.access API to get a token
    conn = Faraday.new(:url => 'https://slack.com/api/') do |c|
      c.request  :url_encoded
      #c.response :logger                  # log requests to STDOUT
      #c.response :json                  # form response as JSON (otherwise it will be a string)
      c.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    body = {
      client_id: Rails.configuration.app_client_id,
      client_secret: Rails.configuration.app_client_secret,
      code: oauth_code,
      redirect_uri: "#{Util.get_app_url}/auth"
    }

    response = conn.post do |req|
      req.url 'oauth.access'
      req.body = body
    end

    # Great, we got a response back, let's make it is valid
    if response.status != 200
      raise ActionController::RoutingError.new("Error! Received a #{response.status} during OAuth.")
    end

    # Now parse the response and store the details
    body = JSON.parse(response.body)
    Auth.find_or_create_by(user_id: body['user_id'], team_id: body['team_id'], access_token: body['access_token'], scope: body['scope'], bot_user_id: body['bot']['bot_user_id'], bot_access_token: body['bot']['bot_access_token'])

    # Redirect the user back to Slack, going right to the bot DM
    redirect_to "https://slack.com/app_redirect?app=#{Rails.configuration.app_id}&team=#{body['team_id']}", :status => 302

  end

end