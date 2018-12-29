class IntakesController < ApplicationController
  def index
    "Get Yo' Drink On"
  end

  def create
    Intake.create(params)
  end


  # private

  # def instake_params
  #   params.require
  # end
end
