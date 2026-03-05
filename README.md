# 🐳 Docker Laravel Starter

[![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=flat-square&logo=laravel&logoColor=white)](https://laravel.com)
[![PHP](https://img.shields.io/badge/PHP_8.3-777BB4?style=flat-square&logo=php&logoColor=white)](https://www.php.net)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com)
[![License](https://img.shields.io/badge/License-GPL_3.0-blue?style=flat-square)](LICENSE)

A simplified Docker Compose workflow that sets up a LEMP stack for local Laravel development.

## 📦 Stack

| Service | Image | Default Port |
|---|---|---|
| PHP | 8.3 fpm-alpine | 9000 |
| Nginx | stable-alpine | 8080 |
| MariaDB | 11.4 LTS | 3306 |
| Composer | 2 | - |
| Node.js | 22 LTS (alpine) | 3000, 3001 |
| phpMyAdmin | latest | 70 |
| Redis | alpine | 6379 |
| Mailpit | latest | 1025, 8025 |

## ⚡ Quick Start

```bash
# 1. Configure environment
cp .env.example .env   # or edit the existing .env
nano .env

# 2. Clean up src directory
cd src && rm README.md && cd ..

# 3. Build and start containers
docker compose up -d --build site

# 4. Create new Laravel project
docker compose run --rm composer create-project --prefer-dist laravel/laravel .

# 5. Configure Laravel environment
nano src/.env

# 6. Run database migrations
docker compose run --rm artisan migrate
```

## 🛠️ Common Commands

```bash
# Composer
docker compose run --rm composer update
docker compose run --rm composer require package/name

# Artisan
docker compose run --rm artisan migrate
docker compose run --rm artisan tinker

# npm
docker compose run --rm npm install
docker compose run --rm npm run dev
docker compose run --rm npm run build

# Stop all containers
docker compose down
```

## 🔗 Local URLs

| Service | URL |
|---|---|
| App | [localhost:8080](http://localhost:8080) |
| phpMyAdmin | [localhost:70](http://localhost:70) |
| Mailpit UI | [localhost:8025](http://localhost:8025) |

## 🔐 Permissions Issues

If you encounter filesystem permission issues:

1. Stop containers: `docker compose down`
2. Set `UID` and `GID` in `.env` to match your host system user
3. Rebuild: `docker compose build --no-cache`
4. Start again: `docker compose up -d --build site`

## 🔥 Hot Reloading with Vite

Make sure ports `3000` and `3001` are mapped in the npm service (they are by default), then:

```bash
docker compose run --rm --service-ports npm run dev
```

Visit [localhost:3000](http://localhost:3000) to see your app with HMR enabled.

## 📧 Mailpit

Mailpit replaces the deprecated MailHog as the local mail testing tool. All outgoing emails from Laravel are captured and viewable at [localhost:8025](http://localhost:8025).

Update your Laravel `.env`:
```
MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
```

## ⚙️ GitHub Actions

CI/CD workflows are included. Add these repository secrets:

| Secret | Description |
|---|---|
| `SSH_KEY` | SSH deploy key |
| `MAIN_LARAVEL_ENV` | Production .env |
| `DEVELOP_LARAVEL_ENV` | Staging .env |

### Workflows
- **Deploy** — `main` and `develop` branches
- **PHP CS Fixer** — code style checks

## 🌿 Branch Strategy

```
main            # Production
develop         # Staging
feature/*       # New features
releases/*      # Release candidates
```

## 📝 License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
