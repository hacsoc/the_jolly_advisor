# The Jolly Advisor

[![Build Status](https://travis-ci.org/hacsoc/the_jolly_advisor.svg?branch=master)](https://travis-ci.org/hacsoc/the_jolly_advisor)
[![Coverage Status](https://coveralls.io/repos/hacsoc/the_jolly_advisor/badge.svg?branch=master)](https://coveralls.io/r/hacsoc/the_jolly_advisor)

## Development

Please take note of the following sections if you're contributing to the Jolly Advisor.

### Git Workflow:
- Clone from git: `git clone https://github.com/hacsoc/the_jolly_advisor.git`
- Do work on a separate branch: `git checkout -b aaron-dev`
- Finish your work and merge in master: `git fetch origin master`; `git merge master`
- Push your code to github: `git push origin aaron-dev`
- Create pull request from Github UI
- Wait to get a +1 from another team member before merging

### Rails Magic:
For people who have rusty rails, follow the following steps to setup.

- To open up the Rails console `rails c`
- Require the library `require "sis_importer"`
- Import SIS Data: `SISImporter.import_sis`

### Getting started
1. Clone: `git clone https://github.com/hacsoc/the_jolly_advisor.git`
2. New branch: `git checkout -b my-branch`
3. Install rvm: https://rvm.io
4. Switch to Ruby 2.2.0 `rvm install ruby-2.2.0`
5. Install bundle: `gem install bundle`
6. Install postgres; setup postgres; create database  
 a. `su - postgres; createuser --interactive` use your system username when it asks for role to add  
 b. `createdb the_jolly_advisor_development`  
7. `cd /path/to/the_jolly_advisor`
8. Install gems: `bundle`
9. Migrate db: `rake db:migrate` this might take a few minutes
10. Open rails console; get SIS data  
 a. `rails c`  
 b. `require “sis_importer”`  
 c. `SISImporter.import_sis`  
11. Start local server: `rails s`

Server will be available at http://localhost:3000/

### Testing information

Travis CI will run tests when you submit a pull request, but if you're using TDD, you can and should be running tests locally before submitting a pull request so you know your changes work.

If adding a new feature, you must also add automated tests and prove your coverage. 

### Travis CI Info

This is actually important info. It took Steph and Andrew a
[long time](https://twitter.com/andrew_mason1/status/589624768904744960) to
get this working.

[config/database.yml.travis](config/database.yml.travis) holds the database
configuration for the test database that Travis uses. This is because we use
a different username for our postgres db than Travis does.

The actual Travis configuration is in [.travis.yml](.travis.yml). Things to note:
* `cache: bundler` caches gem installs across builds, significantly reducing build times.
* `before_script`:
  * Copies over the travis db config to be used by the Travis CI server
  * Creates the postgres database
  * Runs the migrations
* FactoryGirl needs to be `require: false` in the Gemfile. Without this, FactoryGirl will
be loaded when Travis attempts to run `rake db:migrate`. Then FactoryGirl will try to load
all of its definitions, which have non-existent tables, since the migrations haven't been run.
Now you have circular dependencies and, your build fails. Don't do this. Require false.

Should you ever need to change this, please refer to the [Travis-CI Docs](http://docs.travis-ci.com/) and make sure you understand the current setup before modifying.

### Other notes:

- Use Github issues to note bugs and feature requests


