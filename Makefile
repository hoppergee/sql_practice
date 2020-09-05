dev\:build:
	docker-compose build
dev:
	docker-compose run --rm app sh
down:
	docker-compose down
t\:setup:
	docker-compose up -d mysql
t:
	docker-compose run --rm app rake test
ps:
	docker-compose ps
# t:
# 	docker-compose up -d tester
# 	DISABLE_SPRING=1 docker-compose exec tester bundle exec rspec $(filter-out $@,$(MAKECMDGOALS))
%:
	@:
