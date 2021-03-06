class Api::V1::AuthController < ApplicationController
    wrap_parameters :user, include: [:email, :password]
    skip_before_action :authorized, only: [:create, :logged_in]
    
    def create
        @user = User.find_by(email: user_params[:email])
        if @user && @user.authenticate(user_params[:password])
            token = encode_token({user_id: @user.id})
            render json: { user: UserSerializer.new(@user), jwt: token }, status: :accepted
        else
            render json: { message: "Email or Password Invalid" }, status: :unauthorized
        end
    end

    def logged_in
        if current_user
            render json: current_user
        else
            render json: { error: "Login Required" }
        end
    end

    def destroy
        if current_user
            current_user = nil
            render json: { message: "Successfully Logged Out" }, status: :accepted
        else
            render json: { error: "Logout Failed" }, status: :not_acceptable
        end
    end

    private
    
    def user_params
        params.require(:user).permit(:email, :password)
    end
end