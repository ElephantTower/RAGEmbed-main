.PHONY: all clone-frontend clone-backend init-root-env up down build clean-all clean-docker help

FRONTEND_REPO = https://github.com/ElephantTower/RAGEmbed-frontend.git
BACKEND_REPO = https://github.com/ElephantTower/RAGEmbed-backend.git
FRONTEND_DIR = frontend
BACKEND_DIR = backend
COMPOSE_FILE = docker-compose.yml
PROJECT_NAME = ragembed

all: update-root clone-frontend clone-backend init-root-env up-init-db 

build-proj: update-root clone-frontend clone-backend init-root-env build

update-root:
	@if [ -d ".git" ]; then \
		echo "Updating root repository..."; \
		git pull; \
	elif [ -d ".git" ]; then \
		echo "Root directory is not a git repository. Skipping."; \
	fi

clone-frontend:
	@if [ ! -d "$(FRONTEND_DIR)" ]; then \
		echo "Cloning frontend..."; \
		git clone $(FRONTEND_REPO) $(FRONTEND_DIR); \
	elif [ -d "$(FRONTEND_DIR)/.git" ]; then \
		echo "Updating frontend..."; \
		(cd $(FRONTEND_DIR) && git pull); \
	else \
		echo "Directory $(FRONTEND_DIR) exists but is not a git repository. Skipping."; \
	fi
	@if [ ! -f "$(FRONTEND_DIR)/.env" ] && [ -f "$(FRONTEND_DIR)/.env-example" ]; then \
		cp "$(FRONTEND_DIR)/.env-example" "$(FRONTEND_DIR)/.env"; \
		echo "Created .env from .env-example for frontend."; \
	fi

clone-backend:
	@if [ ! -d "$(BACKEND_DIR)" ]; then \
		echo "Cloning backend..."; \
		git clone $(BACKEND_REPO) $(BACKEND_DIR); \
	elif [ -d "$(BACKEND_DIR)/.git" ]; then \
		echo "Updating backend..."; \
		(cd $(BACKEND_DIR) && git pull); \
	else \
		echo "Directory $(BACKEND_DIR) exists but is not a git repository. Skipping."; \
	fi
	@if [ ! -f "$(BACKEND_DIR)/.env" ] && [ -f "$(BACKEND_DIR)/.env-example" ]; then \
		cp "$(BACKEND_DIR)/.env-example" "$(BACKEND_DIR)/.env"; \
		echo "Created .env from .env-example for backend."; \
		echo "Don't forget to change ADMIN_SECRET in $(BACKEND_DIR)/.env before starting!"; \
	fi

init-root-env:
	@if [ ! -f ".env" ] && [ -f ".env-example" ]; then \
		cp .env-example .env; \
		echo "Created root .env from .env-example."; \
	elif [ ! -f ".env" ] && [ ! -f ".env-example" ]; then \
		echo "Warning: .env and .env-example are missing in the root. Create .env manually with required variables (APP_PORT, POSTGRES_USER, etc.) for docker-compose."; \
	fi

up:
	@echo "Starting docker-compose..."
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) up -d --build

up-fg:
	@echo "Starting docker-compose in foreground..."
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) up --build

down:
	@echo "Stopping docker-compose..."
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down

build:
	@echo "Building images..."
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) build --no-cache

clean-all:
	@echo "Cleaning project..."
	@if [ -d "$(FRONTEND_DIR)" ]; then rm -rf $(FRONTEND_DIR); fi
	@if [ -d "$(BACKEND_DIR)" ]; then rm -rf $(BACKEND_DIR); fi
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down -v
	docker system prune -f

clean-docker:
	@echo "Cleaning Docker..."
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down -v
	docker system prune -f

up-init-db:
	@echo "DB initialization..."
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) --profile init up -d --build

help:
	@echo "Available targets:"
	@echo "  all            - Clone repositories, initialize .env and start with DB initialization"
	@echo "  build-proj     - Clone repositories, initialize .env and build images"
	@echo "  update-root    - Update the root git repository (if it is a git repo)"
	@echo "  clone-frontend - Clone frontend only"
	@echo "  clone-backend  - Clone backend only"
	@echo "  init-root-env  - Create root .env from .env-example (if exists)"
	@echo "  up             - Start docker-compose (up -d --build)"
	@echo "  up-fg          - Start docker-compose in foreground (up --build)"
	@echo "  down           - Stop docker-compose"
	@echo "  build          - Build images (docker compose build --no-cache)"
	@echo "  clean-all      - Clean repositories, volumes and prune Docker"
	@echo "  clean-docker   - Clean volumes and prune Docker (without repositories)"
	@echo "  up-init-db     - Start docker-compose with init (initializating DB) (--profile init up -d --build)"
	@echo "  help           - Show this help"
	@echo ""
	@echo "Requires: git, docker and docker compose installed."
	@echo "On Windows: use Git Bash or WSL."
	@echo ""
	@echo "Note: When cloning backend, .env is automatically created from .env-example."
	@echo "      Be sure to change ADMIN_SECRET in backend/.env before starting!"
	@echo "      For docker-compose, create .env in root (or use make init-root-env)."
	@echo "      Project name: '$(PROJECT_NAME)' for container isolation."