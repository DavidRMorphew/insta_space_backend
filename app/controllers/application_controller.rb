class ApplicationController < ActionController::API
    def encode_token(payload)
        JWT.encode(payload, ENV["SESSION_SECRET"], ‘HS256’)
    end

    def decoded_token
        if request.headers['Authorization']
            token = request.headers['Authorization'].split(' ')[1]
            begin
                JWT.decode(token, ENV["SESSION_SECRET"], true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
        end
    end

    def user_id
        decoded_token[0]['user_id'] if decoded_token
    end

    def current_user
        @user ||= User.find_by(id: user_id) if user_id
    end

    def logged_in?
        !!current_user
    end
end
