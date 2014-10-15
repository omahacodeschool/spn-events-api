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
          event_name: SpnScraper.event_name(event), 
          event_date: SpnScraper.event_date(event),
          event_address: SpnScraper.event_address(event),
          event_url: SpnScraper.event_url(event),
          event_end: SpnScraper.event_end(event),
          event_author: SpnScraper.event_author(event),
          event_zip_code: SpnScraper.event_zip_code(event),
          event_description: SpnScraper.event_description(event),
          event_state: SpnScraper.event_state(event),
          event_origin: 'Silicon Prairie News'
          )
      end
    end
  end
  
  
  def self.event_name(event)
    event.css('.url').text.strip
  end
  
  def self.event_url(event)
    event.css('.url')[0]['href']
  end
  
  def self.event_date(event)
    event.css('.dtstart')[0].children[0].text
  end
  
  def self.event_end(event)
    event.css('.dtend')[0].children.text    
  end
  
  def self.event_author(event)
    event.css('.tribe-events-venue-details')[0].children.css('.author').text    
  end
  
  def self.event_address(event)
    event.css('.tribe-events-venue-details')[0].children.css('.street-address').text    
  end
  
  def self.event_state(event)
    event.css('.tribe-events-venue-details')[0].children.css('.region').text    
  end
  
  def self.event_zip_code(event)
    event.css('.tribe-events-venue-details')[0].children.css('.postal-code').text    
  end
  
  def self.event_description(event)
    event.css('.description')[0].css('p').text
  end    
end