module Api
  module V1
    class EventsController < ActionController::API
      def all_events
        @all_events = Event.all_events
        render json: @all_events
      end
      
      def spn_events
        @spn_events = Event.where(event_origin: 'Silicon_Prairie_News')
        render json: @spn_events
      end
      
      def tech_omaha_events
        @tech_omaha_events = Event.where(event_origin: 'Tech_Omaha')
        render json: @tech_omaha_events
      end
      
      def startup_lincoln_events
        @startup_lincoln_events = Event.where(event_origin: 'Startup_Lincoln')
        render json: @startup_lincoln_events
      end

      def events_near
        result = request.location
        loc = Geocoder.coordinates(result.data['ip'])
        @near_events = Event.near(loc, params[:number])
        render json: @near_events
      end

      def events_today
        @todays_events = Event.events_today
        render json: @todays_events
      end
      
      def events_all_week
        @events_all_week = Event.week_of_events
        render json: @events_all_week
      end

      def events_rest_of_week
        @events_rest_of_week = Event.same_week
        render json: @events_rest_of_week
      end
      
      def events_this_month
        @events_this_month = Event.events_this_month
        render json: @events_this_month
      end
      
      def events_by_month
        @events_by_month = Event.events_by_month(params[:month])
        render json: @events_by_month
      end
    end
  end
end