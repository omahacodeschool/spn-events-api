# Creates SpnEvent objects with scraped info from SPN Event Calendar.
require_relative '../spn_scraper.rb'

desc "Create SPN Events"
task :create_spn_events => :environment do
  SpnScraper.scrape
end
