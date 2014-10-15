class Event < ActiveRecord::Base
  attr_accessible :event_date, :event_address, :event_name, :event_end, :event_url, :event_author, :event_state, :event_zip_code, :event_description, :event_origin, :latitude, :longitude
  
  extend Geocoder::Model::ActiveRecord

  reverse_geocoded_by :event_address, :event_state
  after_validation :reverse_geocode
  
  validates :event_name, :uniqueness => {:scope => :event_date}
  
  # def coordinates
  #   b
  #
  # end
  #
  # def location
  #   b = []
  #   b << latitude
  #   b << longitude
  #   Geocoder.coordinates(b)
  # end
  #
  # def coords
  #   a = Geocoder.coordinates(name)
  #   lat = a[0]
  #   long = a[1]
  #   update(latitude: lat)
  #   update(longitude: long)
  # end
  #
  # def address_coords(address, state)
  #   [address, state].compact.join(', ')
  # end
end
