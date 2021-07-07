## Sensu-Plugins-sms

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-sms.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-sms)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-sms.svg)](http://badge.fury.io/rb/sensu-plugins-sms)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-sms/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-sms)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-sms/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-sms)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-sms.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-sms)

## Functionality

## Files
 * bin/check-sms
 * bin/handler-playsms
 * bin/handler-nexmo
 * bin/metrics-sms-bulk
 * bin/metrics-sms-if
 * bin/metrics-sms


## Usage

### FreeSMS

```json
{
  "free_sms_alert": {
    "carrier_portal": {
      // US carriers:
      "att": "%number%@txt.att.net",
      "verizon": "%number%@vtext.com",
      "tmobile": "%number%@tmomail.net",
      "sprint": "%number%@messaging.sprintpcs.com",
      "virgin": "%number%@vmobl.com",
      "uscellular": "%number%@email.uscc.net",
      "nextel": "%number%@messaging.nextel.com",
      "boost": "%number%@myboostmobile.com",
      "alltel": "%number%@message.alltel.com",
      // Canadian carriers:
      "telus": "%number%@msg.telus.com",
      "rogers": "%number%@pcs.rogers.com",
      "fido": "%number%@fido.ca",
      "bell": "%number%@txt.bell.ca",
      "mts": "%number%@text.mtsmobility.com",
      "kudo": "%number%@msg.koodomobile.com",
      "presidentschoice": "%number%@txt.bell.ca",
      "sasktel": "%number%@sms.sasktel.com",
      "solo": "%number%@txt.bell.ca",
      "virgincanada": "%number%@vmobile.ca",
      // Dummy carrier (in case you actually want to send an email):
      "email": "%number%"
    },
    "smtp_address": "localhost",
    "smtp_domain":  "localhost.localdomain",
    "smtp_port":    "25",
    "mail_from":    "sensu_alert@mydomain.com"
  }
}
```

```json
{
  "free_sms_alert": {
    "alert_recipient_mappings": {

      "ttutone": {
        "name": "Tommy Tutone",
        "carrier": "att",
        "number": "800-867-5309"
      },

      "ghostbuster": {
        "name": "Ghost Busters",
        "carrier": "tmobile",
        "number": "800-555-2368"
      }
    }
  }
}
```

### playSMS

Create a json config file with your host, API user, and API secret.

```json
{
  "playsms": {
    "host": "http://playsms.example.com",
    "api_user": "sensu",
    "api_secret": "XXXXX"
  }
}
```

Set your check to use the handler and define the playsms recipients.

```json
{
  "checks": {
    "check-disk-usage": {
      "command": "check-disk-usage.rb -w :::disk.warning|80::: -c :::disk.critical|90:::",
      "subscribers": [
        "production"
      ],
      "handlers": [
        "playsms"
      ],
      "playsms": {
        "recipients": [
          "1234567890",
          "@joe_smith",
          "#operations"
        ]
      },
      "interval": 60,
    }
  }
}
```

### Nexmo

Create a json config file with your Nexmo API user, API secret and sender.

```json
{
  "nexmo": {
    "api_key": "nexmo",
    "api_secret": "XXXXX",
    "from": "SENSU"
  }
}
```

Set your check to use the handler and define the nexmo recipients.

```json
{
  "checks": {
    "check-disk-usage": {
      "command": "check-disk-usage.rb -w :::disk.warning|80::: -c :::disk.critical|90:::",
      "subscribers": [
        "production"
      ],
      "handlers": [
        "nexmo"
      ],
      "nexmo": {
        "recipients": [
          "1234567890",
          "5556667778"
        ]
      },
      "interval": 60,
    }
  }
}
```

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Notes
