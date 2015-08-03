# Call with rake scrape["../../../Downloads", "caseid", "casepassword"]
task :scrape, [:download_dir, :username, :password] do |_task, args|
  require 'sis_scraper.rb'
  SISScraper.new(args.download_dir).download_all_sis_data(args.username, args.password)
end
