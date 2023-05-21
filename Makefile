name = inception
all: build

build:
	@echo "Building configuration ${name}..."
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

up:
	@echo "Launch configuration ${name}..."
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

down:
	@echo "Stopping configuration ${name}..."
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

portainer:
	@docker volume create portainer_data
	@docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.11.1

portainer_down:
	docker rm -fv portainer
	docker rmi  portainer/portainer-ce:2.11.1
# docker volume rm portainer_data

re: down
	@echo "Rebuild configuration ${name}..."
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: down
	@echo "Cleaning configuration ${name}..."
	@docker system prune -a

fclean:
	@printf "Total clean of all configurations docker\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

.PHONY	: all build up down re clean fclean portainer portainer_down
