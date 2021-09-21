class Api::V1::UsersController < ApplicationController
    wrap_parameters :user, include: [:username, :email, :password]
    skip_before_action :authorized, only: [:create]

    def create
        @user = User.new(user_params)
        if @user.save
            @token = encode_token(user_id: @user.id)
            render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
        else
            render json: { error: @user.errors.full_messages }, status: :not_acceptable
        end
    end

    def show
        likes_count = current_user.liked_images.count
        comments_count = current_user.commented_images.count
        render json: { user: UserSerializer.new(current_user), likesCount: likes_count, commentsCount: comments_count }
    end

    private

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
end
