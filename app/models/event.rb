class Event < ActiveRecord::Base
  attr_accessible :event_date, :event_address, :event_name, :event_end, :event_url, :event_author, :event_state, :event_zip_code, :event_description, :event_origin, :latitude, :longitude
  
  extend Geocoder::Model::ActiveRecord

  geocoded_by :full_address
  after_validation :geocode
  
  validates :event_name, :uniqueness => {:scope => :event_date}
  
  def full_address
    "#{event_address} #{event_state}"
  end
end
