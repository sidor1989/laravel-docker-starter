check: lint cs-check

docker-up:
	docker-compose up -d

docker-build:
	docker-compose up --build -d

docker-down:
	docker-compose down

docker-clear:
	docker-compose down -v --remove-orphans

install: perm
	docker-compose exec php-cli composer install
	docker-compose exec php-cli php artisan key:generate
	docker-compose exec php-cli php artisan storage:link
	docker-compose exec php-cli php artisan migrate
	docker-compose exec php-cli php artisan db:seed

perm:
	sudo chgrp -R www-data storage bootstrap/cache
	sudo chmod -R ug+rwx storage bootstrap/cache

queue:
	docker-compose exec -d php-fpm php artisan queue:work redis

assets-install:
	docker-compose exec node npm install

assets-dev:
	docker-compose exec node npm run dev

assets-watch:
	docker-compose exec node npm run watch
lint:
	docker-compose run --rm php-cli composer lint
cs-check:
	docker-compose run --rm php-cli composer cs-check
test-unit:
	docker-compose run --rm php-cli composer test -- --testsuite=Unit
