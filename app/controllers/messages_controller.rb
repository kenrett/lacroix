class MessagesController < ApplicationController
  HELP_RESPONSE = <<~HELP.freeze
    Use `/lacroix` and type a keyword.
    `add` allows you to document your consumption
    `today` displays your stats for today
    `week` displays your stats for the week
    `alltime` displays your lifetime stats
    `hero` displays your team's leaderboard
    Example: `/lacroix add`
  HELP
  INVALID_RESPONSE = <<~INVALID.freeze
    Sorry, I didn’t quite get that. You can try `add`, `help`, `today`, `week`, `alltime`, or `hero`'
  INVALID

  def index
    p "*" * 100
    p params['text']
    p "*" * 100
    case params['text'].to_s.downcase.strip
    when 'help', '' then HELP_RESPONSE
    when 'add'
      record_a_drink
    when 'today'
    when 'week'
    when 'alltime'
    when 'hero'
    else INVALID_RESPONSE
    end


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

  def record_a_drink
    flavors = Flavor.all
    actions = flavors.map { |flavor| flavor_params(flavor) }

    args = {
      text: 'Record your LaCroix intake, yo',
      actions: actions,
      action_text: 'Choose a flava'
    }

    render_to_slack(args)
  end

  def render_to_slack(args)
    slack_message = ::Slack.new(args)
    slack_args = slack_message.get_slack_args

    render json: slack_args.to_json, status: 200
  end
end
