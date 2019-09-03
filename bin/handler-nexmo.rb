#!/usr/bin/env ruby
#
#   handler-nexmo.rb
#
# DESCRIPTION:
#   Sensu handler for sending SMS through Nexmo provider.
#
# OUTPUT:
#   None unless there is an error
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-handler
#   gem: nexmo
#   gem: time
#
# USAGE:
#   Configure Nexmo api_key, api_secret, recipients in nexmo.json
#
# NOTES:
#
# LICENSE:
#   Copyright (c) 2019, Nicolas Boutet amd3002@gmail.com
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-handler'
require 'nexmo'
require 'time'

class NexmoAlert < Sensu::Handler
  def send_sms(recipient, msg)
    client = Nexmo::Client.new(
      api_key: api_key,
      api_secret: api_secret
    )
    response = client.sms.send(
      from: from,
      to: recipient,
      text: msg
    )
    return if response.messages.first.status == '0'
    puts "Error: #{response.messages.first.error_text}"
    exit 1
  end

  def api_key
    settings['nexmo']['api_key']
  end

  def api_secret
    settings['nexmo']['api_secret']
  end

  def action_to_string
    @event['action'].eql?('resolve') ? 'RESOLVED' : 'ALERT'
  end

  def executed_at
    Time.at(@event['check']['executed']).to_datetime
  end

  def from
    settings['nexmo']['from']
  end

  def msg
    "#{action_to_string} - #{short_name}: #{output} #{executed_at}"
  end

  def output
    @event['check']['output'].strip
  end

  def recipients
    @event['check']['nexmo']['recipients']
  end

  def short_name
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def handle
    recipients.each do |recipient|
      send_sms(recipient, msg)
    end
  end
end
