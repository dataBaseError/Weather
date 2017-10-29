module Api
  module V1
    class WeathersController < ApplicationController
      def search
        weather_search = params['q']

        # http://api.openweathermap.org/data/2.5/weather?q=toronto&APPID=97937861021e10ba1f3e53737b8b73cd
        response = Excon.get(create_uri('weather', weather_search))

        render json: response.body
      end

      private

      def create_uri(type, parameter)
        "#{SearchController::BASE_URI}#{SearchController::VERSION}/#{type}?q=#{parameter}#{SearchController::API_KEY}"
      end
    end
  end
end
