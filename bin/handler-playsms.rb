#! /usr/bin/env ruby
#
#   handler-playsms.rb
#
# DESCRIPTION:
#   Sensu handler for sending SMS messages through a playSMS gateway.
#
# OUTPUT:
#   None unless there is an error
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-handler
#   gem: playsms
#
# USAGE:
#
#   Configure your playSMS host, user, and secret here:
#     playsms.json
#
#   Recipients can be a single phone number, or a playSMS #groupcode or @username defined in the
#     playSMS "phonebook" of your API user.  Recipients are listed in the checks as an array of
#     one or more of the above.
#     e.g. [ '1234567890', '@joe_smith', '#operations' ]
#
# NOTES:
#
# LICENSE:
#   Matt Mencel mr-mencel@wiu.edu
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'date'
require 'playsms'
require 'sensu-handler'
require 'timeout'

# playSMS Handler
class PlaysmsAlert < Sensu::Handler
  def send_sms(recipients, msg)
    client = Playsms::Client.new(user: api_user, secret: api_secret, host: host)
    client.send_message(to: recipients, msg: msg)
  end

  def api_user
    settings['playsms']['api_user']
  end

  def api_secret
    settings['playsms']['api_secret']
  end

  def action_to_string
    @event['action'].eql?('resolve') ? 'RESOLVED' : 'ALERT'
  end

  def executed_at
    Time.at(@event['check']['executed']).to_datetime
  end

  def host
    settings['playsms']['host']
  end

  def msg
    "#{action_to_string} - #{short_name}: #{output} #{executed_at}"
  end

  def output
    @event['check']['output'].strip
  end

  def recipients
    @event['check']['playsms']['recipients'].join ','
  end

  def short_name
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def handle
    Timeout.timeout 10 do
      send_sms(recipients, msg)
      puts 'playsms -- sent alert for ' + short_name + ' to ' + recipients
    end
  rescue Timeout::Error
    puts 'playsms -- timed out while attempting to ' + action_to_string + ' an incident -- '\
         '(TO: ' + settings['playsms']['recipients'] + ' SUBJ: ' + subject + ')' + short_name
  end
end
