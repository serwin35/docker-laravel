# Docker laravel starter :whale:
A pretty simplified Docker Compose workflow that sets up a LEMP network of containers for local Laravel development. You can view the full article that inspired this repo [here](https://dev.to/aschmelyun/the-beauty-of-docker-for-local-laravel-development-13c0).

Enjoy it :raised_hands:

## Installation :dash:
```bash
# Complete the data in the .env file
nano .env

# Remove Readme file from src
cd src && rm README.md && cd ..

# Build and run containers
docker-compose up -d --build site

# Create new laravel project
docker-compose run --rm composer create-project --prefer-dist laravel/laravel .

# Update variables in .env file
nano src/.env

# Run database migration\
docker-compose run --rm artisan migrate
```

## Extra commands
Composer\
`docker-compose run --rm composer update`

Artisan\
`docker-compose run --rm artisan migrate`

Npm\
`docker-compose run --rm npm run dev`

Stop all running containers\
`docker stop $(docker ps -a -q)`

## Default ports
- App - `8080`
- PHP - `9000`
- Mysql - `3306`
- PhpMyAdmin - `70`
- Redis - `6379`
- Mailhog - `1025`
- Mailhog - `8025`

## Stack
- PHP (7.4 fpm alpine)
- nginx (stable-alpine)
- MySql (5.7.29)
- Composer (2)
- npm (14.15.1)
- phpMyAdmin (2)
- Redis (alpine)
- Mailhog (latest)

## GitHub Actions
- Deploy
    - main
    - develop
    * Remember add secrets:
        - SSH_KEY
        - MAIN_LARAVEL_ENV
        - DEVELOP_LARAVEL_ENV
- php cs fixer
## Branches
- main
- develop
- feature/*
- releases/*
