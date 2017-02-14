module GosmsClient
  class Error < StandardError

    attr_reader :status, :detail, :errors, :reason

    def initialize(reason, response)
      if response.is_a?(Hash)
        @status = response['status']
        @detail = response['detail'] || response["error_description"]
        @errors = response['errors'] || response["error"]
      else
        @detail = response || "Unknown detail"
      end
      @reason = reason.is_a?(Symbol)? reason : "Unknown reason"
    end

    def to_s
      @reason.to_s + ": " + @detail.to_s
    end
  end
end
