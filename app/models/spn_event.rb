class SpnEvent < ActiveRecord::Base
  attr_accessible :date, :location, :name, :time, :url
  
  # Takes a url as a parameter and returns a Nokogiri object with the page contents
  
end
