# Define variables
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml
PROJECT_NAME = inception

# Check verbosity
ifeq ($(VERBOSE),1)
	SILENT =
else
	SILENT = @
endif

# Colours
RESET := \033[0m
BOLD := \033[1m
BLACK := \033[30m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
BLUE := \033[34m

# Directories
DIR_SECRETS = secrets
DIR_TOOLS = srcs/requirements/tools
DIR_DB_DATA = srcs/db-data
DIR_WP_DATA = srcs/wp-data

######### Targets #########

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

# Builds, (re)creates, starts, and attaches to containers for a service.
.PHONY: up
up: --secrets --volumes
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) up -d

# Stops containers and removes containers, networks, volumes, and images created by up
.PHONY: down
down:
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) down

# Services are built once and then tagged
.PHONY: build
build:
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) build

# Starts existing containers for a service
.PHONY: start
start:
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) start

# Stop the containers
.PHONY: stop
stop:
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) stop

# View output from the services
.PHONY: logs
logs:
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) logs

# List the services
.PHONY: ps
ps:
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) ps

# Remove stopped containers, networks, and volumes
.PHONY: clean
clean:
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) down -v --remove-orphans

# Restart the services
.PHONY: restart
restart:
	$(SILENT)docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) restart

# Execute a command in a running service container
.PHONY: exec
exec:
	@read -p "Service name: " service; \
	read -p "Command: " cmd; \
	docker compose -f $(DOCKER_COMPOSE_FILE) -p $(PROJECT_NAME) exec $$service $$cmd

######### Private targets #########

# Create secrets if there is no appropriate directory or the directory is empty
.PHONY: --secrets
--secrets:
	@if [ ! -d $(DIR_SECRETS) ] || [ -z "$$(ls -A $(DIR_SECRETS))" ]; then \
		echo "$(BOLD)$(BLUE)Creating secrets...$(RESET)"; \
		mkdir -p $(DIR_SECRETS); \
		cd $(DIR_SECRETS) && \
		../$(DIR_TOOLS)/generate-ssl-certs.sh && \
		../$(DIR_TOOLS)/generate-pw.sh; \
	else \
		echo "$(BOLD)$(GREEN)Secrets already exist$(RESET)"; \
	fi

# Create local volume directories
.PHONY: --volumes
--volumes:
	@if [ ! -d $(DIR_DB_DATA) ] || [ ! -d $(DIR_WP_DATA) ]; then \
		mkdir -p $(DIR_DB_DATA); \
		mkdir -p $(DIR_WP_DATA); \
	else \
		echo "$(BOLD)$(GREEN)Volumes already exist$(RESET)"; \
	fi