<div align="center">

# Docker Laravel

**Zero-friction Docker Compose LEMP stack for Laravel local development**

[![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com)
[![PHP](https://img.shields.io/badge/PHP_8.3-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com)
[![MariaDB](https://img.shields.io/badge/MariaDB_11.4-003545?style=for-the-badge&logo=mariadb&logoColor=white)](https://mariadb.org)
[![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)](https://redis.io)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/serwin35/docker-laravel?style=flat-square&color=yellow)](https://github.com/serwin35/docker-laravel/stargazers)
[![Forks](https://img.shields.io/github/forks/serwin35/docker-laravel?style=flat-square)](https://github.com/serwin35/docker-laravel/network/members)
[![Last Commit](https://img.shields.io/github/last-commit/serwin35/docker-laravel?style=flat-square)](https://github.com/serwin35/docker-laravel/commits/main)

</div>

---

## What Is This?

`docker-laravel` is a **production-inspired local development environment** built with Docker Compose. Clone it, run one command, and you have a full LEMP stack up and running — no homebrew conflicts, no version mismatches, no "works on my machine" headaches.

It comes pre-wired with:

- **PHP 8.3 FPM** behind **Nginx**
- **MariaDB 11.4** for your database
- **Redis** for cache, sessions, and queues
- **Mailpit** to catch all outgoing emails locally
- **phpMyAdmin** for quick DB inspection
- **Node.js 22 LTS** + Composer 2 as isolated run containers
- **GitHub Actions** workflows for CI/CD out of the box

Whether you are starting a new Laravel project or onboarding teammates to an existing one, this setup gets everyone to an identical environment in minutes.

---

## Why Not Laravel Sail or Valet?

| Feature | docker-laravel | Laravel Sail | Laravel Valet |
|---|---|---|---|
| Zero host dependencies | Yes | Yes | No (macOS only) |
| Explicit, version-pinned images | Yes | Yes | N/A |
| MariaDB (not MySQL) | Yes | Optional | No |
| Redis included | Yes | Optional | Via extension |
| Mailpit included | Yes | No (MailHog) | No |
| phpMyAdmin included | Yes | No | No |
| GitHub Actions CI/CD | Yes | No | No |
| Independent of Laravel app itself | Yes | No (installs into project) | No |
| Works on Linux / macOS / Windows | Yes | Yes | No |
| Configurable ports via .env | Yes | Partial | No |

---

## Stack

| Service | Image | Default Port | Configurable |
|---|---|---|---|
| PHP-FPM | `php:8.3-fpm-alpine` | 9000 (internal) | No |
| Nginx | `nginx:stable-alpine` | `8080` | `APP_PORT` |
| MariaDB | `mariadb:11.4` | `3306` | `SQL_PORT` |
| phpMyAdmin | `phpmyadmin/phpmyadmin:latest` | `70` | `PMA_PORT` |
| Redis | `redis:alpine` | `6379` | No |
| Mailpit | `axllent/mailpit:latest` | `1025` (SMTP), `8025` (UI) | No |
| Composer | `composer:2` | — (run container) | — |
| Node.js | `node:22-alpine` | `3000`, `3001` (Vite) | — |

---

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Docker Engine + Compose plugin on Linux)
- [Git](https://git-scm.com/)

That is all. PHP, Node, Composer — everything runs inside containers.

---

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/serwin35/docker-laravel.git my-project
cd my-project
```

### 2. Configure the environment

```bash
cp .env.example .env
```

Open `.env` and adjust any ports if needed (see [Environment Variables](#environment-variables)).

### 3. Build and start the stack

```bash
docker compose up -d --build site
```

### 4. Create a new Laravel project

```bash
# Remove the placeholder src/README.md first
rm src/README.md

docker compose run --rm composer create-project --prefer-dist laravel/laravel .
```

> To use an **existing** Laravel project instead, copy your project files into the `src/` directory and skip this step.

### 5. Configure Laravel's `.env`

```bash
nano src/.env
```

Set the database credentials to match what is in your root `.env`:

```dotenv
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret
```

Set Redis:

```dotenv
REDIS_HOST=redis
REDIS_PORT=6379
```

### 6. Run migrations

```bash
docker compose run --rm artisan migrate
```

Your app is now live at **http://localhost:8080**.

---

## Common Commands

### Composer

```bash
# Install dependencies
docker compose run --rm composer install

# Update dependencies
docker compose run --rm composer update

# Add a package
docker compose run --rm composer require vendor/package
```

### Artisan

```bash
# Run migrations
docker compose run --rm artisan migrate

# Rollback migrations
docker compose run --rm artisan migrate:rollback

# Open Tinker REPL
docker compose run --rm artisan tinker

# Clear all caches
docker compose run --rm artisan optimize:clear

# List all routes
docker compose run --rm artisan route:list
```

### npm / Node

```bash
# Install dependencies
docker compose run --rm npm install

# Development build
docker compose run --rm npm run dev

# Production build
docker compose run --rm npm run build
```

### Container management

```bash
# Start the full stack
docker compose up -d

# Stop the stack (preserves volumes)
docker compose down

# Stop and remove volumes (full reset)
docker compose down -v

# View logs
docker compose logs -f site

# Open a shell inside the PHP container
docker compose exec site sh
```

---

## Local URLs

| Service | URL |
|---|---|
| Laravel Application | http://localhost:8080 |
| phpMyAdmin | http://localhost:70 |
| Mailpit UI | http://localhost:8025 |
| Vite HMR (during dev) | http://localhost:3000 |

> All ports are configurable in `.env` — see [Environment Variables](#environment-variables).

---

## Environment Variables

The root `.env` file controls the Docker Compose stack. The `src/.env` file controls Laravel itself. They are separate.

| Variable | Default | Description |
|---|---|---|
| `APP_PORT` | `8080` | Nginx HTTP port on your host |
| `SQL_PORT` | `3306` | MariaDB port on your host |
| `PMA_PORT` | `70` | phpMyAdmin port on your host |
| `DB_DATABASE` | `homestead` | Database name |
| `DB_USERNAME` | `homestead` | Database user |
| `DB_PASSWORD` | `secret` | Database password |
| `DB_ROOT_PASSWORD` | `secret` | MariaDB root password |
| `UID` | `1000` | Host user ID (for file permission mapping) |
| `GID` | `1000` | Host group ID (for file permission mapping) |

---

## Permissions Troubleshooting

If you see `Permission denied` errors when Laravel tries to write to `storage/` or `bootstrap/cache/`, the container user does not match your host user.

**Fix:**

```bash
# Find your host UID and GID
id -u   # typically 1000 on Linux
id -g

# Set them in the root .env
UID=1000
GID=1000

# Rebuild the containers
docker compose down
docker compose build --no-cache
docker compose up -d
```

On macOS with Docker Desktop this is usually not needed because Docker handles user mapping automatically.

---

## Hot Reload with Vite

Ports `3000` and `3001` are mapped on the `npm` service by default. Use `--service-ports` to expose them when running Vite:

```bash
docker compose run --rm --service-ports npm run dev
```

In your `vite.config.js`, configure the dev server so Vite binds to `0.0.0.0` and the HMR client connects through your host:

```js
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: {
        host: '0.0.0.0',
        port: 3000,
        hmr: {
            host: 'localhost',
        },
    },
});
```

Then visit **http://localhost:3000** for live-reloading.

---

## Mailpit — Local Email Testing

All emails sent from Laravel are captured by **Mailpit** — nothing reaches the real internet. View them in the Mailpit web UI at **http://localhost:8025**.

Configure Laravel's `src/.env`:

```dotenv
MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"
```

> `mailpit` resolves to the Mailpit container inside the Docker network. No extra configuration needed.

---

## GitHub Actions CI/CD

The repository ships with pre-built GitHub Actions workflows. To activate them, add the following **repository secrets** in *Settings → Secrets and variables → Actions*:

| Secret | Description |
|---|---|
| `SSH_KEY` | Private SSH deploy key for the target server |
| `MAIN_LARAVEL_ENV` | Full contents of the production `src/.env` |
| `DEVELOP_LARAVEL_ENV` | Full contents of the staging `src/.env` |

### Included Workflows

| Workflow | Trigger | What It Does |
|---|---|---|
| **Deploy** | Push to `main` or `develop` | SSH into the server, pull latest code, run migrations |
| **PHP CS Fixer** | Push / PR | Checks code style against Laravel conventions |

---

## Branch Strategy

```
main         →  production
develop      →  staging / integration
feature/*    →  new features (merge into develop)
releases/*   →  release candidates (merge into main)
```

Pull requests should target `develop`. Only `develop` merges into `main` via a release branch.

---

## Contributing

Contributions are welcome! Here is how:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-improvement`
3. Commit your changes: `git commit -m "feat: add my improvement"`
4. Push to your fork: `git push origin feature/my-improvement`
5. Open a Pull Request targeting the `develop` branch

Please keep PRs focused — one feature or fix per PR. For larger changes, open an issue first to discuss the approach.

---

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).

---

<div align="center">

If this saved you time, consider leaving a star — it helps others find the project.

[![Star on GitHub](https://img.shields.io/github/stars/serwin35/docker-laravel?style=social)](https://github.com/serwin35/docker-laravel/stargazers)

</div>
