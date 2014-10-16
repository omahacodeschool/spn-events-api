require 'nokogiri'
require 'open-uri'
require 'chronic'
require 'geocoder'
require 'mechanize'

module TechOmahaScraper
  
  # TODO Move forward a calendar page
  # Clean up outdated Events
  # Refactor
  
  def self.scrape
    this_month = Time.now.month
    agent      = Mechanize.new
    url1       = "https://www.google.com/calendar/htmlembed?height=600&wkst=1&bgcolor=%23ff6666&src=689bo9l4k74mu9unjbqtnulpn0@group.calendar.google.com&color=%23A32929&ctz=America/Chicago&dates=2014#{this_month}01/2014#{TechOmahaScraper.next_month(this_month)}01&mode=MONTH"
    url2       = "https://www.google.com/calendar/htmlembed?height=600&wkst=1&bgcolor=%23ff6666&src=689bo9l4k74mu9unjbqtnulpn0@group.calendar.google.com&color=%23A32929&ctz=America/Chicago&dates=2014#{TechOmahaScraper.next_month(this_month)}01/2014#{TechOmahaScraper.next_month(this_month + 1)}01&mode=MONTH"
    page1      = agent.get(url1)
    page2      = agent.get(url2)
    links      = TechOmahaScraper.prep_links(page1) + TechOmahaScraper.prep_links(page2)
    
    links.each do |link|
      clicked_link = link.click.parser
      Event.create(
        event_name:        TechOmahaScraper.event_name(clicked_link),
        event_description: TechOmahaScraper.event_description(clicked_link),
        event_date:        TechOmahaScraper.event_date(clicked_link),
        event_end:         TechOmahaScraper.event_end(clicked_link),
        event_address:     TechOmahaScraper.event_location(clicked_link),
        event_origin:      'Tech_Omaha')
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