class UsersController < ApplicationController
    wrap_parameters :user, include: [:username, :email, :password]

    def create
        @user = User.new(user_params)
        binding.pry
        if @user.save

        end
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
      end
end
