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
    
    while link_num >= links_scraped do
      links.each do |link|
        links_scraped += 1
        clicked_link = link.click.parser
        Event.create(
          event_name: StartupLincolnScraper.event_name(clicked_link),
          event_origin: 'Startup Lincoln'
          )
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
end