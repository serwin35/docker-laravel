FROM php:8.0.7-fpm-alpine

RUN docker-php-ext-install pdo pdo_mysql

## Podejrzenie czy jest przekopiowane
# docker-compose exec php cat /etc/crontabs/root
## Uruchomienie crona
# docker-compose exec -d php crond -f

ADD ./.docker/php/crontab /etc/crontabs/root

CMD ["crond", "-f"]