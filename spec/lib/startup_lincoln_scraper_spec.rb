require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require '/Users/kyle/Code/sp-event-api/lib/startup_lincoln_scraper.rb'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'geocoder'
require 'chronic'
require 'pry'

describe StartupLincolnScraper do
  describe 'StartupLincolnScraper general methods' do
    methods      = StartupLincolnScraper.methods
    this_year    = Time.now.year
    this_month   = Time.now.month
    base_url     = "https://www.google.com/calendar/htmlembed?src=v33mkotgag28em0tjp25io556g@group.calendar.google.com&ctz=America/Chicago&dates="
    agent        = Mechanize.new
    url1         = "#{base_url}#{this_year}#{this_month}01/#{this_year}#{StartupLincolnScraper.next_month(this_month)}01"
    page1        = agent.get(url1)
    unsliced     = agent.get(url1)
        
    describe 'module methods' do
      it 'should have a scrape method' do
        expect(methods.include? :scrape).to be(true)
      end
    
      it 'should have a next_month method' do
        expect(methods.include? :next_month).to be(true)
      end
    
      it 'should have a next_year method' do
        expect(methods.include? :next_year).to be(true)
      end
    
      it 'should have a prep_links method' do
        expect(methods.include? :prep_links).to be(true)
      end
    end
    
    describe '#next_month' do
      it "should return a String '01' if month is December" do
        expect(StartupLincolnScraper.next_month(12)).to eq('01')
      end
      it "should return the month argument incremented by one if the month is not December" do
        expect(StartupLincolnScraper.next_month(11)).to eq('12')
      end
    end
    
    describe '#next_year' do
      it "should return the given year incremented by one if the month is December" do
        expect(StartupLincolnScraper.next_year(2014, 12)).to eq(2015)
      end
      it "should return the given year if the month is not December" do
        expect(StartupLincolnScraper.next_year(2014, 11)).to eq(2014)
      end
    end
    
    describe '#prep_links' do
      it "should remove 6 links from scraped page" do
        expect(StartupLincolnScraper.prep_links(page1).length).to eq(unsliced.links.length - 6)
      end
    end
    
    describe 'Scraper specific methods' do
      links = StartupLincolnScraper.prep_links(page1)
      clicked_link = links[3].click.parser
      describe '#event_name' do
        it "should return the String of the event or return nil" do
          expect(StartupLincolnScraper.event_name(clicked_link)).to eq("Art show at FUSE: Meghan Stratman")
        end
      end
      
      describe '#event_description' do
        it 'should return the String containing the event description' do
          expect(StartupLincolnScraper.event_description(clicked_link)).to eq('When')
        end
      end
      #
      # TODO FIGURE OUT THESE TESTS
      #
      # describe '#event_date' do
      #   it 'should return the date/time string containing the event start' do
      #     expect(StartupLincolnScraper.event_date(clicked_link)).to eq("2014-10-04 19:00:00")
      #   end
      # end
      #
      # describe '#event_end' do
      #   it 'should return the date/time string containing the end date' do
      #     expect(StartupLincolnScraper.event_end(clicked_link)).to eq("2014-10-04 19:00:00")
      #   end
      # end
      #
      # TODO THEY ARE CONFUSING
      #
      describe '#event_location' do
        it 'should return the String containing the event location' do
          expect(StartupLincolnScraper.event_location(clicked_link)).to eq('')
        end
      end
    end
  end
end