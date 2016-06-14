# Bozzuto

http://www.bozzuto.com/

## Installation

### Repo

To get started, clone this repo:

```bash
$ git clone git@github.com:vigetlabs/bozzuto.git
```

### Ruby

Install Ruby `2.2.3` with rbenv:

```bash
$ rbenv install 2.2.3
```

### Bundler

Install Bundler for gem dependencies:

```bash
$ gem install bundler
```

Then run `install` to fetch the dependencies:

```bash
$ bundle install
```

### MySQL

Install MySQL 5.6 with homebrew:

```bash
$ brew install homebrew/versions/mysql56
```

Running multiple versions of MySQL can be trouble - see [this gist](https://gist.github.com/Fosome/d382be55d19ff3f79921) for more help.

**Note** MySQL 5.7 is not compatable with our version of the `mysql2` gem.

### Redis

Non-development environments need Redis.  Install with homebrew:

```bash
$ brew install redis
```

Development environments run background jobs Reque jobs inline and don't require Redis running.

### Imagemagick

Install Imagemagick with homebrew:

```bash
$ brew install imagemagick
```

### Config files

Some application configuration _should not be checked into source control_. You need to create copies to run the app locally.

For the database:

```bash
$ cp config/database.yml.example config/database.yml
```

For the app:

```bash
$ cp config/app_config.yml.example config/app_config.yml
```

Fill out the config files with appropriate values.

### Setup the database

```bash
$ bundle exec rake db:create db:migrate db:test:prepare
```

To get working data, run:

```bash
$ bundle exec cap production sync:down:db
$ bundle exec cap sync:down:fs
```

You may need to add your auth key to the server, in which case reach out to the dev on the project to get the ball rolling.

### Run the app

At this point, the application should be ready to run locally.  Start the server:

```bash
$ bundle exec rails s
```

Visit `localhost:3000` in the browser. :rocket:

## Testing

### Run the suite

The `test:full` rake task will execute the entire test suite:

```bash
$ bundle exec rake test:full
```

### Coverage

The test suite can be run with coverage:

```bash
$ bundle exec rake test:coverage
```

### Continuous integration (CI)

New changes are build and tested with [CircleCI](https://circleci.com/). Passing builds are automatically deployed to the integration environment.

## Deployment

Merge changes into master and run `bundle exec cap deploy` to deploy to integration.

Once your changes have updated and been verified by your PM, run:
`git checkout production`
`git merge master`
`git push origin production`
`bundle exec cap production deploy`
