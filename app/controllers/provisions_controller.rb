class ProvisionsController < ApplicationController

  SCOPE = 'commands,bot,chat:write:bot'

  def index
    app_uri = Util.get_app_url
    state = 'lacroix' # TODO this should be generated with some uniqueness based on the user
    oauth_url = "https://slack.com/oauth/authorize?scope=#{SCOPE}&client_id=#{Rails.configuration.app_client_id}&redirect_uri=#{Util.get_app_url}/auth&state=#{state}"
    redirect_to oauth_url, :status => 302
  end

  private

  # If we want to render an "Add to Slack" button instead of a "direct url" then use
  # render html: add_to_slack_button.html_safe
  # The HEREDOC below has the HTML code to generate the button
  def add_to_slack_button
    <<~HEREDOC
      <a href="https://slack.com/oauth/authorize?scope=#{SCOPE}&client_id=#{Rails.configuration.app_client_id}&redirect_uri=#{Util.get_app_url}/auth&state=lacroix"><img alt="Add to Slack" height="40" width="139" src="https://platform.slack-edge.com/img/add_to_slack.png" srcset="https://platform.slack-edge.com/img/add_to_slack.png 1x, https://platform.slack-edge.com/img/add_to_slack@2x.png 2x" /></a>
    HEREDOC
  end
end
