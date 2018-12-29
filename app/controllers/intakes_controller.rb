class IntakesController < ApplicationController
  def index
    @intakes = Intake.all

    render @intakes.to_json
  end

  def create
    Intake.create(params)
  end


  # private

  # def instake_params
  #   params.require
  # end
end
