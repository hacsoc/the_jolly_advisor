# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

if ENV['IN_DOCKER']
  def wait_for_db_container
    3.times do
      return if connect_to_db
      sleep 1
    end
    raise RuntimeError.new 'Could not establish connection to postgres in 3 attempts'
  end

  def connect_to_db
    begin
      ActiveRecord::Base.connection
    rescue PG::ConnectionBad => e
      puts "#{e.class}: #{e}"
      nil
    end
  end

  task :wait_for_db => [:environment] do
    wait_for_db_container
  end

  %w(spec test).each do |t|
    Rake::Task["#{t}:prepare"].clear.enhance(%w(wait_for_db))
  end
end

if ENV['CI']
  task :default => [:spec, :features, 'coveralls:push']
end
