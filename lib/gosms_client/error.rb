module GosmsClient
  class Error < StandardError

    attr_reader :status, :description, :errors, :reason

    def initialize(reason, response)
      if response.is_a?(Hash)
        @status = response['status']
        @detail = response['detail']
        @errors = response['errors']
      else
        @detail = response
      end
      @reason = reason
      super(description)
    end

    def to_s
      @reason.to_s + ": " + @detail      
    end
  end
end
