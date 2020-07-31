dev:
	docker-compose run --rm app sh
# t:
# 	docker-compose up -d tester
# 	DISABLE_SPRING=1 docker-compose exec tester bundle exec rspec $(filter-out $@,$(MAKECMDGOALS))
%:
	@:
