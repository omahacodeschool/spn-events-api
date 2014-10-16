module Api
  module V1
    class EventsController < ActionController::API
      def all_events
        @all_events = Event.all
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
      
      def spn_event_by_id
      end
      
      def events_near
        result = request.location
        loc = Geocoder.coordinates(result)
        @near_events = Event.near(loc, params[:number])
        render json: @near_events
      end
      
      def events_today
        date = Date.today
        events = Event.all
        @events_today = []
        events.each do |e|
          if e.event_date == date
            @events_today << e            
          end
        end
        render json: @events_today
      end
      
      def events_all_week
        count = 1
        date = Date.today
        events = Event.all
        @events_week = []
        while count < 8
          events.each do |e|
            if e.event_date.wday == date.wday
              @events_week << e
            end
          end
          count += 1
        end
        render json: @events_week
      end
    end
  end
end