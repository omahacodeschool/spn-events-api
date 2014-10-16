module Api
  module V1
    class EventsController < ActionController::API
      def all_events
        @all_events = Event.all
        render json: @all_events
      end
      
      def spn_events
        @spn_events = Event.where(event_origin: 'Silicon Prairie News')
        render json: @spn_events
      end
      
      def tech_omaha_events
        @tech_omaha_events = Event.where(event_origin: 'Tech Omaha')
        render json: @tech_omaha_events
      end
      
      def startup_lincoln_events
        @startup_lincoln_events = Event.where(event_origin: 'Startup Lincoln')
        render json: @startup_lincoln_events
      end
      
      def events_near
        result = "98.190.180.221"
        loc = Geocoder.coordinates(result)
        @near_events = Event.near(loc, params[:number])
        render json: @near_events
      end
    end
  end
end