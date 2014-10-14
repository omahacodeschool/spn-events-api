class SpnEvent < ActiveRecord::Base
  attr_accessible :date, :location, :name, :time, :url
  
  def self.run_spn_scraper
    page_num = 1
    while OpenURI::HTTPError != '404 Not Found' do
      page = Nokogiri::HTML
      page.css('.vevent').each do |event|
        Event.create(name: event.event_name)
  end
  
  # Name of Event
  page.css('.vevent')[0].css('.url').text.strip
  # Url
  page.css('.vevent')[0].css('.url')[0]['href']
  # Date Start
  page.css('.vevent')[0].css('.dtstart')[0].children[0].text
  # End Time
  page.css('.vevent')[0].css('.dtend')[0].children.text
  # Event Author
  page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.author').text
  # Event Address
  page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.street-address').text
  # Location
  page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.locality').text
  # Region
  page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.region').text
  # Postal Code
  page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.postal-code').text
  # Country
  page.css('.vevent')[0].css('.tribe-events-venue-details')[0].children.css('.country-name').text
  # Description
  page.css('.vevent')[0].css('.description')[0].css('p').text
  
end
