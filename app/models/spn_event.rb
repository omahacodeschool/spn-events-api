class SpnEvent < ActiveRecord::Base
  attr_accessible :date, :location, :name, :time, :url
  validates :name, :uniqueness => {:scope => :date}
  
end
