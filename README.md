# The Jolly Advisor

[![Build Status](https://travis-ci.org/hacsoc/the_jolly_advisor.svg?branch=master)](https://travis-ci.org/hacsoc/the_jolly_advisor)

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

### Other notes:

- Use Github issues to note bugs and feature requests


