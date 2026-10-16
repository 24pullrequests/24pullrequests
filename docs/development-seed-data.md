# Working with development seed data

The development seed task creates sample records so you can explore the site without manually entering everything. The current `db/seeds.rb` uses FactoryBot and Faker to create users, contributions, projects, labels, and events.

## Before you seed

**Use only a local development or test database.** The seed file deletes existing `User`, `Contribution`, `Gift`, `Event`, `Project`, and `Label` records before creating sample data. Running it can therefore replace local records in those tables. Never run seed commands against production or any database containing data you need to keep.

## Create or refresh sample data

After following the project's local setup instructions and preparing your local database, run:

```bash
RAILS_ENV=development bundle exec rake db:seed
```

Run it again whenever you want a fresh set of generated sample records. The data is generated using factories and Faker, so names, dates, and other values can vary between runs.

## Inspect the generated data

Open a Rails console against your local development database:

```bash
RAILS_ENV=development bundle exec rails console
```

Try these read-only examples to see what the seed task created:

```ruby
User.count
Contribution.count
Project.count
Event.count
Label.pluck(:name)
```

List a few users and their contribution counts:

```ruby
User.limit(10).each do |user|
  puts "#{user.id}: #{user.contributions.count} contributions"
end
```

Inspect recent contributions:

```ruby
Contribution.order(created_at: :desc).limit(10)
```

Inspect projects and their labels:

```ruby
Project.includes(:labels).limit(10).each do |project|
  puts "#{project.id}: #{project.labels.map(&:name).join(', ')}"
end
```

These examples are intended for exploring the seeded development data. If an association or field differs in your local checkout, inspect the relevant model and factory before adapting the query.

## Need a specific scenario?

The default seed task creates a broad sample dataset, not a fixed scenario with a guaranteed number of contributions for a particular user. For a repeatable edge case, first inspect the relevant model and FactoryBot factory, then create the needed records in the local development console or add a focused factory-based test. Keep scenario-specific test data in tests rather than relying on random seed values.

For setup and test commands, see the development section of the [README](../Readme.md).