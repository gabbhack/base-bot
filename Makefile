PROJECT := some-bot
LOCALES_DIR := locales
LOCALES_DOMAIN := messages
LOCALES_DEFAULT := ru
VERSION := "$(shell git describe --tags --always --dirty)"
COPYRIGHT := "$(shell git config user.name) <$(shell git config user.email)>"

CODE_DIR := app

py := poetry run

.PHONY: help
help:
	@echo "Environment:"
	@echo "    help: Show this message"
	@echo "    install: Install development dependencies"
	@echo ""
	@echo "Code quality:"
	@echo "    lint: Check code by black, ruff and mypy"
	@echo "    reformat: Reformat code by black and ruff"
	@echo "Development"
	@echo "    run: Run bot"
	@echo "    migrate: Create and apply EdgeDB migration"
	@echo ""
	@echo "Docker"
	@echo "    docker-ps: Run docker-compose ps"
	@echo "    docker-build: Run docker-compose build"
	@echo "    docker-up-db: Run docker-compose up -d edgedb"
	@echo "    docker-stop-db: docker-compose stop edgedb"
	@echo "    docker-up-app: Run docker-compose up --remove-orphans tech-support-bot"
	@echo "    docker-up-app-daemon: Run docker-compose up -d --remove-orphans tech-support-bot"
	@echo "    docker-stop-app: Run docker-compose stop tech-support-bot"
	@echo "    docker-down: Run docker-compose down"
	@echo "    docker-destroy: Run docker-compose down -v --remove-orphans"
	@echo ""
	@echo "Internationalization"
	@echo "    text-init: Init babel with default language"
	@echo "    text-update: Extract and update an existing new translations"
	@echo "    text-compile: Compile translation catalogs into binary MO files"
	@echo "    text-extract: Extract localizable messages from a collection of source files"
	@echo "    text-create-language: Init babel with new language"
	@echo ""

# =================================================================================================
# Environment
# =================================================================================================
.PHONY: install
install:
	git init .
	poetry install
	edgedb project init
	$(py) pre-commit install
	git add .
	git commit -m "Initial commit"
	$(MAKE) text-init

# =================================================================================================
# Code quality
# =================================================================================================
.PHONY: lint
lint:
	$(py) black --check --diff $(CODE_DIR)
	$(py) ruff $(CODE_DIR)
	$(py) mypy $(CODE_DIR)


.PHONY: reformat
reformat:
	$(py) black $(CODE_DIR)
	$(py) ruff $(CODE_DIR)

# =================================================================================================
# Development
# =================================================================================================
.PHONY: run
run:
	$(py) python -m app

# =================================================================================================
# EdgeDB
# =================================================================================================
.PHONY: migrate
migrate:
	edgedb migration create
	edgedb migrate

# =================================================================================================
# Docker
# =================================================================================================
.PHONY: docker-ps
docker-ps:
	docker-compose ps

.PHONY: docker-build
docker-build:
	docker-compose build

.PHONY: docker-up-db
docker-up-db:
	docker-compose up -d edgedb redis

.PHONY: docker-stop-db
docker-stop-db:
	docker-compose stop edgedb redis
PHONY: docker-up-app
docker-up-app:
	docker-compose up --remove-orphans tech-support-bot

PHONY: docker-up-app-daemon
docker-up-app-daemon:
	docker-compose up -d --remove-orphans tech-support-bot

PHONY: docker-stop-app
docker-stop-app:
	docker-compose stop tech-support-bot

PHONY: docker-down
docker-down:
	docker-compose down

PHONY: docker-destroy
docker-destroy:
	docker-compose down -v --remove-orphans

# =================================================================================================
# Internationalization
# =================================================================================================
.PHONY: text-extract
text-extract:
	$(py) pybabel extract . -k "__ _" -o ${LOCALES_DIR}/${LOCALES_DOMAIN}.pot --project=${PROJECT} --version=${VERSION} --copyright-holder=${COPYRIGHT}

.PHONY: text-create-language
text-create-language:
	$(py) pybabel init -i ${LOCALES_DIR}/${LOCALES_DOMAIN}.pot -d ${LOCALES_DIR} -D ${LOCALES_DOMAIN} -l ${language}

.PHONY: text-init
text-init:
	cmd /E:ON /C mkdir ${LOCALES_DIR}
	$(MAKE) text-extract
	$(MAKE) text-create-language language=${LOCALES_DEFAULT}

.PHONY: text-update
text-update:
	$(MAKE) text-extract
	$(py) pybabel update \
		-d ${LOCALES_DIR} \
		-D ${LOCALES_DOMAIN} \
		--update-header-comment \
		-i ${LOCALES_DIR}/${LOCALES_DOMAIN}.pot

.PHONY: text-compile
text-compile:
	$(py) pybabel compile -d ${LOCALES_DIR} -D ${LOCALES_DOMAIN}
