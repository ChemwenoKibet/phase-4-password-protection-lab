# class UsersController < ApplicationController
#   def create
#     @user = User.new(user_params)
#     if @user.save
#       session[:user_id] = @user.id
#       render json: @user, status: :created
#     else
#       render json: @user.errors, status: :unprocessable_entity
#     end
#   end

#   def show
#     if current_user
#       render json: current_user
#     else
#       render json: { error: "Not authenticated" }, status: :unauthorized
#     end
#   end

#   private

#   def user_params
#     params.require(:user).permit(:username, :password)
#   end
# end

class UsersController < ApplicationController
  before_action :authorize, only:[:show]
  def create
    user = User.create(user_params)
    if user.valid?
     session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
      user = User.find(session[:user_id])
      render json: user
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

  def authorize
      return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end
end
