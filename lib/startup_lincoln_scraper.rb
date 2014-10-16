require 'nokogiri'
require 'open-uri'
require 'chronic'
require 'geocoder'
require 'mechanize'

# Web Scraper for Startup Lincoln Calendar
module StartupLincolnScraper
  
  # TODO TEST TEST TEST  
  # TODO Clean up outdated Events
  # TODO Refactor
  
  # Scrape method generates Event Objects using dynamic months and years
  #
  # Iterates over links gathered through Mechanize.
  def self.scrape
    base_url   = "https://www.google.com/calendar/htmlembed?src=v33mkotgag28em0tjp25io556g@group.calendar.google.com&ctz=America/Chicago&dates="
    this_month = Time.now.month
    this_year  = Time.now.year
    agent      = Mechanize.new
    url1       = "#{base_url}#{this_year}#{this_month}01/#{this_year}#{StartupLincolnScraper.next_month(this_month)}01"
    url2       = "#{base_url}#{StartupLincolnScraper.next_year(this_year, StartupLincolnScraper.next_month(this_month))}#{StartupLincolnScraper.next_month(this_month)}01/#{this_year}#{StartupLincolnScraper.next_month(this_month + 1)}01&mode=MONTH"
    page1      = agent.get(url1)
    page2      = agent.get(url2)
    links      = StartupLincolnScraper.prep_links(page1) + StartupLincolnScraper.prep_links(page2)
    
    links.each do |link|
      clicked_link = link.click.parser
      Event.create(
        event_name:        StartupLincolnScraper.event_name(clicked_link),
        event_description: StartupLincolnScraper.event_description(clicked_link),
        event_date:        StartupLincolnScraper.event_date(clicked_link),
        event_end:         StartupLincolnScraper.event_end(clicked_link),
        event_address:     StartupLincolnScraper.event_location(clicked_link),
        event_origin:      'Startup_Lincoln')
    end
  end
  
  # Month incrementer, increases month value by one.
  #
  # month - The Integer month to be incremented.
  #
  # Examples
  #
  #   StartupLincolnScraper.next_month(12)
  #   # => '01'
  #   StartupLincolnScraper.next_month(11)
  #   # => '12'
  #
  # Returns the String value of month incremented by one.
  def self.next_month(month)
    next_month = month + 1
    if next_month == 13
      next_month = 1
    end
    
    if next_month < 10
      next_month = '0' + next_month.to_s
    else
      next_month = next_month.to_s
    end
    
    next_month
  end
  
  # Year incrementer, increases year value by one.
  #
  # year  - The Integer year to be incremented.
  # month - The Integer month to check for 12(December).
  #
  # Examples
  #
  #   StartupLincolnScraper.next_year(2014, 12)
  #   # => 2015
  #   StartupLincolnScraper.next_month(2014, 11)
  #   # => 2014
  #
  # Returns the Integer 2015 if month is 12(December) otherwise returns the given Integer year.
  def self.next_year(year, month)
    if month == 12
      next_year = year + 1
    else
      year
    end
  end
  
  # Link Array normalizer, slices off redundant page links.
  #
  # page - The pages Array of Mechanize link objects.
  #
  # Examples
  #
  #   StartupLincolnScraper.prep_links(page1)
  #   # => Array of Mechanize Link objects with the specified links removed.
  #
  # Returns Array of Mechanize Link Objects.
  def self.prep_links(page)
    links = page.links
    links.slice(5...(links.length - 1))
  end
  
  # Specific content scraping methods, retrieving data relevant to method name.
  #
  # link - parsed nokogiri Object
  #
  # Examples
  #
  #   StartupLincolnScraper.event_name(link)
  #   # => ''
  #   StartupLincolnScraper.event_name(link)
  #   # => 'Some Event in the Node'
  #
  # Returns an empty String or String of text.
  def self.event_name(link)
    if link.css('title').text.nil?
      ''
    else
      link.css('title').text
    end
  end
  
  def self.event_description(link)
    if link.css('div')[3].css('div')[1].children.nil?
      ''
    else
      link.css('div')[3].css('div')[1].children.text
    end
  end
  
  def self.event_date(link)
    if link.css('div')[4].css('td')[1].children[1].nil?
      '' 
    else
      link.css('div')[4].css('td')[1].children[1].attributes['datetime'].value
    end
  end
  
  def self.event_end(link)
    if link.css('div')[4].css('td').children[2].nil?
      '' 
    else
      link.css('div')[4].css('td')[1].children[1].attributes['datetime'].value
    end
  end
  
  def self.event_location(link)
    if link.css('div')[4].css('td').children[6].nil?
      ''
    else
      link.css('div')[4].css('td').children[6].children.children.text
    end
  end
end