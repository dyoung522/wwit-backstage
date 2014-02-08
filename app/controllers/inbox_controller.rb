class InboxController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_member!

  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV['MANDRILL_WEBHOOK_KEY']

  def handle_send(event_payload)
    # ToDo: Add delivered_at date to messages in event_payload
    logger.debug '>>> Received Mandrill SendEvent WebHook!'
  end
end