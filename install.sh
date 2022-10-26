#!/bin/bash
echo "STEP [0/6]"
docker-compose build app

echo "STEP [1/6]"
docker-compose up -d

echo "STEP [2/6]"
docker-compose exec app composer create-project laravel/laravel /var/www/html --remove-vcs

echo "STEP [3/6]"
rm -rf ./application/.env

echo "STEP [4/6]"
cp .env ./application/.env

echo "STEP [5/6]"
docker-compose exec app php artisan optimize:clear

echo "STEP [6/6]"
docker-compose exec app php artisan key:generate

echo "Application Running on: http://localhost"