begin
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
rescue LoadError
  namespace :coveralls do
    desc 'coveralls not available (coveralls not installed)'
    task :push do
      abort 'Coveralls is not available. Are you running in the right environment?'
    end
  end
end
