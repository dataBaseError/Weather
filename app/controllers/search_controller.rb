class SearchController < ApplicationController
  before_action :require_user
  def index
    local_weather
  end

  RANDOM_HISTORY = 'random_history'

  BASE_URI = 'http://api.openweathermap.org/data/'
  VERSION = '2.5'
  API_KEY = ENV['WEATHER_API_KEY']

  def search
    local_weather
    country = params['search']
    state, city = nil
    country, state, city = generate_search_parameter if params[:random]

    unless country.empty?
      history = request_weather(
        country,
        state,
        city,
        params[:random] == 'Random'
      )
      @weather_type = history.weather_type
      @tempature = history.tempature
      @country = history.country
      @city = history.city
    end
  end

  private

  def local_weather
    return nil unless current_user

    if current_user.country && current_user.state && current_user.city
      history = request_weather(
        current_user.country,
        current_user.state,
        current_user.city,
        false
      )
      @user_weather_type = history.weather_type
      @user_tempature = history.tempature
      history.state = current_user.state
      history.save!
    end
  end

  def generate_search_parameter
    country, state, city = nil
    loop do
      country = Hash[CS.get.to_a.sample(1)]
      state = Hash[CS.get(country.keys.first).to_a.sample(1)]
      cities = CS.get(country.keys.first, state.keys.first)

      city = ''
      city = cities.sample unless cities.empty?

      break unless in_history?(country.values.first, state.values.first, city)
    end
    [country, state, city]
  end

  def in_history?(country, state, city)
    history = Redis.new.hget(RANDOM_HISTORY, current_user.email)
    return check_history(country, state, city, JSON.parse(history)) if history
    false
  end

  def check_history(country, state, city, history)
    history[country] && history[country][state] && history[country][state][city]
  end

  def request_weather(country, state, city, random = false)
    weather_query = search_string(country, state, city)
    response = Excon.get(create_uri('weather', weather_query))
    body = JSON.parse(response.body)

    h = History.create!(
      search_param: weather_query,
      city: body['name'],
      state: state,
      country: body['sys']['country'],
      weather_type: body['weather'][0]['main'],
      tempature: kelvin_to_celsius(body['main']['temp']).round(2),
      random: random,
      user: current_user
    )

    add_to_cache(h.country, h.state, h.city)
    h
  end

  def add_to_cache(country, state, city)
    redis = Redis.new
    history = redis.hget(RANDOM_HISTORY, current_user.email)
    if history
      history =  JSON.parse(history)
    else
      history = {}
    end
    history[country] = {} unless history[country]
    history[country][state] = {} unless history[country][state]
    history[country][state][city] = true

    redis.hset(RANDOM_HISTORY, current_user.email, history.to_json)
  end

  def search_string(country, state, city)
    URI.encode("#{city} #{state} #{country}")
  end

  def kelvin_to_celsius(kelvin)
    kelvin - 273.15
  end

  def create_uri(type, parameter)
    "#{BASE_URI}#{VERSION}/#{type}?q=#{parameter}#{API_KEY}"
  end
end
