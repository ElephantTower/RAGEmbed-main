.PHONY: all clone-frontend clone-backend init-root-env up down build clean help

FRONTEND_REPO = https://github.com/ElephantTower/RAGEmbed-frontend.git
BACKEND_REPO = https://github.com/ElephantTower/RAGEmbed-backend.git
FRONTEND_DIR = frontend
BACKEND_DIR = backend
COMPOSE_FILE = docker-compose.yml

all: clone-frontend clone-backend init-root-env up

clone-frontend:
	@if [ ! -d "$(FRONTEND_DIR)" ]; then \
		echo "Клонируем frontend..."; \
		git clone $(FRONTEND_REPO) $(FRONTEND_DIR); \
	elif [ -d "$(FRONTEND_DIR)/.git" ]; then \
		echo "Обновляем frontend..."; \
		(cd $(FRONTEND_DIR) && git pull); \
	else \
		echo "Директория $(FRONTEND_DIR) существует, но не является git-репозиторием. Пропускаем."; \
	fi
	@if [ ! -f "$(FRONTEND_DIR)/.env" ] && [ -f "$(FRONTEND_DIR)/.env-example" ]; then \
		cp "$(FRONTEND_DIR)/.env-example" "$(FRONTEND_DIR)/.env"; \
		echo "Создали .env из .env-example для frontend."; \
	fi

clone-backend:
	@if [ ! -d "$(BACKEND_DIR)" ]; then \
		echo "Клонируем backend..."; \
		git clone $(BACKEND_REPO) $(BACKEND_DIR); \
	elif [ -d "$(BACKEND_DIR)/.git" ]; then \
		echo "Обновляем backend..."; \
		(cd $(BACKEND_DIR) && git pull); \
	else \
		echo "Директория $(BACKEND_DIR) существует, но не является git-репозиторием. Пропускаем."; \
	fi
	@if [ ! -f "$(BACKEND_DIR)/.env" ] && [ -f "$(BACKEND_DIR)/.env-example" ]; then \
		cp "$(BACKEND_DIR)/.env-example" "$(BACKEND_DIR)/.env"; \
		echo "Создали .env из .env-example для backend."; \
		echo "Не забудьте изменить ADMIN_SECRET в $(BACKEND_DIR)/.env перед запуском!"; \
	fi

init-root-env:
	@if [ ! -f ".env" ] && [ -f ".env-example" ]; then \
		cp .env-example .env; \
		echo "Создали корневой .env из .env-example."; \
	elif [ ! -f ".env" ] && [ ! -f ".env-example" ]; then \
		echo "Предупреждение: .env и .env-example отсутствуют в корне. Создайте .env вручную с необходимыми переменными (APP_PORT, POSTGRES_USER и т.д.) для docker-compose."; \
	fi

up:
	@echo "Запускаем docker-compose..."
	docker-compose -f $(COMPOSE_FILE) up -d

down:
	@echo "Останавливаем docker-compose..."
	docker-compose -f $(COMPOSE_FILE) down

build:
	@echo "Собираем образы..."
	docker-compose -f $(COMPOSE_FILE) build --no-cache

clean:
	@echo "Очищаем проект..."
	@if [ -d "$(FRONTEND_DIR)" ]; then rm -rf $(FRONTEND_DIR); fi
	@if [ -d "$(BACKEND_DIR)" ]; then rm -rf $(BACKEND_DIR); fi
	docker-compose -f $(COMPOSE_FILE) down -v
	docker system prune -f

help:
	@echo "Доступные цели:"
	@echo "  all          - Клонировать репозитории, инициализировать .env и запустить (up)"
	@echo "  clone-frontend - Клонировать только frontend"
	@echo "  clone-backend  - Клонировать только backend"
	@echo "  init-root-env - Создать корневой .env из .env-example (если есть)"
	@echo "  up           - Запустить docker-compose (up -d)"
	@echo "  down         - Остановить docker-compose"
	@echo "  build        - Собрать образы (docker-compose build)"
	@echo "  clean        - Очистить репозитории и volumes"
	@echo "  help         - Показать эту справку"
	@echo ""
	@echo "Предполагается: git, docker и docker-compose установлены."
	@echo "На Windows: используйте Git Bash или WSL."
	@echo ""
	@echo "Примечание: При клонировании backend автоматически создастся .env из .env-example."
	@echo "           Обязательно измените ADMIN_SECRET в backend/.env перед запуском!"
	@echo "           Для docker-compose создайте .env в корне (или используйте make init-root-env)."
