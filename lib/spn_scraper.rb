require 'nokogiri'
require 'open-uri'

module SpnScraper
  
  def self.run_spn_scrape
    url = "http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=#{page_num}&tribe_event_display=list"
    page_num = 1
    while OpenURI::HTTPError != '404 Not Found' do
      
      page = Nokogiri::HTML(open(url))
      
      page.css('.vevent').each do |event|
        SpnEvent.create!(
          name: event.event_name, 
          date: event.event_date,
          location: event.address)
      end
      page_num += 1
    end
  end
  
  
  def event_name
    css('.url').text.strip
  end
  
  def event_url
    self.page.css('.vevent')[0].css('.url')[0]['href']
  end
  
  def event_date
    css('.dtstart')[0].children[0].text
  end
  
  def event_end
    page.css('.vevent')[0].css('.dtend')[0].children.text    
  end
  
  def author
    page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.author').text    
  end
  
  def address
    css('.tribe-events-venue-details')[0].children.css('.street-address').text    
  end
  
  def state
    page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.region').text    
  end
  
  def zip_code
    page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.postal-code').text    
  end
  
  def description
    page.css('.vevent')[0].css('.description')[0].css('p').text
  end    
end