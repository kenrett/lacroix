class MessagesController < ApplicationController

  def index
    render json: { data: '<h1>This is text</h1>' }
  end
end
