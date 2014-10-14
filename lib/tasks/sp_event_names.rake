desc "Create SPN Events"
task :create_spn_events => :environment do

  SpnEvent.run_spn_scrape
  
end
