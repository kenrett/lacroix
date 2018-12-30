class IntakesController < ApplicationController
  def create
    p "*" * 100
    p params
    p "*" * 100
    Intake.create(user_id: params["payload"]["user"]["id"], flavor_id: params["payload"]["actions"][0]["value"])
  end


  # {
    # "payload"=>
      # '{
      #   "type":"interactive_message",
      #   "actions":[{"name":"lime","type":"button","value":"16"}],
      #   "callback_id":"lacroix",
      #   "team": {"id":"T04GF0BAF","domain":"beer-and-poop"},
      #   "channel":{"id":"CF4L9EQ8P","name":"la-croix-testin"},
      #   "user":{"id":"U04GF0BB5","name":"ken"},
      #   "action_ts":"1546136129.344403",
      #   "message_ts":"1546136107.011400",
      #   "attachment_id":"1",
      #   "token":"qV7XHOQeLC1g7e0VABcwXOId",
      #   "is_app_unfurl":false,
      #   "response_url":"https://hooks.slack.com/actions/T04GF0BAF/513673193954/qRFTD5id6WmOTZh0Rtdzwfkt",
      #   "trigger_id":"513505021524.4559011355.e24eb14b1f58f1515372a51727fa412f"
      # }'
  # }

  # private

  # def instake_params
  #   params.require('payload').permit('actions', 'user')
  # end
end


# payload = "{"type":"interactive_message","actions":[{"name":"lime","type":"button","value":"16"}],"callback_id":"lacroix","team":{"id":"T04GF0BAF","domain":"beer-and-poop"},"channel":{"id":"CF4L9EQ8P","name":"la-croix-testin"},"user":{"id":"U04GF0BB5","name":"ken"},"action_ts":"1546136129.344403","message_ts":"1546136107.011400","attachment_id":"1","token":"qV7XHOQeLC1g7e0VABcwXOId","is_app_unfurl":false,"response_url":"https://hooks.slack.com/actions/T04GF0BAF/513673193954/qRFTD5id6WmOTZh0Rtdzwfkt","trigger_id":"513505021524.4559011355.e24eb14b1f58f1515372a51727fa412f"}"
