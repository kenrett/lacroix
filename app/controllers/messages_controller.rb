class MessagesController < ApplicationController
  def index
    actions = [
      {
          name: 'flavor',
          text: ':peach:',
          type: 'button',
          value: 1
      },
      {
        name: 'flavor',
        text: ':pear:',
        type: 'button',
        value: 2
      }
    ]

    args = {
      text: 'Record your La Croix intake, yo',
      actions: actions,
      action_text: 'Choose a flava'
    }

    slack_message = ::Slack.new(args)
    thing = slack_message.get_slack_args
    render json: thing.to_json, status: 200
  end
end
