# Bozzuto

http://www.bozzuto.com/

## Installation

### Repo

To get started, clone this repo:

```bash
$ git clone git@github.com:vigetlabs/bozzuto.git
```

### Ruby

Install Ruby `1.9.3p547` with rbenv:

```bash
$ rbenv install 1.9.3-p547
```

### Bundler

Install Bundler for gem dependencies:

```bash
$ gem install bundler
```

### MySQL

Install MySQL 5.6 with homebrew:

```bash
$ brew install homebrew/versions/mysql56
```

Running multiple versions of MySQL can be trouble - see [this gist](https://gist.github.com/Fosome/d382be55d19ff3f79921) for more help.

**Note** MySQL 5.7 is not compatable with our version of the `mysql2` gem.

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

### Run the app

At this point, the application should be ready to run locally.  Start the server:

```bash
$ bundle exec rails s
```

Visit `localhost:3000` in the browser. :rocket:

## Testing

### Run the suite

The default rake task will execute the entire test suite:

```bash
$ bundle exec rake test:coverage
```

### Continuous integration (CI)

New changes are build and tested with [CircleCI](https://circleci.com/). Passing builds are automatically deployed to the integration environment.

## Deployment

TODO