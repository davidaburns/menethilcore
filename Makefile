APP_NAME := menethilcore-auth
APP_IMPORT := github.com/davidaburns/menethilcore
BUILD_VERSION := $(shell git describe --tags --abbrev=0)
BUILD_NUMBER := $(shell git rev-list --count HEAD)
BUILD_COMMIT := $(shell git rev-parse --short HEAD)
BUILD_TIME := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
DOCKER_REGISTRY := docker.io
DOCKER_IMAGE := $(APP_NAME)

# Colors for terminal output
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

.PHONY: help
help: ## Show this help message
	@echo 'Usage:'
	@echo '  make [target]'
	@echo ''
	@echo 'Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

.PHONY: build
build: ## Build Docker image
	@echo "$(YELLOW)Building Docker image...$(NC)"
	docker build \
		--build-arg BUILD_IMPORT=$(APP_IMPORT) \
		--build-arg BUILD_NAME=$(APP_NAME) \
		--build-arg BUILD_VERSION=$(BUILD_VERSION) \
		--build-arg BUILD_NUMBER=$(BUILD_NUMBER) \
		--build-arg BUILD_COMMIT=$(BUILD_COMMIT) \
		--build-arg BUILD_TIME=$(BUILD_TIME) \
		-t $(DOCKER_IMAGE):$(BUILD_VERSION) \
		-t $(DOCKER_IMAGE):latest \
		.
	@echo "$(GREEN)Build complete!$(NC)"

.PHONY: run
run: ## Run Docker container locally
	make build && \
	docker run --rm \
		-p 3724:3724 \
		-p 8085:8085 \
		--name $(APP_NAME) \
		$(DOCKER_IMAGE):$(BUILD_VERSION)

.PHONY: clean
clean: ## Remove Docker images
	docker rmi -f $(DOCKER_IMAGE):$(BUILD_VERSION) $(DOCKER_IMAGE):latest 2>/dev/null || true

.PHONY: fmt
fmt:   ## Format files via Golangs formatter
	go fmt ./...

.PHONY: tidy
tidy:  ## Tidy up the module
	go mod tidy

.PHONY: test
test:  ## Run unit tests
	go test ./...
