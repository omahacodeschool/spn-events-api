require 'nokogiri'
require 'open-uri'
require 'chronic'
require 'geocoder'
require 'mechanize'

module StartupLincolnScraper

  def self.scrape
    # page_num = 1
    agent = Mechanize.new
    url = "https://www.google.com/calendar/htmlembed?src=v33mkotgag28em0tjp25io556g@group.calendar.google.com&ctz=America/Chicago&dates=20141001/20141101"
    page = agent.get(url)
    links = StartupLincolnScraper.prep_links(page)
    link_num = links.length
    links_scraped = 0
    
    until links_scraped >= link_num do
      links.each do |link|
        links_scraped += 1
        clicked_link = link.click.parser
        Event.create(
          event_name: StartupLincolnScraper.event_name(clicked_link),
          event_description: StartupLincolnScraper.event_description(clicked_link),
          event_date: StartupLincolnScraper.event_date(clicked_link),
          event_end: StartupLincolnScraper.event_end(clicked_link),
          event_address: StartupLincolnScraper.event_location(clicked_link),
          event_origin: 'Startup Lincoln')
      end
    end
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