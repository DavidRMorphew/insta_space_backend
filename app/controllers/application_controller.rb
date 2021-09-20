class ApplicationController < ActionController::API
    before_action :authorized
    # before_action :cors_set_access_control_headers

    # def cors_preflight_check
    #     if request.method == 'OPTIONS'
    #         cors_set_access_control_headers
    #         render text: '', content_type: 'text/plain'
    #     end
    # end

    def encode_token(payload)
        JWT.encode(payload, ENV["SESSION_SECRET"])
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
    end

    def user_id
        decoded_token[0]['user_id'] if decoded_token
    end

    def current_user
        if user_id
            @user ||= User.find_by(id: user_id)
        end
    end

    def logged_in?
        !!current_user
    end
    
    def authorized
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end

    # protected

    # def cors_set_access_control_headers
    #     response.headers['Access-Control-Allow-Origin'] = '*'
    #     response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    #     response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-User-Token, X-User-Email'
    #     response.headers['Access-Control-Max-Age'] = '1728000'
    # end
end
