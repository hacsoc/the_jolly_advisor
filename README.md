# The Jolly Advisor

## Development

Please take note of the following sections if you're contributing to the Jolly Advisor.

### Git Workflow:
- Clone from git: `git clone https://github.com/Aaronneyer/the_jolly_advisor.git`
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

### Other notes:

- Use Github issues to note bugs and feature requests


