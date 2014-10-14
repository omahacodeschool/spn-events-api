desc "Create Events"
task :create_events => :environment do
  require 'nokogiri'
  require 'open-uri'
  page_num = 1
  page  = Nokogiri::HTML(open("http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=#{page_num}&tribe_event_display=list"))
  names = page.css('.url')
  dates = page.css('.time-details')
  locs  = page.css('.tribe-events-venue-details')
  
  names.zip(dates, locs) do |name, date, loc|
    SpnEvent.create!(name: name.attributes['title'].value, date: date.text.strip, location: loc.text.strip.gsub("\n", ''))
  end
end