require 'sis_scraper.rb'
#Call with rake scrape["../../../Downloads", "caseid", "casepassword"]
task :scrape, [:download_dir, :username, :password] do |task, args|
  SISScraper.new(args.download_dir).download_all_sis_data(args.username, args.password)
end
