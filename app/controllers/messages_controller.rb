class MessagesController < ApplicationController
  HELP_RESPONSE = <<~HELP.freeze
    Use `/lacroix` and type a keyword.
    `add` allows you to document your consumption
    `today` displays your stats for today
    `week` displays your stats for the week
    `alltime` displays your lifetime stats
    `hero` displays your team's leaderboard
    `undo` undoes your last bubbly delight
    Example: `/lacroix add`
  HELP
  INVALID_RESPONSE = <<~INVALID.freeze
    Sorry, I didn’t quite get that. You can try `add`, `help`, `today`, `week`, `alltime`, or `hero`
  INVALID

  def index
    @user_id = params['user_id']
    case params['text'].to_s.downcase.strip
    when 'help' then render_to_slack(text: HELP_RESPONSE)
    when 'add' then record_a_drink
    when 'today' then today_stats
    when 'week' then week_stats
    when 'alltime' then alltime_stats
    when 'hero' then leaderboard
    when 'undo' then undo
    else render_to_slack(text: INVALID_RESPONSE)
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

  def today_stats
    count = Intake.where(user_id: @user_id).today.count
    text = <<~TODAY
      You have had #{count} #{'LaCroix'.pluralize(count)} today.
    TODAY
    render_to_slack(text: text)
  end

  def week_stats
    count = Intake.where(user_id: @user_id).this_week.count
    text = <<~WEEK
      You have had #{count} #{'LaCroix'.pluralize(count)} this week.
    WEEK
    render_to_slack(text: text)
  end

  def alltime_stats
    count = Intake.where(user_id: @user_id).count
    text = <<~ALLTIME
      You have had #{count} #{'LaCroix'.pluralize(count)} since you started tracking.
    ALLTIME
    render_to_slack(text: text)
  end

  def leaderboard
    render_to_slack(text: 'This has not been implemented yet.')
  end

  def undo
    intake = Intake.where("user_id = ? AND created_at < ? ", @user_id, Time.now).order("created_at DESC").first
    render_to_slack(text: "We found no history for you. Do you even bubble bro?") if intake.nil?

    flavor = Flavor.find(intake.flavor_id)
    Intake.find(intake.id).destroy
    render_to_slack(text: "Your most recent drink was a #{flavor.name}. We deleted it - it's like it never happened. :poop:")
  end

  def render_to_slack(args)
    slack_message = ::Slack.new(args)
    slack_args = slack_message.get_slack_args

    render json: slack_args.to_json, status: 200
  end
end
