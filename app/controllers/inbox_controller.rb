class InboxController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_member!

  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV['MANDRILL_WEBHOOK_KEY']

  def handle_send(event_payload)
    return if event_payload.nil?
    return unless event_payload['msg'].has_key?('metadata')

    message_id = event_payload['msg']['metadata']['message_id']
    return if message_id.nil?

    message = Message.where(email_message_id: message_id).first
    unless message.nil?
      message.delivered_at = Time.at(event_payload['ts']).to_datetime.utc
      message.save
    end
  end

end