require 'webmock/rspec'
require 'byebug'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |c|
  c.color = true
  c.formatter = :documentation
  c.tty = true
end

def stub_auth
  stub_request(:post, "https://app.gosms.cz/oauth/v2/token").
    to_return(:status => 200,
              :body => {
                "access_token": "AccessTokenIU78JO",
                "expires_in": "3600",
                "token_type": "bearer",
                "scope": "user"}.to_json,
              :headers => {"Content-Type"=> "application/json"})
end

def stub_error(code)
  stub_request(:post, "https://app.gosms.cz/api/v1/messages/test").
       to_return(:status => code,
                 :body => "",
                 :headers => {})
end

def expect_requested(method, site)
  expect(WebMock).to have_requested(method, site).
    with(:headers => {'Authorization'=>'Bearer AccessTokenIU78JO'})
end

def test_info_body(msg)
{
"messageType": "SMS",
"message": {
 "fulltext": "#{msg}",
 "parts": ["#{msg}"]
},
"channel": 1,
"stats": {
 "price":  1.452,
 "hasDiacritics": true,
 "smsCount": 1,
 "messagePartsCount": 1,
 "recipientsCount": 1,
 "numberTypes": {
     "czMobile": 1,
     "czOther": 0,
     "sk": 0,
     "pl": 0,
     "hu": 0,
     "ro": 0,
     "other": 0
}},
"sendingInfo": {
 "status": "CONCEPT",
 "expectedSendStart": "2015-08-10T21:23:00+02:00",
 "sentStart": "",
 "sentFinish": ""
},
"reply": {
 "hasReplies":true,
 "repliesCount":0
}}.to_json
end
