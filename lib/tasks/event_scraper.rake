# Creates SpnEvent objects with scraped info from SPN Event Calendar.
require_relative '../spn_scraper.rb'
require_relative '../startup_lincoln_scraper.rb'
require_relative '../tech_omaha_scraper.rb'

namespace :event do
  desc "Scrape for Events"
  task :all => :environment do
    StartupLincolnScraper.scrape
    TechOmahaScraper.scrape
    SpnScraper.scrape
  end

  # Scrape only SPN Calendar
  desc "Scrape for SPN Events"
  task :spn => :environment do
    SpnScraper.scrape
  end

  desc "Scrape for Tech Omaha Events"
  task :tech_omaha => :environment do
    TechOmahaScraper.scrape
  end

  desc "Scrape for Startup Lincoln Events"
  task :startup_lincoln => :environment do
    StartupLincolnScraper.scrape
  end
end

