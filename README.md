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
- NPM - `3000`
- NPM - `3001`
- Mailhog - `1025`
- Mailhog - `8025`

## Permissions Issues

If you encounter any issues with filesystem permissions while visiting your application or running a container command, try completing the following steps:

- Bring any container(s) down with `docker-compose down`
- Copy the `.env.example` file in the root of this repo to `.env`
- Modify the values in the `.env` file to match the user/group that the `src` directory is owned by on the host system
- Re-build the containers by running `docker-compose build --no-cache`

Then, either bring back up your container network or re-run the command you were trying before, and see if that fixes it.

## Using BrowserSync with Laravel Mix

If you want to enable the hot-reloading that comes with Laravel Mix's BrowserSync option, you'll have to follow a few small steps. First, ensure that you're using the updated `docker-compose.yml` with the `:3000` and `:3001` ports open on the npm service. Then, add the following to the end of your Laravel project's `webpack.mix.js` file:

```javascript
.browserSync({
    proxy: 'nginx',
    open: false,
    port: 3000,
});
```

From your terminal window at the project root, run the following command to start watching for changes with the npm container and its mapped ports:

```bash
docker-compose run --rm --service-ports npm run watch
```

That should keep a small info pane open in your terminal (which you can exit with Ctrl + C). Visiting [localhost:3000](http://localhost:3000) in your browser should then load up your Laravel application with BrowserSync enabled and hot-reloading active.

## MailHog

The current version of Laravel (8 as of today) uses MailHog as the default application for testing email sending and general SMTP work during local development. Using the provided Docker Hub image, getting an instance set up and ready is simple and straight-forward. The service is included in the `docker-compose.yml` file, and spins up alongside the webserver and database services.

To see the dashboard and view any emails coming through the system, visit [localhost:8025](http://localhost:8025) after running `docker-compose up -d site`.

## Stack
- PHP (8.1 fpm alpine)
- nginx (stable-alpine)
- MariaDB (10.6)
- Composer (2)
- npm (18.11)
- phpMyAdmin (2)
- Redis (alpine)
- Mailhog (latest)

## GitHub Actions
* Remember add secrets:
    - SSH_KEY
    - MAIN_LARAVEL_ENV
    - DEVELOP_LARAVEL_ENV
- Deploy
    - main
    - develop
- php cs fixer

## Branches
- main
- develop
- feature/*
- releases/*
