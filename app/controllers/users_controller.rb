class UsersController < ApplicationController

  def create
    User.create!(user_params)
    render json: {message: 'Account created'}, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end
end
