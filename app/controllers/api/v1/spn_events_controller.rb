module Api
  module V1
    class EventsController < ActionController::API
      def index
        @events = SpnEvent.all
        render json: @events
      end
    end
  end
end