namespace :import do
  desc "Imports the SIS data dump of courses into the database."
  task :data_dump => :environment do
    require 'sis_importer.rb'
    SISImporter.import_sis
  end
end
