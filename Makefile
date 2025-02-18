# BUILD
docker-build:
	docker-compose build
docker-build-no-cache:
	docker-compose build --no-cache

# SETUPDB
docker-setupdb:
	docker-compose run --rm app bundle exec rake db:drop db:create db:migrate
	docker-compose run --rm app bundle exec rake db:seed
	docker-compose run --rm app bundle exec rake db:drop db:create db:migrate RAILS_ENV=test
	docker-compose run --rm app bundle exec rake db:seed RAILS_ENV=test

# RUN
docker-run:
	docker-compose up

# STOP
docker-stop:
	docker-compsoe down

# TESTS
docker-tests:
	docker-compose run --rm app bundle exec rspec
