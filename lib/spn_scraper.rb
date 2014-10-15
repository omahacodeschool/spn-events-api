require 'nokogiri'
require 'open-uri'

module SpnScraper
  
  def self.scrape
    page_num = 1
    url = "http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=#{page_num}&tribe_event_display=list"
    while OpenURI::HTTPError != '404 Not Found' do
      page_num += 1
      page = Nokogiri::HTML(open(url))
      
      page.css('.vevent').each do |event|
        Event.create!(
          name: SpnScraper.event_name(event), 
          date: SpnScraper.event_date(event),
          location: SpnScraper.address(event))
      end
    end
  end
  
  
  def self.event_name(event)
    event.css('.url').text.strip
  end
  
  def self.event_url(event)
    event.css('.vevent')[0].css('.url')[0]['href']
  end
  
  def self.event_date(event)
    event.css('.dtstart')[0].children[0].text
  end
  
  def self.event_end(event)
    event.css('.vevent')[0].css('.dtend')[0].children.text    
  end
  
  def self.event_author(event)
    event.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.author').text    
  end
  
  def self.event_address(event)
    event.css('.tribe-events-venue-details')[0].children.css('.street-address').text    
  end
  
  def self.event_state(event)
    self.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.region').text    
  end
  
  def self.event_zip_code(event)
    event.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.postal-code').text    
  end
  
  def self.event_description(event)
    event.css('.vevent')[0].css('.description')[0].css('p').text
  end    
end