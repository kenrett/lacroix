class IntakesController < ApplicationController
  def create
    p "*" * 100
    p params["payload"]
    p "*" * 100
    Intake.create(intake_params)
    # Intake.create(user_id: params["payload"]["user"]["id"], flavor_id: params["payload"]["actions"][0]["value"])
  end

  private

  def intake_params
    p "*" * 200
    p "actions: #{params['payload']['actions']}"
    p "user_id: #{params['payload']['user']['id']}"
    p "flavor_id: #{params['payload']['actions'][0]['value']}"
    p "*" * 200
  end

  # <ActionController::Parameters
  #   {
    #   "payload"=>
    #   "{
    #     "type":"interactive_message",
    #     actions":[{"name":"pure",type":"button",value":"15"}],
    #     callback_id":"lacroix",
    #     team":{"id":"T04GF0BAF",domain":"beer-and-poop"},
    #     channel":{"id":"CF4L9EQ8P",name":"la-croix-testin"},
    #     user":{"id":"U04GF0BB5",name":"ken"},
    #     action_ts":"1546137583.446588",
    #     message_ts":"1546137577.012000",
    #     attachment_id":"1",
    #     token":"qV7XHOQeLC1g7e0VABcwXOId",
    #     is_app_unfurl":false,
    #     response_url":"https://hooks.slack.com/actions/T04GF0BAF/515078615590/4sMjegL07Sm8jWy2bv6bOCcR",
    #     trigger_id":"513508642596.4559011355.8310d2c0d0a3ea78c7be44a31ad30185"}",
    #     "controller"=>"intakes",
    #     "action"=>"create"
    #   }
  #   permitted: false
  # >

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


end


# payload = "{"type":"interactive_message","actions":[{"name":"lime","type":"button","value":"16"}],"callback_id":"lacroix","team":{"id":"T04GF0BAF","domain":"beer-and-poop"},"channel":{"id":"CF4L9EQ8P","name":"la-croix-testin"},"user":{"id":"U04GF0BB5","name":"ken"},"action_ts":"1546136129.344403","message_ts":"1546136107.011400","attachment_id":"1","token":"qV7XHOQeLC1g7e0VABcwXOId","is_app_unfurl":false,"response_url":"https://hooks.slack.com/actions/T04GF0BAF/513673193954/qRFTD5id6WmOTZh0Rtdzwfkt","trigger_id":"513505021524.4559011355.e24eb14b1f58f1515372a51727fa412f"}"
