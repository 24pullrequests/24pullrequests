# 24 Pull Requests

[![Build Status](https://travis-ci.org/24pullrequests/24pullrequests.svg?branch=master)](https://travis-ci.org/24pullrequests/24pullrequests)
[![Dependency Status](https://img.shields.io/gemnasium/24pullrequests/24pullrequests.svg?style=flat)](https://gemnasium.com/24pullrequests/24pullrequests)
[![Gitter chat](https://img.shields.io/badge/gitter-24pullrequests-brightgreen.svg?style=flat)](https://gitter.im/24pullrequests/24pullrequests)
[![Code Climate](https://img.shields.io/codeclimate/github/24pullrequests/24pullrequests.svg?style=flat)](https://codeclimate.com/github/24pullrequests/24pullrequests)
[![Test Coverage](https://img.shields.io/codeclimate/coverage/github/24pullrequests/24pullrequests.svg?style=flat)](https://codeclimate.com/github/24pullrequests/24pullrequests)

> &#127876; **Giving back little gifts of code for Christmas**

24 Pull Requests is a yearly initiative to encourage developers around the world to send 24 pull requests between December 1st and December 24th.

This is the site to help promote the project, highlighting why, how and where to send your pull requests.

## Table of Contents

- [Get started](#get-started)
- [Contributors](#contributors)
- [Development](#development)
  - [Getting Started](#getting-started)
    - [Installing a Local Server](#installing-a-local-server)
    - [Using Vagrant](#using-vagrant)
  - [Tests](#tests)
  - [Environment variables](#environment-variables)
  - [Contributing](#contributing)
  - [Code of Conduct](#code-of-conduct)
- [Copyright](#copyright)

## Get started

* [Explore projects to help](http://24pullrequests.com/projects)
* [Submit your project to get help](http://24pullrequests.com/projects/new)

## Contributors

Over 180 different people have contributed to the project, you can see them all here: https://github.com/24pullrequests/24pullrequests/graphs/contributors

## Development

The source is hosted at [GitHub](https://github.com/24pullrequests/24pullrequests).
You can report issues/feature requests on [GitHub Issues](https://github.com/24pullrequests/24pullrequests/issues). Follow the project on Twitter [@24pullrequests](https://twitter.com/24pullrequests). People from this community also often hangout on [Gitter](https://gitter.im/24pullrequests/24pullrequests).

These instructions are for working on the the [24pullrequests.com](https://24pullrequests.com) website. If you just want to be a developer who contributes PRs during the holidays, you don't need to follow these instructions! Go to https://24pullrequests.com and get involved there.

### Getting Started

Want to hack on the website? Awesome!

New to Ruby? No worries! You can follow these instructions to install a local server, or you can use the included Vagrant setup.

#### Installing a Local Server

First things first, you'll need to install Ruby 2.5.0. I recommend using the excellent [rbenv](https://github.com/rbenv/rbenv),
and [ruby-build](https://github.com/rbenv/ruby-build).

```bash
rbenv install 2.5.0
rbenv global 2.5.0
```

Next, you'll need to make sure that you have PostgreSQL installed. This can be
done easily on OSX using [Homebrew](http://mxcl.github.io/homebrew/) or by using [http://postgresapp.com](http://postgresapp.com). Please see these [further instructions for installing Postgres via Homebrew](http://www.mikeball.us/blog/setting-up-postgres-with-homebrew/).

```bash
brew install postgres phantomjs
```

On Debian-based Linux distributions you can use apt-get to install Postgres:

```bash
sudo apt-get install postgresql postgresql-contrib libpq-dev
```

On Windows, you can use the [Chocolatey package manager](http://chocolatey.org/) to install Postgres:

```bash
choco install postgresql
```

Now, let's install the gems from the `Gemfile` ("Gems" are synonymous with libraries in other
languages).

```bash
gem install bundler && rbenv rehash
bundle install
```

Once all the gems are installed, we'll need to create the databases and
tables. Rails makes this easy through the use of "Rake" tasks.

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

Almost there! Now all we have to do is start up the Rails server and point
our browser to <http://localhost:3000>

```bash
bundle exec rails s
```
#### Using Vagrant

The included Vagrant setup uses Ansible as provisioner. First, you'll need to install the dependencies:

 * [Vagrant](https://www.vagrantup.com/downloads.html)
 * [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
 * [Ansible](http://docs.ansible.com/intro_installation.html)

_Windows Users: Ansible does not support Windows as controller machine, but there's a little hack in the Vagrantfile that will allow you to run the provision using a local
SSH connection Guest-Guest. Just install Vagrant and VirtualBox, and you should be able to get it running._

Once you have everything installed, go to the project directory via console and run:

    $ vagrant up

The first time you run `vagrant up`, the process will take several minutes, since it will download a box and run all necessary tasks to get the server ready. When the process
is finished, log in to run the rails dev server:

    $ vagrant ssh
    $ cd /vagrant
    $ bundle exec rails s -b 0.0.0.0

Then you should be able to access the application through your regular browser at http://192.168.12.34:3000.

Simply edit the files in the project directory using your favorite editor on your host machine and the changes will be automatically reflected in the `/vagrant` directory inside the guest virtual machine and so you can see the changes on your browser.

### Tests

Standard RSpec/Capybara tests are used for testing the application. The tests can be run with `bundle exec rake`.

You can set up the test environment with `bundle exec rake db:test:prepare`, which will create the test DB and populate its schema automatically. You don't need to do this for every test run, but it will let you easily keep up with migrations. If you find a large number of tests are failing you should probably run this.

If you are using the omniauth environment variables
(GITHUB_KEY, GITHUB_SECRET, TWITTER_KEY, TWITTER_SECRET)
for **another** project, you will need to either
 * unset them before running your tests or
 * reset the omniauth environment variables after creating a GitHub (omniauth) application for this project

as it will use it to learn more about the developers and for pull requests.

### Environment variables

`bundle exec figaro install`

Or for more information about using figaro, see https://github.com/laserlemon/figaro

### Contributing

We are always looking for people to contribute! To find out how to help out, have a look at our [Contributing Guide](CONTRIBUTING.md).

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Copyright

Copyright (c) 2018 Andrew Nesbitt. See [LICENSE](https://github.com/24pullrequests/24pullrequests/blob/master/LICENSE) for details.
