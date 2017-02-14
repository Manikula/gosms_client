require 'spec_helper'
require 'gosms_client'

describe GosmsClient::Error do

  describe "Information inside" do
    it "can show basic info" do
      err = GosmsClient::Error.new(:reason, "something")
      expect(err.to_s).to eql "reason: something"
    end

    it "can handle string in errors" do
      err = GosmsClient::Error.new(:reason, {
        "status" => 400,
        "detail" => "Something bad",
        "errors" => "Some errors"})
      expect(err.to_s).to eql "reason: Something bad"
      expect(err.status).to eql 400
      expect(err.detail).to eql "Something bad"
      expect(err.errors).to eql "Some errors"
    end

    it "can handle array in errors" do
      err = GosmsClient::Error.new(:reason, {
        "status" => 500,
        "detail" => "Something bad",
        "errors" => ["err1","err2","err3"]})
      expect(err.to_s).to eql "reason: Something bad"
      expect(err.status).to eql 500
      expect(err.detail).to eql "Something bad"
      expect(err.errors.class).to eql Array
      expect(err.errors.count).to eql 3
      expect(err.errors[1]).to eql "err2"
    end

    it "can handle Oauth2 gem error hash" do
      err = GosmsClient::Error.new(:reason, {
        "error" => "invalid_client",
        "error_description" => "The client credentials are invalid"
      })
      expect(err.to_s).to eql "reason: The client credentials are invalid"
      expect(err.detail).to eql "The client credentials are invalid"
      expect(err.errors).to eql "invalid_client"
    end
  end

  describe "Wierd reasons and details" do

    it "can handle non string or hash details" do
      err = GosmsClient::Error.new(:reason, :details)
      expect(err.to_s).to eql "reason: details"

      err = GosmsClient::Error.new(:reason, [])
      expect(err.to_s).to eql "reason: []"

      err = GosmsClient::Error.new(:reason, 123456)
      expect(err.to_s).to eql "reason: 123456"
    end

    it "will not accept non symbols as a reason" do
      err = GosmsClient::Error.new("reason", "something")
      expect(err.to_s).to eql "Unknown reason: something"

      err = GosmsClient::Error.new(['reason'], "something")
      expect(err.to_s).to eql "Unknown reason: something"

      err = GosmsClient::Error.new(123456, "something")
      expect(err.to_s).to eql "Unknown reason: something"
    end

    it "can handle nils" do
      err = GosmsClient::Error.new(:reason, nil)
      expect(err.to_s).to eql "reason: Unknown detail"

      err = GosmsClient::Error.new(nil, "something")
      expect(err.to_s).to eql "Unknown reason: something"

      err = GosmsClient::Error.new(nil, nil)
      expect(err.to_s).to eql "Unknown reason: Unknown detail"
    end

  end
end
