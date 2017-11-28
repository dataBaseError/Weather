class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      flash[:success] = 'Account registered!'
      redirect_to root_path
    else
      render :new
    end
  end

  def password_reset
    @user = current_user
  end

  def set_password
    @user = User.new(users_params)
    if users_params['password'] != users_params['password_confirmation']
      @user.errors.add(
        :password,
        :mismatch,
        message: 'Password does match password confirmation'
      )
    end
    @user = current_user
    @user.password = users_params['password']
    @user.password_confirmation = users_params['password_confirmation']

    if @user.save
      flash[:success] = 'Reset Successful!'
      redirect_to :root
    else
      render :password_reset
    end
  end

  private

  def users_params
    params.require(:user).permit(
      :first_name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
