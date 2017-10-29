class UserSessionsController < ApplicationController
  before_filter :require_user, except: [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)
    if @user_session.save
      flash[:success] = "Welcome back #{current_user.first_name}!"
      create_cache
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:success] = 'Goodbye!'
    redirect_to root_path
  end

  private

  def create_cache
    history = {}
    current_user.histories.where(random: true).each do |row|
      history[row.city] = {} unless history[row.city]
      history[row.city][row.state] = {} unless history[row.city][row.state]
      history[row.city][row.state][row.country] = true
    end
    Redis.new.hset(
      SearchController::RANDOM_HISTORY,
      current_user.email,
      history.to_json
    )
  end

  def user_session_params
    params.require(:user_session).permit(:email, :password, :remember_me)
  end
end
