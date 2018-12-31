class AuthsController < ApplicationController

  def index
    params.require([:code, :state])
    code = params[:code]
    state = params[:state]
    render json: state
  end

end