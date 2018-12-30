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
      },
    ]

    attachments = [{
      color: '#3AA3E3',
      text: 'Choose a flava',
      callback_id: 'lacroix',
      actions: actions
    }]

    args = {
      text: 'Record your La Croix intake, yo',
      attachments: attachments
    }

    slack_message = ::Slack.new(args)
    slack_message.post_message
    render status: 200
  end
end
