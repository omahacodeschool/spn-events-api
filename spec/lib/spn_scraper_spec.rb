require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require '/Users/kyle/Code/sp-event-api/lib/spn_scraper.rb'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'geocoder'
require 'chronic'

describe SpnScraper do
  
  describe "SpnScraper general methods" do
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
  
  describe "#normalize_date" do
    it "should append the time zone to the end of the altered date" do
      date_array = ['2014-10-16 12:00', 'CDT']
      expect(SpnScraper.normalize_date(date_array)).to eq('2014-10-16 12:00CDT')
    end
  end
  
  describe 'Event data-specific methods' do
    url   = url = "http://siliconprairienews.com/events/list/?action=tribe_list&tribe_paged=1&tribe_event_display=list"
    page  = Nokogiri::HTML(open(url))
    event = page.css('.vevent')[3]
    
    describe '#event_name' do
      it 'should return a stripped String of the event name or return an empty String' do
        expect(SpnScraper.event_name(event)).to eq('Youth Entrepreneurs Business for Breakfast with Bo Fishback')
      end
    end
    
    describe '#event_url' do
      it 'should return a String containing the event url or return an empty String' do
        expect(SpnScraper.event_url(event)).to eq("http://siliconprairienews.com/events/youth-entrepreneurs-business-breakfast-bo-fishback/")
      end
    end
    #
    # TODO FIGURE OUT THESE TESTS AT SOME POINT
    # describe '#event_date' do
    #   it 'should return a Chronic parsed date object or return an empty String' do
    #     expect(SpnScraper.event_date(event).class).to eq(Fri, 14 Nov 2014 00:30:00 CST -06:00)
    #   end
    # end
    # describe '#event_end' do
    #   it 'should return a Chronic parsed date object or return an empty String' do
    #     expect(SpnScraper.event_end(event)).to eq(Fri, 14 Nov 2014 02:00:00 CST -06:00)
    #   end
    # end
    # TODO END OF TODO
    #
    describe '#event_author' do
      it 'should return a String with the event author or return an empty String' do
        expect(SpnScraper.event_author(event)).to eq("Studio Dan Meiners")
      end
    end
    
    describe '#event_address' do
      it 'should return a String with the event address or return an empty String' do
        expect(SpnScraper.event_address(event)).to eq("2500 W Pennway St.")
      end
    end
    
    describe '#event_state' do
      it 'should return a String with the event state otherwise return an empty String' do
        expect(SpnScraper.event_state(event)).to eq("MO")
      end
    end
    
    describe '#event_zip_code' do
      it 'should return a String with the event zip code or return an empty String' do
        expect(SpnScraper.event_zip_code(event)).to eq("64108")
      end
    end
    
    describe '#event_description' do
      it 'should return a String with the event description or return an empty String' do
        expect(SpnScraper.event_description(event)).to eq('')
      end
    end
  end
end