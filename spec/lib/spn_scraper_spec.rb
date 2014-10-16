require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require '/Users/kyle/Code/sp-event-api/lib/spn_scraper.rb'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'geocoder'
require 'chronic'
describe SpnScraper do

  describe "SpnScraper methods" do
    it "should have a scrape method" do
      methods = SpnScraper.methods
      expect(methods.include? :scrape).to be(true)
    end
    
    it "should have a normalize_date method" do
      methods = SpnScraper.methods
      expect(methods.include? :scrape).to be(true)
    end
  end
  
  describe "#remove_time_zone" do
    it "should match the time zone within the date string" do
      date = "2014-10-16CDT12:00"
      expect(SpnScraper.separate_date(date)[1]).to eq('CDT')
    end
    
    it "should remove the time zone and replace it with a blank space" do
      date = '2014-10-16CDT12:00'
      expect(SpnScraper.separate_date(date)[0]).to eq('2014-10-16 12:00')
    end
  end
  
  describe "normalize_date method" do
    it "should append the time zone to the end of the altered date" do
      date_array = ['2014-10-16 12:00', 'CDT']
      expect(SpnScraper.normalize_date(date_array)).to eq('2014-10-16 12:00CDT')
    end
  end
  #
  # describe "scrape method" do
  #   it "should only run if it receives a 200 status code from the request"
end