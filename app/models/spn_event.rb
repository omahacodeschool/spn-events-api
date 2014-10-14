class SpnEvent < ActiveRecord::Base
  attr_accessible :date, :location, :name, :time, :url
  
  validates :name, :uniqueness => {:scope => :date}
  require 'nokogiri'
  require 'open-uri'
  
  def self.run_spn_scrape
    page_num = 1
    while OpenURI::HTTPError != '404 Not Found' do
      page = Nokogiri::HTML(open("http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=#{page_num}&tribe_event_display=list"))        
      page_num += 1    
      page.css('.vevent').each do |event|
        binding.pry
        SpnEvent.create!(
          name: event.event_name, 
          date: event.event_date,
          location: event.address)
      end
    end
  end
  
  
  def event_name(event)
    event.css.('.url').text.strip
  end
  
  def event_url
    self.page.css('.vevent')[0].css('.url')[0]['href']
  end
  
  def event_date
    self.css('.dtstart')[0].children[0].text
  end
  
  def event_end
    page.css('.vevent')[0].css('.dtend')[0].children.text    
  end
  
  def author
    page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.author').text    
  end
  
  def address
    self.css('.tribe-events-venue-details')[0].children.css('.street-address').text    
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
