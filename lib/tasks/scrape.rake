#Pass in a single string with your SIS Username and Password, string delimited.
require_relative './SISScraper.rb'

credentials = ARGV[0].split(' ')
user = credentials.first
pword = credentials.last

sis_scraper = SISScraper.new()
sis_scraper.download_all_sis_data(user, pword)