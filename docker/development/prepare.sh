#!/bin/sh

scriptdir="$(dirname "$0")"
cd "$scriptdir/../.."

if [ ! -f artisan ]; then
    echo "This script is being run from unexpected place"
    exit 1
fi

_run() {
    docker-compose run php "$@"
}

_run_dusk() {
    docker-compose run -e APP_ENV=dusk.local php "$@"
}

docker-compose build php

genkey=0
if [ ! -f .env ]; then
    echo "Copying default env file"
    cp .env.example .env
    genkey=1
fi

_run composer install

if [ "$genkey" = 1 ]; then
    echo "Generating app key"
    _run artisan key:generate
fi

if [ ! -f .env.testing ]; then
    echo "Copying default test env file"
    cp .env.testing.example .env.testing
fi

if [ ! -f .env.dusk.local ]; then
    echo "Copying default dusk env file"
    cp .env.dusk.local.example .env.dusk.local
    echo "Generating app key for dusk"
    _run_dusk artisan key:generate
fi

if [ ! -f storage/oauth-public.key ]; then
    echo "Generating passport key pair"
    _run artisan passport:keys
fi

_run composer install

echo "Preparation completed. Adjust .env file if needed and run 'docker-compose up' followed by running migration."
