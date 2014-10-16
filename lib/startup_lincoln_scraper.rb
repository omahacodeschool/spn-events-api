require 'nokogiri'
require 'open-uri'
require 'chronic'
require 'geocoder'
require 'mechanize'

# Web Scraper for Startup Lincoln Calendar
module StartupLincolnScraper
  
  # TODO Move forward a calendar page
  # Clean up outdated Events
  # Refactor
  
  def self.scrape
    this_month = Time.now.month
    agent      = Mechanize.new
    url1       = "https://www.google.com/calendar/htmlembed?src=v33mkotgag28em0tjp25io556g@group.calendar.google.com&ctz=America/Chicago&dates=2014#{this_month}01/2014#{StartupLincolnScraper.next_month(this_month)}01"
    url2       = "https://www.google.com/calendar/htmlembed?src=v33mkotgag28em0tjp25io556g@group.calendar.google.com&ctz=America/Chicago&dates=2014#{StartupLincolnScraper.next_month(this_month)}01/2014#{StartupLincolnScraper.next_month(this_month + 1)}01"
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
  
  def self.next_month(month)
    if month == 12
      next_month = '01'
    else
      next_month = month + 1
    end
    next_month
  end
  
  def self.prep_links(page)
    links = page.links
    links.slice!(0..4)
    links.slice!(links.length - 1)
    links
  end
  
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