require 'nokogiri'
require 'open-uri'
require 'chronic'
require 'geocoder'
require 'mechanize'

# Web Scraper for Silicon Prairie News
module SpnScraper
  
  # TODO TomDoc Methods
  # TODO Refactor
  # TODO Clean up outdate events
  
  # Scraper for Silicon Prairie News Events Calendar
  #
  # Scrape method loops over all events, incrementing by one to go to the next page.
  # Scraper will automatically end when it does not receive a '200' status code.
  def self.scrape
    page_num = 1
    url = "http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=#{page_num}&tribe_event_display=list"
    while open(url).status[0] == '200' do
      page = Nokogiri::HTML(open(url))
      
      page.css('.vevent').each do |event|
        Event.create(
          event_name:        SpnScraper.event_name(event), 
          event_date:        SpnScraper.event_date(event),
          event_address:     SpnScraper.event_address(event),
          event_url:         SpnScraper.event_url(event),
          event_end:         SpnScraper.event_end(event),
          event_author:      SpnScraper.event_author(event),
          event_zip_code:    SpnScraper.event_zip_code(event),
          event_description: SpnScraper.event_description(event),
          event_state:       SpnScraper.event_state(event),
          event_origin:      'Silicon_Prairie_News'
          )
      end
      page_num += 1
      url = "http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=#{page_num}&tribe_event_display=list"
    end
  end
  
  # Date formatter, formats date for consistent conversion.
  #
  # date_time - The raw date/time string to be formatted.
  #
  # Examples
  #
  #   SpnScraper.separate_date("2014-10-16CDT12:00")
  #   # => ["2014-10-16 12:00", "CDT"]
  #
  # Returns Array of separated date_time string parts.
  def self.separate_date(date_time)
    sep_time = []
    time_zone = /.*([a-zA-Z]{3,}).*/.match(date_time)[1]
    new_date = date_time.gsub(/[a-zA-Z]{3,}/, " ")
    sep_time << new_date
    sep_time << time_zone
    sep_time
  end
  
  # Date formatter, formats date for consistent conversion
  #
  # date_array - Array containing separated datetime
  #
  # Examples
  #
  #   SpnScraper.normalize_date(["2014-10-16 12:00", "CDT"])
  #   # => "2014-10-16 12:00CDT"
  #
  # Returns formatted date/time String.
  def self.normalize_date(date_array)
    adjusted_date = date_array[0] + date_array[1]
    adjusted_date
  end
  
  # Specific content scraping methods, retrieving data relevant to method name.
  #
  # event - parsed nokogiri Object
  #
  # Examples
  #
  #   SpnScraper.event_name(event)
  #   # => ''
  #   SpnScraper.event_name(event)
  #   # => 'Event Name'
  #
  # Returns an empty String or String of text.
  def self.event_name(event)
    if event.css('.url').nil?
      ''
    else
      event.css('.url').text.strip
    end
  end
  
  def self.event_url(event)
    if event.css('.url')[0].nil?
      ''
    else
      event.css('.url')[0]['href']
    end
  end
  
  def self.event_date(event)
    if event.css('.time-details').children.children[1].nil?
      ''
    else
      date_time = event.css('.time-details').children.children[1].attributes['title'].value
      normalized_date = SpnScraper.normalize_date(SpnScraper.separate_date(date_time))
      
      event_date = Chronic.parse(normalized_date)
    end
    event_date
  end
  
  def self.event_end(event)
    if event.css('.time-details').children.children[3].nil?
      ''
    else
      date_time = event.css('.time-details').children.children[3].attributes['title'].value
      normalized_date = SpnScraper.normalize_date(SpnScraper.separate_date(date_time))
      
      event_end = Chronic.parse(normalized_date)
    end
    event_end
  end
  
  def self.event_author(event)
    event_author = event.css('.tribe-events-venue-details')[0].children.css('.author')
    if event_author.nil?    
      ''
    else
      event_author.text    
    end
  end
  
  def self.event_address(event)
    if event.css('.tribe-events-venue-details')[0].children.css('.street-address').nil?
      ''
    else
      event.css('.tribe-events-venue-details')[0].children.css('.street-address').text    
    end
  end
  
  def self.event_state(event)
    if event.css('.tribe-events-venue-details')[0].children.css('.region').nil?   
      ''
    else
      event.css('.tribe-events-venue-details')[0].children.css('.region').text
    end
  end
  
  def self.event_zip_code(event)
    if event.css('.tribe-events-venue-details')[0].children.css('.postal-code').nil?    
      ''
    else
      event.css('.tribe-events-venue-details')[0].children.css('.postal-code').text    
    end
  end
  
  def self.event_description(event)
    if event.css('.description')[0].nil?
      ''
    else
      event.css('.description')[0].css('p').text
    end
  end    
end