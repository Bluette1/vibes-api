# Vibes API

Vibes API is a Ruby on Rails application designed to provide robust and secure data management for the Vibes app, featuring user management, secure data storage, and automated testing.

[Deployed site](https://vibes-api-space-f970ef69ea72.herokuapp.com)

## Overview

- **User Management**: Admins can manage user roles and permissions.
- **Secure Data Storage**: All sensitive data is encrypted and securely stored.
- **Automated Testing**: CI/CD pipeline runs tests automatically on new commits.

## Getting Started

### Prerequisites

- Ruby 3.1 
- Rails 7
- Bundler
- PostgreSQL 
### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Bluette1/vibes-api.git
   cd vibes-api
   ```

2. **Install dependencies**:

   ```bash
   bundle install
   ```

3. **Set up the database**:

   ```bash
   rake db:create db:migrate
   ```

4. **Run the application**:
   ```bash
   rails server
   ```

## Migrating the database to Supabase (Postgres)

Supabase runs PostgreSQL under the hood. To move from your current Postgres to Supabase, you can either load the Rails schema fresh or copy existing data with `pg_dump`/`psql`.

Prerequisites:

- Supabase project created and a Postgres connection string (DATABASE_URL)
- `psql` and `pg_dump` installed locally
- App can read environment from `.env` (this repo includes dotenv)

### 1) Configure credentials

Add your Supabase connection string to `.env` (or the host environment):

```bash
# .env
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@db.PROJECT_REF.supabase.co:5432/postgres?sslmode=require
```

Note: `sslmode=require` is necessary for Supabase.

Production already uses `DATABASE_URL` in `config/database.yml`, so no code changes are required.

### 2A) Fresh setup (no data to migrate)

If you don't need existing data, just prepare the database:

```bash
bundle exec rails db:prepare
# or, explicitly
bundle exec rails db:schema:load db:seed
```

### 2B) Migrate existing data from Postgres to Supabase

If you have an existing Postgres database you want to migrate:

1. Export from the source database (replace placeholders):

```bash
pg_dump \
   --no-owner --no-privileges \
   --format=custom \
   --file=backup.dump \
   --dbname="postgresql://USER:PASSWORD@SOURCE_HOST:5432/SOURCE_DB"
```

2. Restore into Supabase:

```bash
pg_restore \
   --no-owner --no-privileges \
   --clean --if-exists \
   --dbname="$DATABASE_URL"
```

Alternatively, use a direct pipe if you prefer a one-liner:

```bash
pg_dump --no-owner --no-privileges \
   "postgresql://USER:PASSWORD@SOURCE_HOST:5432/SOURCE_DB" | \
   psql "$DATABASE_URL"
```

3. Run pending Rails migrations (if any):

```bash
bundle exec rails db:migrate
```

4. Verify the app connects:

```bash
bundle exec rails runner "puts ActiveRecord::Base.connection.active?"
```

### Notes

- Ensure any extensions required by your app exist in Supabase (most common ones are enabled; you can enable more from Supabase SQL editor).
- If you use background jobs or cron, confirm they keep using your existing Redis. This DB migration doesn't change Redis.
- For CI/CD, set `DATABASE_URL` as a secret in your deployment environment.

### Troubleshooting: connection is unreachable

If you see an error like:

> connection to server at "2a05:...", port 5432 failed: Network is unreachable

Your system is trying IPv6 but doesn't have IPv6 connectivity. Options:

- Use the Supabase Connection Pooler endpoint (PgBouncer) which often provides IPv4. In the Supabase dashboard, copy the pooled connection string and use its host/port (usually 6543). When using the pooler, disable prepared statements:

   ```bash
   # .env
   PG_PREPARED_STATEMENTS=false
   ```

- Enable IPv6 on your network/machine, or connect via a VPN that supports IPv6.

- For local development, remove or comment out `DATABASE_URL` in `.env` so Rails uses the local development/test databases instead.

If your provider exposes both IPv6 and IPv4 for the direct endpoint, you can force IPv4 by adding `hostaddr=<ipv4>` to the connection string when an IPv4 A record exists.

### Running Tests

Execute the test suite using Rake:

```bash
bundle exec rake test
```

### Code Style

Ensure code style consistency with RuboCop:

```bash
bundle exec rubocop
```

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push to the branch.
5. Open a pull request.


**View user stories:** [https://www.notion.so/User-Stories-Vibes-11fe6a4d98f280c98b15d37c90890c0e?pvs=4](https://www.notion.so/User-Stories-Vibes-11fe6a4d98f280c98b15d37c90890c0e?pvs=21)

## License

This project is licensed under the MIT License.
