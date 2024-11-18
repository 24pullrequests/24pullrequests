# 24 Pull Requests

> &#127876; Giving back little gifts of code

24 Pull Requests is a yearly initiative to encourage contributors around the world to send 24 pull requests between December 1st and December 24th.

This is the site to help promote the project, highlighting why, how and where to send your pull requests.

![Happy Holidays](https://user-images.githubusercontent.com/1060/143905510-a212439c-b452-4eb8-b87a-67adcc3418e2.png)

## Table of Contents

- [24 Pull Requests](#24-pull-requests)
  - [Table of Contents](#table-of-contents)
  - [Get started](#get-started)
  - [Contributors](#contributors)
  - [Development](#development)
    - [Getting Started](#getting-started)
      - [Installing a Local Server](#installing-a-local-server)
      - [Installing using docker](#installing-using-docker)
    - [Tests](#tests)
    - [Contributing](#contributing)
    - [Translations](#translations)
    - [Code of Conduct](#code-of-conduct)
  - [Copyright](#copyright)

## Get started

* [Explore projects to help](https://24pullrequests.com/projects)
* [Submit your project to get help](https://24pullrequests.com/projects/new)

## Contributors

Over hundreds of different people have contributed to the project, you can see them all here: https://github.com/24pullrequests/24pullrequests/graphs/contributors

## Development

The source is hosted at [GitHub](https://github.com/24pullrequests/24pullrequests).

You can report issues/feature requests on [GitHub Issues](https://github.com/24pullrequests/24pullrequests/issues). You can use [GitHub Discussions](https://github.com/24pullrequests/24pullrequests/discussions) to ask questions, follow announcements, and to propose ideas for the 24pullrequests project. Follow the project on Mastodon [@24pullrequests](https://mastodon.social/@24pullrequests).

These instructions are for working on the the [24pullrequests.com](https://24pullrequests.com) website. If you just want to be a developer who contributes PRs during the holidays, you don't need to follow these instructions! Go to https://24pullrequests.com and get involved there.

### Getting Started

Want to hack on the website? Awesome!

New to Ruby? No worries! You can follow these instructions to install a local server, or you can use the included Vagrant setup.

#### Installing a Local Server

First things first, you'll need to install Ruby 3.3.6. I recommend using the excellent [rbenv](https://github.com/rbenv/rbenv),
and [ruby-build](https://github.com/rbenv/ruby-build).

```bash
rbenv install 3.3.6
rbenv global 3.3.6
```

Next, you'll need to make sure that you have PostgreSQL installed. This can be done easily on macOS using [Homebrew](https://brew.sh) or by using [https://postgresapp.com](https://postgresapp.com). Please see these [further instructions for installing Postgres via Homebrew](http://www.mikeball.us/blog/setting-up-postgres-with-homebrew/).

```bash
brew install postgres
brew install chrome-cli
```

On Debian-based Linux distributions you can use apt-get to install Postgres:

```bash
sudo apt-get install postgresql postgresql-contrib libpq-dev
```

On Windows, you can use the [Chocolatey package manager](https://chocolatey.org/) to install Postgres:

```bash
choco install postgresql
```

Clone this repository:

```bash
git clone git@github.com:24pullrequests/24pullrequests.git
```

Now, let's install the gems from the `Gemfile` ("Gems" are synonymous with libraries in other
languages).

```bash
gem install bundler && rbenv rehash
bundle install
```

Once all the gems are installed, we'll need to create the databases and tables. Rails makes this easy through the use of "Rake" tasks.

```bash
bundle exec rake db:create:all
bundle exec rake db:migrate
```

And we can also add some sample data with the **seed** task.

```bash
bundle exec rake db:seed
```

If you are working on anything related to the email-generation code, you can use [MailCatcher](https://github.com/sj26/mailcatcher).
Since we use Bundler, please read the [following](https://github.com/sj26/mailcatcher#bundler) before using MailCatcher.

Almost there! Now all we have to do is start up the Rails server and point our browser to <http://localhost:3000>

```bash
bundle exec rails s
```
#### Installing using docker

To streamline the installation process and avoid manual setup, you can use Docker and Docker Compose.

Before you begin, ensure you have the following installed:
* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)

Clone this repository:

```bash
git clone git@github.com:24pullrequests/24pullrequests.git
cd 24pullrequests
```

Build the docker image using the command below. This will install all the dependencies and create the database.

```bash
# Build the Docker image and install dependencies
docker compose build
```

Once the image is built, you can start the server using the command below.

```bash
# Pulls PostgreSQL, creates/migrates the database, and starts the server
docker compose up
```
The server is up and available at: http://localhost:3000

### Tests

Standard RSpec/Capybara tests are used for testing the application. The tests can be run with `bundle exec rake`.

You can set up the test environment with `bundle exec rake db:test:prepare`, which will create the test DB and populate its schema automatically. You don't need to do this for every test run, but it will let you easily keep up with migrations. If you find a large number of tests are failing you should probably run this.

If you are using the [omniauth](https://github.com/omniauth/omniauth) environment variables (`GITHUB_KEY`, `GITHUB_SECRET`) for **another** project, you will need to either
 * unset them before running your tests or
 * reset the omniauth environment variables after creating a GitHub (omniauth) application for this project

as it will use it to learn more about the contributors and for pull requests.

If you are using the Docker setup, you can run the tests:

* Overall tests: `docker compose run app bundle exec rake`
* Specific tests: `docker compose run app bundle exec rake SPEC=./spec/path/to/test_spec.rb`
* Specific lines: `docker compose run app bundle exec rake SPEC=./spec/path/to/test_spec.rb:123`

### Contributing

We are always looking for people to contribute! To find out how to help out, have a look at our [Contributing Guide](CONTRIBUTING.md).

### Translations

24 Pull Requests is available in twenty languages. Translations are [managed on Transifex](https://www.transifex.com/24-pull-requests/24-pull-requests/). Authentication is required to use Transifex. If you prefer to edit the translations directly you can use the [standard Rails i18n framework](https://guides.rubyonrails.org/i18n.html#organization-of-locale-files). To get started:

* Fork the project.
* Create a copy of `config/locales/en.yml` within the locales folder.
* Amend the first line with the [correct character set](https://www.w3.org/International/O-charset-lang.html) you'll be translating to.
* Translate the strings and submit a pull request for the new translation.

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Copyright

Copyright MIT © 2021 Andrew Nesbitt. See [LICENSE](https://github.com/24pullrequests/24pullrequests/blob/main/LICENSE) for details.
