class ApplicationController < ActionController::API
    before_action :authorized

    def encode_token(payload)
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decoded_token
        if request.headers['Authorization']
            token = request.headers['Authorization'].split(' ')[1]
            begin
                JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def user_id
        decoded_token[0]['user_id'] if decoded_token
    end

    def current_user
        if user_id
            current_user = User.find_by(id: user_id)
        end
    end

    def logged_in?
        !!current_user
    end
    
    def authorized
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end
end
