require 'oauth2'
module OAuth2
  class Response
    @@content_types['application/problem+json'] = :json
  end
end
