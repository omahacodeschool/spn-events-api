class Event < ActiveRecord::Base
  attr_accessible :event_date, :event_address, :event_name, :event_end, :event_url, :event_author, :event_state, :event_zip_code, :event_description, :event_origin, :latitude, :longitude
  
  extend Geocoder::Model::ActiveRecord

  geocoded_by :full_address
  after_validation :geocode
  
  validates :event_name, :uniqueness => {:scope => :event_date}
  
  def full_address
    "#{event_address} #{event_state}"
  end
  
  def self.spn_events
    spn_events = []
    spn_array = Event.where(event_origin: 'Silicon_Prairie_News').order(:event_date)
    spn_array.each do |event|
      binding.pry
      if Time.now.yesterday <= event.event_date.to_s.slice(0..9)
        spn_events << event
      else
        next
      end
    end
    spn_events
  end
  
  def self.lincoln_events
    lincoln_events = []
    lincoln_array = Event.where(event_origin: 'Startup_Lincoln')
    lincoln_array.each do |event|
      if Time.now.yesterday <= event.event_date.to_s.slice(0..9)
        lincoln_events << event
      else
        next
      end
    end
    lincoln_events
  end
  
  def self.tech_omaha_events
    tech_omaha_events = []
    tech_omaha_array = Event.where(event_origin: 'Tech_Omaha')
    tech_omaha_array.each do |event|
      if Time.now.yesterday <= event.event_date.to_s.slice(0..9)
        tech_omaha_events << event
      else
        next
      end
    end
    tech_omaha_events
  end
  
  def self.all_events
    all_events = []
    Event.all.each do |event|
      if Time.now <= event.event_date.to_s.slice(0..9)
        all_events << event
      else
        next
      end
    end
    all_events
  end
  
  def self.same_week
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
  
  def self.events_this_month
    months_events = []
    Event.all.each do |event|
      if event.event_date.to_s.slice(5..6) == Time.now.month.to_s
        months_events << event
      else
        next
      end
    end
    months_events
  end
  
  def self.events_by_month(month)
    events_for_month = []
    Event.all.each do |event|
      if event.event_date.to_s.slice(5..6) == month.to_s
        events_for_month << event
      else
        next
      end
    end
    events_for_month
  end
  
  def self.past_events
    past_events = []
    Event.all.each do |event|
      if event.event_date.to_s.slice(0..9) < Time.now
        past_events << event
      else
        next
      end
    end
    past_events
  end
end
