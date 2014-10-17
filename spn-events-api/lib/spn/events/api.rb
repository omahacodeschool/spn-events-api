require "spn/events/api/version"
require "HTTParty"

module Spn
  module Events
    module Api
      class Event
        def initialize(hash)
          @id                = hash['id']
          @bearing           = hash['bearing']
          @distance          = hash['distance']
          @event_address     = hash['event_address']
          @event_author      = hash['event_author']
          @event_date        = hash['event_date']
          @event_description = hash['event_description']
          @event_end         = hash['event_end']
          @event_name        = hash['event_name']
          @event_origin      = hash['event_origin']
          @event_state       = hash['event_state']
          @event_url         = hash['event_url']
          @event_zip_code    = hash['event_zip_code']
          @latitude          = hash['latitude']
          @longitude         = hash['longitude']
        end
        
        def self.all_events
          all_events = []
          response = HTTParty.get("http://event-api.herokuapp.com/api/v1/all_events")
          response.each do |hash|
            all_events << Event.new(hash)
          end
          all_events
        end
      end
    end
  end
end
