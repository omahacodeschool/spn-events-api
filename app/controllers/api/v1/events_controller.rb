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
    end
  end
end