class PreferencesController < ApplicationController
  before_action :require_user

  def details
    @countries = CS.countries.to_a.map(&:reverse)

    if current_user.location?
      @country = current_user.country
      @state = current_user.state
      @city = current_user.city

      @states = CS.get(@country.to_sym).to_a.map(&:reverse)
      @cities = CS.get(@country.to_sym, @state.to_sym)
    end
  end

  def details_update
    details = detail_session_params
    current_user.country = details[:country]
    current_user.state = details[:state]
    current_user.city = details[:city]
    if current_user.save
      flash[:success] = 'Saved'
      redirect_to root_path
    else
      render :details
    end
  end

  private

  def detail_session_params
    params.require(:detail).permit(:country, :state, :city)
  end
end
