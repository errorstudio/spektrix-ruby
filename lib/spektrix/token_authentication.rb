module Spektrix
  class TokenAuthentication < Faraday::Middleware
    def call(env)
  #    env[:request_headers]["X-API-Token"] = RequestStore.store[:my_api_token]
      puts env
      @app.call(env)
    end
  end
end
