class ApplicationController < ActionController::API
    def encode_token(payload)
        JWT.encode(payload, ENV["SESSION_SECRET"])
    end

    def decoded_token(token)
        JWT.decode(token, ENV["SESSION_SECRET"])[0]
    end
end
