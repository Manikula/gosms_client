require 'gosms_client/configuration'
require 'gosms_client/version'
require 'gosms_client/oauth2'
require 'gosms_client/gosms_client'
require 'gosms_client/error'
require 'gosms_client/message_details'

module GosmsClient
=begin
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
=end
end
