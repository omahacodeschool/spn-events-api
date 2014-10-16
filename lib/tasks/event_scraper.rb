# Creates SpnEvent objects with scraped info from SPN Event Calendar.
require_relative '../spn_scraper.rb'
require_relative '../startup_lincoln_scraper.rb'
require_relative '../tech_omaha_scraper.rb'

desc "Scrape for Events"
task :scrape_events => :environment do
  SpnScraper.scrape
  StartupLincolnScraper.scrape
  TechOmahaScraper.scrape
end
