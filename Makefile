.DEFAULT_GOAL := help

# load .env if present; CI sets the variables directly
ENV_FILE := .env
UV_RUN := uv run $(if $(wildcard $(ENV_FILE)),--env-file $(ENV_FILE))

.PHONY: help up down load lint test evals

help: ## List targets
	@awk 'BEGIN {FS = ":.*## "} /^[a-z]+:.*## / {printf "  make %-6s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Start the Docker services and wait until they are healthy
	docker compose up -d --wait

down: ## Stop the Docker services (the data volume is kept)
	docker compose down

load: ## Load the Olist CSVs from db/data/ into Postgres
	$(UV_RUN) python db/load.py

lint: ## Ruff lint and format checks
	uv run ruff check .
	uv run ruff format --check .

test: lint ## Lint, then run the test suite (what CI runs)
	$(UV_RUN) pytest

evals: ## Run the eval harness on the dev split
	$(UV_RUN) python -m evals.run_evals --split dev
