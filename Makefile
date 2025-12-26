# =========================
# Project Configuration
# =========================
PROJECT_NAME=crm
DOCKER=docker
COMPOSE=$(DOCKER) compose

.DEFAULT_GOAL := help

# =========================
# Phony Targets
# =========================
.PHONY: help up down restart build ps logs bash artisan install composer-require migrate fresh test analyse clean

# =========================
# Help Menu
# =========================
help:
	@echo ""
	@echo "🚀 $(PROJECT_NAME) – Available commands:"
	@echo ""
	@echo "Docker:"
	@echo "  make up                     	👉 Build & start containers"
	@echo "  make down                   	👉 Stop containers"
	@echo "  make restart                	👉 Restart containers"
	@echo "  make build                  	👉 Build containers (no cache)"
	@echo "  make ps                     	👉 Show containers status"
	@echo "  make logs                   	👉 Show logs"
	@echo ""
	@echo "Nginx:"
	@echo "  make nginx                  	👉 Enter Nginx container"
	@echo ""
	@echo "MySQL:"
	@echo "  make mysql                  	👉 Enter MySQL container"
	@echo ""
	@echo "Redis:"
	@echo "  make redis                  	👉 Enter Redis container"
	@echo ""
	@echo "Laravel:"
	@echo "  make php                    	👉 Enter PHP container"
	@echo "  make artisan cmd=           	👉 Run artisan command"
	@echo "  make migrate                	👉 Run migrations"
	@echo "  make fresh                  	👉 Fresh migrate with seed"
	@echo "  make test                   	👉 Run tests"
	@echo ""
	@echo "Composer:"
	@echo "  make install                	👉 Run composer install"
	@echo "  make update                 	👉 Run composer update"
	@echo "  make composer-require pkg=  	👉 Require dev package"
	@echo ""
	@echo "Quality:"
	@echo "  make analyse                	👉 Run PHPStan analysis"
	@echo ""
	@echo "Danger zone:"
	@echo "  make clean                  	👉 Remove containers & volumes ⚠️"
	@echo ""
	@echo "EL-Hussein Salah © 2025"
	@echo ""

# =========================
# Docker Commands
# =========================
up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) down
	$(COMPOSE) up -d

build:
	$(COMPOSE) build --no-cache

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

# =========================
# Laravel / PHP
# =========================
php:
	$(DOCKER) exec -it $(PROJECT_NAME)_php bash

artisan:
ifndef cmd
	$(error ❌ You must pass cmd=...)
endif
	$(DOCKER) exec -it $(PROJECT_NAME)_php php artisan $(cmd)

migrate:
	$(DOCKER) exec -it $(PROJECT_NAME)_php php artisan migrate

fresh:
	$(DOCKER) exec -it $(PROJECT_NAME)_php php artisan migrate:fresh --seed

test:
	$(DOCKER) exec -it $(PROJECT_NAME)_php php artisan test

# =========================
# Composer
# =========================
install:
	$(DOCKER) exec -it $(PROJECT_NAME)_php composer install

composer-require:
ifndef pkg
	$(error ❌ You must pass pkg=vendor/package)
endif
	$(DOCKER) exec -it $(PROJECT_NAME)_php composer require --dev $(pkg)

update:
	$(DOCKER) exec -it $(PROJECT_NAME)_php composer update
# =========================
# Quality Tools
# =========================
analyse:
	$(DOCKER) exec -it $(PROJECT_NAME)_php ./vendor/bin/phpstan analyse --memory-limit=1G

# =========================
# Nginx
# =========================
nginx:
	$(DOCKER) exec -it $(PROJECT_NAME)_nginx /bin/sh

#==========================
# MySQL
#==========================
mysql:
	$(DOCKER) exec -it $(PROJECT_NAME)_mysql /bin/sh
#==========================
# Redis
#==========================
redis:
	$(DOCKER) exec -it $(PROJECT_NAME)_redis /bin/sh
# =========================
# Cleanup
# =========================
clean:
	$(COMPOSE) down -v
