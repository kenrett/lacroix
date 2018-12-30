require 'faraday'
require 'json'

class Slack
  attr_accessor :request, :channel, :text, :username, :icon_url, :params, :attachments

  # TODO don't hard code an incoming webhook here, use OAuth app distrubtion
  WEBHOOK_LA_CROIX_TEST = "BF5154EG6/RT62CQWxF76gBxU21kmCxIcX" #la-croix-testin channel

  def initialize(opts = {})
    # Default Slack channel based on environment.
    @webhook = opts.fetch(:webhook, WEBHOOK_LA_CROIX_TEST)
    @text = opts.fetch(:text, 'Testing!')
    @attachments = opts.fetch(:attachments, [])
    @callback_id = opts.fetch(:callback_id, 'lacroix')

    #setup Faraday connection to call Slack API
    #TODO don't hard code an incoming webhook here, use OAuth app distrubtion
    @request = Faraday.new(:url => 'https://hooks.slack.com/services/T04GF0BAF/') do |c|
      #c.request  :json
      c.response :logger                  # log requests to STDOUT
      #c.response :json                  # form response as JSON (otherwise it will be a string)
      c.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

  end

  def post_message
    params = {
      text: @text,
    }

    params[:attachments] = @attachments if !@attachments.empty?

    params = params.to_json

    @request.post do |req|
      req.url @webhook
      req.headers['Content-Type'] = 'application/json'
      req.body = params
    end
  end
end
