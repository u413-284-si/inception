# Define variables
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml
PROJECT_NAME = inception

# Colours
RESET := \033[0m
BOLD := \033[1m
BLACK := \033[30m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
BLUE := \033[34m

# Default target: Show help
.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  up       - Start the services defined in docker-compose.yml"
	@echo "  down     - Stop and remove the services"
	@echo "  build    - Build or rebuild the services"
	@echo "  start    - Start the services"
	@echo "  stop     - Stop the services"
	@echo "  logs     - View output from the services"
	@echo "  ps       - List the services"
	@echo "  clean    - Remove stopped containers, networks, and volumes"
	@echo "  restart  - Restart the services"
	@echo "  exec     - Execute a command in a running service container"
	@echo "  help     - Show this help message"

# Start the services
.PHONY: up
up:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) up -d

# Stop and remove the services
.PHONY: down
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) down

# Build or rebuild the services
.PHONY: build
build:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) build

# Start the services
.PHONY: start
start:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) start

# Stop the services
.PHONY: stop
stop:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) stop

# View output from the services
.PHONY: logs
logs:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) logs

# List the services
.PHONY: ps
ps:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) ps

# Remove stopped containers, networks, and volumes
.PHONY: clean
clean:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) down -v --remove-orphans

# Restart the services
.PHONY: restart
restart:
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) restart

# Execute a command in a running service container
.PHONY: exec
exec:
	@read -p "Service name: " service; \
	read -p "Command: " cmd; \
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) exec $$service $$cmd
