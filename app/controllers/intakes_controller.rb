class IntakesController < ApplicationController
  def create
    Intake.create(user_id: intake_params[:user][:id], flavor_id: intake_params[:actions][0][:value])
  end

  private

  def intake_params
    json_params = ActionController::Parameters.new(JSON.parse(params['payload']))
    json_params.permit(user: :id, actions: [:value])
  end
end
