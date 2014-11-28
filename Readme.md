# 24 Pull Requests

[![Build Status](https://travis-ci.org/24pullrequests/24pullrequests.svg?branch=master)](https://travis-ci.org/24pullrequests/24pullrequests)
[![Dependency Status](https://gemnasium.com/24pullrequests/24pullrequests.svg)](https://gemnasium.com/24pullrequests/24pullrequests)
[![Code Climate](https://codeclimate.com/github/24pullrequests/24pullrequests/badges/gpa.svg)](https://codeclimate.com/github/24pullrequests/24pullrequests)
[![Test Coverage](https://codeclimate.com/github/24pullrequests/24pullrequests/badges/coverage.svg)](https://codeclimate.com/github/24pullrequests/24pullrequests)
[![Gitter chat](http://img.shields.io/badge/gitter-24pullrequests-brightgreen.svg)](https://gitter.im/24pullrequests/24pullrequests)
[![PullReview stats](https://www.pullreview.com/github/24pullrequests/24pullrequests/badges/master.svg?)](https://www.pullreview.com/github/24pullrequests/24pullrequests/reviews/master)

“Giving back little gifts of code”

24 Pull Requests is a yearly initiative to encourage developers around the world to send a pull request every day in December up to Christmas.

This is the site to help promote the project, highlighting why, how and where to send your pull requests.

## Get started!

* [Explore projects to help](http://24pullrequests.com/projects)
* [Submit your project to get help](http://24pullrequests.com/projects/new)

## Authors

* Andrew Nesbitt
* Chris Lowder
* Baris Balic
* Victoria Holland

## Development

Source hosted at [GitHub](http://github.com/24pullrequests/24pullrequests).
Report issues/feature requests on [GitHub Issues](http://github.com/24pullrequests/24pullrequests/issues). Follow us on Twitter [@24pullrequests](https://twitter.com/24pullrequests).

### Getting Started

New to Ruby? No worries! You can follow these instructions to install a local server, or you can use the included Vagrant setup.

#### Installing a Local Server

First things first, you'll need to install Ruby 2.0. I recommend using the excellent [rbenv](https://github.com/sstephenson/rbenv),
and [ruby-build](https://github.com/sstephenson/ruby-build)

```bash
rbenv install 2.1.5
rbenv global 2.1.5
```

Next, you'll need to make sure that you have postgres installed. This can be
done easily on OSX using [Homebrew](http://mxcl.github.com/homebrew/) or by using [http://postgresapp.com](http://postgresapp.com). Please see these [further instructions for installing postgres via homebrew](http://www.mikeball.us/blog/setting-up-postgres-with-homebrew/).

```bash
brew install postgres phantomjs
```

On Debian-based Linux distributions you can use apt-get to install postgres if it's not already installed.

```bash
sudo apt-get install postgresql postgresql-contrib
```

On Windows, you can use the [Chocolatey package manager](http://www.chocolatey.org) to install postgres.

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

And we can also add some sample data with the **seed** task

```bash
bundle exec rake db:seed
```

If you are working on anything related to the email-generation code, you can use [mailcatcher](https://github.com/sj26/mailcatcher)
Since we use bundler, please read the [following](https://github.com/sj26/mailcatcher#bundler) before using mailcatcher

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
    $ rails s

Then you should be able to access the application through your regular browser at http://192.168.12.34:3000 .

### Tests

Standard RSpec/Capybara tests are used for testing the application. The
tests can be run with `bundle exec rake`.

Mocha/Konacha is used for unit testing any JavaScript. JavaScript specs
should be placed in `spec/javascripts`. Run the JavaScript specs with
`bundle exec rake konacha:serve`.

If you are using the omniauth environment variables
(GITHUB_KEY, GITHUB_SECRET, TWITTER_KEY, TWITTER_SECRET)
for **another** project, you will need to either
 * unset them before running your tests or
 * reset the omniauth environment variables after creating a Github (omniauth) application for this project

as it will use it to learn more about the developers and for pull requests.

### Note on Patches/Pull Requests

 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a future version unintentionally.
 * Send a pull request. Bonus points for topic branches.

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Copyright

Copyright (c) 2014 Andrew Nesbitt. See [LICENSE](https://github.com/24pullrequests/24pullrequests/blob/master/LICENSE) for details.
