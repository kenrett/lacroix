class IntakesController < ApplicationController
  def create
    Intake.create(
      user_id: intake_params[:user][:id],
      flavor_id: intake_params[:actions][0][:value]
    )
    show_stats
  end

  private

  def intake_params
    json_params = ActionController::Parameters.new(JSON.parse(params['payload']))
    json_params.permit(user: :id, actions: [:value])
  end

  def user_id
    intake_params[:user][:id]
  end

  def flavor_id
    intake_params[:actions][0][:value]
  end

  def get_total_count_for_past_seven_days
    Intake.where(user_id: user_id).this_week
  end

  def total_today
    Intake.where(user_id: user_id).today
  end

  def show_stats
    flavor = Flavor.find(flavor_id).name
    text = "#{flavor.titleize} recorded. You have had #{total_today.count} #{"LaCroix".pluralize(total_today.count)} today. #{total_today.by_flavor(flavor_id).count} of them have been #{flavor}."
    slack_message = ::Slack.new(text: text)

    render json: slack_message.to_json, status: 200
  end
end
