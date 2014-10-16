# Creates Event objects with scraped info from Event Calendars.
require_relative '../spn_scraper.rb'
require_relative '../startup_lincoln_scraper.rb'
require_relative '../tech_omaha_scraper.rb'

# Scrape all Calendars
desc "Scrape for all Events"
task :scrape_events => :environment do
  StartupLincolnScraper.scrape
  TechOmahaScraper.scrape
  SpnScraper.scrape
end

# Scrape only SPN Calendar
desc "Scrape for SPN Events"
task :scrape_spn => :environment do
  SpnScraper.scrape
end


desc "Scrape for Tech Omaha Events"
task :scrape_tech_omaha => :environment do
  TechOmahaScraper.scrape
end

desc "Scrape for Startup Lincoln Events"
task :scrape_startup_lincoln => :environment do
  StartupLincolnScraper.scrape
end

