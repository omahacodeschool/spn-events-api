desc "Create Events"
task :create_events => :environment do
  require 'nokogiri'
  require 'open-uri'
  page  = Nokogiri::HTML(open('http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=1&tribe_event_display=past'))
  names = page.css('.url')
  dates = page.css('.time-details')
  locs  = page.css('.tribe-events-venue-details')
  
  names.each do |name|
    SpnEvent.create!(name: name)
  end
  
  dates.each do |date|
    SpnEvent.update_attributes(date: date)
  end
  
  locs.each do |loc|
    SpnEvent.update_attributes(locatiion: loc)
  end
end