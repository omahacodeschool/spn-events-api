class Event < ActiveRecord::Base
  attr_accessible :event_date, :event_address, :event_name, :event_end, :event_url, :event_author, :event_state, :event_zip_code, :event_description, :event_origin, :latitude, :longitude
  
  extend Geocoder::Model::ActiveRecord

  geocoded_by :full_address
  after_validation :geocode
  
  validates :event_name, :uniqueness => {:scope => :event_date}
  
  def full_address
    "#{event_address} #{event_state}"
  end
  
  def self.same_week?
    rest_of_weeks_events = []
    Event.all.each do |event|
      if Time.now <= event.event_date.to_s.slice(0..9) && event.event_date.to_s.slice(0..9) < Time.now.end_of_week
        rest_of_weeks_events << event
      else  
        next
      end  
    end
    rest_of_weeks_events
  end
  
  def self.week_of_events
    weeks_events = []
    Event.all.each do |event|
      if event.event_date.to_s.slice(0..9).between?(Time.now.beginning_of_week, Time.now.end_of_week)
        weeks_events << event
      else
        next
      end
    end
    weeks_events
  end
  
  def self.events_today
    todays_events = []
    Event.all.each do |event|
      if event.event_date.to_s.slice(0..9) == Time.now
        todays_events << event
      else
        next
      end
    end
    todays_event
  end
end
