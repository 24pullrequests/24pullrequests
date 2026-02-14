# Repository Guidelines

Repo-specific commands, conventions, and gotchas for contributors and coding agents.

## Quick Start

Local prerequisites:

- Ruby 4.0.0 (`.ruby-version`)
- PostgreSQL
- System libraries for `pg` (e.g., `libpq-dev` on Debian/Ubuntu)
- A JavaScript runtime (Node is recommended and is used in the Docker image)
- Google Chrome (required for Cuprite-driven JS/system specs)

```bash
bin/setup
```

If you want to start the server separately:

```bash
bin/setup --skip-server
bin/dev   # http://localhost:3000
```

Docker (see `docker-compose.yml`):

```bash
docker compose build
docker compose up
```

## Project Structure

- `app/`: Rails code (controllers, models, views, services, assets, decorators)
- `config/`: environment config and initializers
- `db/`: migrations, `schema.rb`, seeds
- `lib/tasks/`: scheduled/manual rake tasks
- `spec/`: primary test suite (RSpec)
- `test/`: Action Mailer previews (e.g., `test/mailers/previews/`)
- `docs/`, `design/`: documentation and design assets
- `public/`, `vendor/`: static and vendored assets

## Common Commands

Update helper:

```bash
bin/update    # update deps + migrate + restart
```

Rails basics:

```bash
bin/rails server
bin/rails console
bin/rails db:migrate
bin/rails db:seed
```

## Testing

Run the full suite:

```bash
bundle exec rake
```

Run a specific spec file (optionally at a line), matching README/Docker docs:

```bash
bundle exec rake SPEC=./spec/models/user_spec.rb
bundle exec rake SPEC=./spec/models/user_spec.rb:42
```

Or run RSpec directly (uses `bin/rspec`):

```bash
bin/rspec spec/models/user_spec.rb:42
```

If many specs fail after migrations, prepare the test DB/schema:

```bash
bundle exec rake db:test:prepare
```

CI parity (see `.github/workflows/ci.yml`):

```bash
RAILS_ENV=test bundle exec rake db:create db:migrate spec
```

Docker test examples:

```bash
docker compose run app bundle exec rake
docker compose run app bundle exec rake SPEC=./spec/models/user_spec.rb:42
```

Note: the default `app` Docker image is suitable for non-JS specs. Specs with
`js: true` use Capybara + Cuprite and require Chrome/Chromium in the container.
Run JS/system specs on host (Quick Start) or extend the Docker image first.

Test harness gotchas (read before changing time/network behavior):

- Time is traveled for every example to `12/12/<current_year>` via Timecop.
  The app is seasonal; date-range guards will behave differently outside
  December.
- External network calls are blocked by WebMock (localhost allowed). Specs must
  stub HTTP calls.
- DatabaseCleaner runs transactions by default and switches to truncation for
  `js: true` specs.
- JS/system specs use Capybara + Cuprite, which requires Chrome.
- Deferred GC is enabled by default in specs. Set `DEFER_GC=0` to disable it.

Example: stub a GitHub API call in a spec (WebMock):

```ruby
stub_request(:get, "https://api.github.com/repos/ORG/REPO/contributors?per_page=100").
  to_return(:status => 200, :body => [{ login: "example" }].to_json,
            headers: { 'Content-Type' => 'application/json' })
```

## Seasonal Behavior

Many features and tasks are guarded by `Contribution.in_date_range?` and will
no-op outside the active period (between Dec 1 and Dec 25, exclusive). Setting
`DISABLED=1` forces `Contribution.in_date_range?` to return false.

## Useful Rake Tasks

These tasks are mostly seasonal and may no-op outside December:

```bash
bundle exec rake tfpullrequests:prepare
bundle exec rake pull_requests:download_pull_requests
bundle exec rake pull_requests:update_pull_requests
bundle exec rake emails:send_emails
```

## Coding Style & Conventions

- Indentation: 2 spaces. Line endings: LF. Trim trailing whitespace
  (`.editorconfig`).
- Naming: Rails conventions (`snake_case` files/methods, `CamelCase`
  classes/modules).
- Keep diffs minimal and focused. Avoid drive-by modernizations (hash syntax,
  mass refactors, reformatting).
- Historical style preference (see `.rubocop.yml`): prefer `collect` over `map`,
  `inject` over `reduce`, `find_all` over `select`, and `find` over `detect`.
  Do not "fix" these in unrelated changes.
- Note: `.rubocop.yml` exists as style reference, but RuboCop is not part of the
  default bundle/CI today.

## Security & Configuration Tips

- GitHub OAuth uses `GITHUB_KEY`/`GITHUB_SECRET`. In development without keys,
  the app falls back to a local `developer2` auth provider; GitHub-dependent
  features may be stubbed.
- Database settings can be overridden with `TFPULLREQUESTS_DATABASE_*` env vars
  (see `config/database.yml`).
- Optional local security scan: `bin/brakeman` (not enforced in CI).
- Optional localization check: `bundle exec i18n-tasks health` (locale files live under `config/locales/`).

## Commit & Pull Request Guidelines

- Use short, imperative commit subjects (e.g., "Fix tests", "Update dependencies").
- PRs should include: what/why, linked issue (if any), and screenshots for UI changes.
- State how you tested (exact command(s) run).

## Agent Guardrails

- Ask first before editing `Gemfile*`, `db/migrate/*`, `Dockerfile`/`docker-compose.yml`, or `.github/workflows/*`.
- Do not edit `db/schema.rb` by hand.
- Prefer minimal, localized diffs; avoid unrelated refactors.
