# GosmsClient

Simple ruby client for http://gosms.cz/.

This client is work in progress as it supports only fraction of endpoints.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gosms_client', :git => "https://github.com/Manikula/gosms_client"
```

And then execute:

    $ bundle

## Usage

```ruby
require 'gosms_client'

client = GosmsClient::Client.new('client_id', 'client_secret', 'channel_id')

client.get_credit
# => 16.1764

client.test_send("Hello world", "123321125")
# => <GosmsClient::MessageDetails:0x007fffd4f2e618 @data={"messageType"=>"SMS", "message"=>{"fulltext"=>"Hello world", "parts"=>["Hello world"]}, "channel"=>187931, "stats"=>{"price"=>2.42, "hasDiacritics"=>false, "smsCount"=>1, "messagePartsCount"=>1, "recipientsCount"=>1, "numberTypes"=>{"czMobile"=>0, "czOther"=>1, "sk"=>0, "other"=>0}}, "sendingInfo"=>{"status"=>"CONCEPT", "expectedSendStart"=>"2017-02-15T15:08:47+01:00", "sentStart"=>"", "sentFinish"=>""}, "reply"=>{"hasReplies"=>false, "repliesCount"=>0}}>

client.send("Hello", 123321215)
# => <GosmsClient::MessageDetails:0x007fffd4ef4ad0 @data={"recipients"=>{"invalid"=>[]}, "link"=>"/api/v1/messages/65465454"}>
```

`test_send` actually calls `send` with 3rd parameter 'true', indicating that it is test send of sms. Calling 
```ruby
client.test_send("Hello", "123321125")
```
or
```ruby
client.send("Hello", "123321125", true)
```
should do the same.

### Phone number validations
Sending sms doesn't wait for delivery of message and just tells you, where to find message status. That's why you can be charged for sending messages to seemingly impossible numbers. If you look closely at the examples, the number '123321215' is considered as a valid number (server does only basic validation on length and numberic chars) and server will try to deliver the message. This means that you should make better number validations on your side.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment. You can create `.env` file with Gosms credentials in project root and `bin/console` will load them.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Manikula/gosms_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
