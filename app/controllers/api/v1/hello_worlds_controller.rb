module Api
  module V1
    class HelloWorldsController < ApplicationController
      skip_before_action :verify_authenticity_token
      def index
        render json: { message: 'hello world' }
      end
    end
  end
end
