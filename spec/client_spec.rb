require 'spec_helper'
require 'gosms_client'

describe GosmsClient::Client do

  before do
    @client = GosmsClient::Client.new("id","secret","channel")
    stub_auth
  end

  it "authenticates on first request" do
    stub_request(:get, "https://app.gosms.cz/api/v1/").
      to_return(:status => 200,
                :body => "",
                :headers => {"Content-Type"=> "text/plain"})

    2.times {@client.get_credit}
    expect(WebMock).to have_requested(:get, "https://app.gosms.cz/api/v1/").twice
    expect(WebMock).to have_requested(:post, "https://app.gosms.cz/oauth/v2/token").
       with(:body => hash_including({
         "client_id"=>"id",
         "client_secret"=>"secret",
         "grant_type"=>"client_credentials"})).once
  end

  it "asks for credit" do
    stub_request(:get, "https://app.gosms.cz/api/v1/").
        to_return(:status => 200,
                  :body => {"currentCredit": 231}.to_json,
                  :headers => {"Content-Type"=> "application/json"})
    expect(@client.get_credit).to eql(231)
    expect_requested(:get, "https://app.gosms.cz/api/v1/")
  end

  it "gets testing info" do
    stub_request(:post, "https://app.gosms.cz/api/v1/messages/test").
         to_return(:status => 200,
                   :body => test_info_body("Hello"),
                   :headers => {"Content-Type"=> "application/json"})

    result = @client.test_send "Hello", 123456789
    expect_requested(:post, "https://app.gosms.cz/api/v1/messages/test")
    expect(result.price).to eql(1.452)
    expect(result.is_test).to eql(true)
  end

  it "will throw exception on 400 and 500" do
    [400,401,403,404,500].each do |code|
      stub_error(code)
      expect { @client.test_send "Hello", "123456789" }.to raise_error(GosmsClient::Error)
    end
  end

  it "will send sms" do
    stub_request(:post, "https://app.gosms.cz/api/v1/messages").
         to_return(:status => 201,
                   :body => {
                     "recipients": {
                       "invalid": [] },
                     "link": "/api/v1/messages/42"}.to_json,
                   :headers => {"Content-Type"=> "application/json"})
    response = @client.send("Hello", "123456789")
    expect_requested(:post, "https://app.gosms.cz/api/v1/messages")
    expect(response.link).to eq("/api/v1/messages/42")
  end

end
