class SpnEventsController < ActionController::API
  
  # Event Page
  # page = Nokogiri::HTML(open('http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=1&tribe_event_display=past'))
    
  # Event Name
  # page.css('.url').each do |item|
  # end
  
  # Event Date/Time Details
  # page.css('.time-details').each do |item|
  # end
  
  # Event Location Details
  # page.css('.tribe-events-venue-details').each do |item|
  # end
  
  # Mechanize 
  # agent = Mechanize.new
  # page = agent.get('http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=1&tribe_event_display=list')
  # next_page = agent.page.link_with(:text => "Next Events »").click
end