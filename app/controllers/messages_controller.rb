class MessagesController < ApplicationController
  def index
    flavors = Flavor.all

    actions = flavors.map do |flavor|
      flavor_params(flavor)
    end

    args = {
      text: 'Record your LaCroix intake, yo',
      actions: actions,
      action_text: 'Choose a flava'
    }

    slack_message = ::Slack.new(args)
    thing = slack_message.get_slack_args
    render json: thing.to_json, status: 200
  end

  private

  def flavor_params(flavor)
    {
      name: flavor.name,
      text: flavor.text,
      type: 'button',
      value: flavor.id
    }
  end
end
