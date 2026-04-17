# Poshak

Rails 8 e-commerce app (catalog, cart, checkout, accounts, admin).

## Setup

- Ruby: see `.ruby-version`
- `bundle install`
- Copy `.env.example` to `.env` and set `DATABASE_URL` (and optional vars)
- `bin/rails db:prepare`
- `bin/dev` (or `bin/rails server`)

## Tests

```bash
bin/rails db:test:prepare
bundle exec rspec spec/models spec/helpers spec/requests/registrations_spec.rb
```

## Deployment (e.g. Render + Neon)

1. Set environment variables from `.env.example` (never commit secrets):
   - `DATABASE_URL`, `RAILS_MASTER_KEY`, `APP_HOST`
   - Optional: `SMTP_*` for mail; `AWS_*` and `AWS_S3_ENDPOINT` for S3/R2 storage
2. Build: `bundle install && bundle exec rails assets:precompile`
3. Start: `bundle exec puma -C config/puma.rb` (Render sets `PORT`)
4. Release / one-off: `bin/rails db:migrate` — use a paid Render shell, or run locally against `DATABASE_URL`
5. Optional: `bin/rails db:seed` for demo data (do **not** use `db:seed:reset` on production data)

`config/master.key` is **not** in git; keep it only on hosts and developer machines. If you cloned without it, use `bin/rails credentials:edit` with a new key from `bin/rails secret` (coordinate with existing encrypted credentials).

## Docker

See `Dockerfile` and `.dockerignore`. Pass `RAILS_MASTER_KEY` at runtime.
