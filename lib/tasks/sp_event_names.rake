# Creates SpnEvent objects with scraped info from SPN Event Calendar.

desc "Create SPN Events"
task :create_spn_events => :environment do
  require 'nokogiri'
  require 'open-uri'
  
  # Page counter. 
  page_num = 1
  
  # While loop with conditional to end when 404 status code is received.
  while OpenURI::HTTPError != '404 Not Found' do
    
    # Initial SPN Event page.
    page  = Nokogiri::HTML(open("http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=#{page_num}&tribe_event_display=list"))
    
    # Name of event grabbed from .url css selector.
    names = page.css('.url')
    
    # Date/Time of event grabbed from .time-details css selector.
    dates = page.css('.time-details')
    
    # Location of event grabbed from .tribe-events-venue-details css selector.
    locs  = page.css('.tribe-events-venue-details')
  
    # Call zip method on names passing in dates and locations to merge arrays.
    names.zip(dates, locs) do |name, date, loc|
      
      # Creates SpnEvent objects and strips/subs out \n and \t characters.
      SpnEvent.create!(name: name.attributes['title'].value, date: date.text.strip, location: loc.text.strip.gsub("\n", ''))
    end
    
    # Increments page counter by one.
    page_num += 1
  end
end
