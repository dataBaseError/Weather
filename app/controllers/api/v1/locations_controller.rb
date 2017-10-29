module Api
  module V1
    class LocationsController < ApplicationController
      def states
        if params['country']
          states = CS.get(params['country'].to_sym).to_a.map(&:reverse)
          render json: states.to_json
        else
          render json: [].to_json
        end
      end

      def cities
        if params['country'] && params['state']
          cities = CS.get(params['country'].to_sym, params['state'].to_sym)

          # Bug present in CS library (using ! methods will override lib data structure)
          cities = cities.map do |city|
            [city, city]
          end

          render json: cities.to_json
        else
          render json: [].to_json
        end
      end
    end
  end
end
