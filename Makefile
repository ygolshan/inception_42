DOMAIN_NAME = ygolshan.42.fr
CERT_ = ./requirements/tools/ygolshan.42.fr
KEY_ = ./requirements/tools/ygolshan.42.fr
DB_NAME = wordpress
DB_ROOT = root
DB_USER = ygolshan
DB_PASS = debian
NAME = inception

all: generate-env run

generate-env:
	@echo "Generating srcs/.env file..."
	@echo "DOMAIN_NAME=${DOMAIN_NAME}" > srcs/.env
	@echo "CERT_=${CERT_}" >> srcs/.env
	@echo "KEY_=${KEY_}" >> srcs/.env
	@echo "DB_NAME=${DB_NAME}" >> srcs/.env
	@echo "DB_ROOT=${DB_ROOT}" >> srcs/.env
	@echo "DB_USER=${DB_USER}" >> srcs/.env
	@echo "DB_PASS=${DB_PASS}" >> srcs/.env

run: generate-env
	@echo "Launching ${NAME} configuration..."
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d
	@echo "${NAME} Inception complete!"

build: generate-env
	echo "Building and launching ${NAME} configuration..."
	bash srcs/requirements/wordpress/tools/make_dir.sh
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d
	echo "${NAME} Inception complete!"

down: generate-env
	echo "Stopping configuration ${NAME}..."
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

re: down build
	printf "Rebuilding and relaunching WordPress configuration...\n"
	bash srcs/requirements/wordpress/tools/make_dir.sh
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env build
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d
	echo "WordPress Re-inception complete!"

clean: down
	echo "Cleaning configuration ${NAME}..."
	docker system prune -a
	sudo rm -rf ~/data/wordpress/*
	sudo rm -rf ~/data/mariadb/*
	echo "${NAME} Inception tidied up."

fclean:
	printf "Initiating a total clean of all Docker configurations...\n"
	docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down
	docker system prune -a --volumes
	sudo rm -rf ~/data/wordpress/*
	sudo rm -rf ~/data/mariadb/*
	echo "All Docker configurations purged."

.PHONY: generate-env run all
