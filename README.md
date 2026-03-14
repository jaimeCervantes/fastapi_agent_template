# FastAPI Backend Template

Plantilla reusable para construir backends FastAPI con clean architecture y flujo BDD.

## Customize this template

- Update project metadata in `pyproject.toml` (`name`, `description`, version).
- Replace `features/` and `tests/` with your product scenarios.
- Replace domain/use-case code under `src/` with your app behavior.
- Update this README with your endpoint contract and business context.

## Requirements

- Python 3.11+
- `uv` installed

## Install

```bash
uv sync
```

If your environment is restricted/sandboxed and `uv` fails due cache permissions:

```bash
UV_CACHE_DIR=.uv-cache UV_PYTHON_INSTALL_DIR=.uv-python uv sync
```

PowerShell:

```powershell
$env:UV_CACHE_DIR = ".uv-cache"
$env:UV_PYTHON_INSTALL_DIR = ".uv-python"
uv sync
```

## Run API

```bash
uv run uvicorn app.main:app --reload --app-dir src
```

Base URL: `http://127.0.0.1:8000`  
Swagger: `http://127.0.0.1:8000/docs`

## Docker Production Best Practices

The included `Dockerfile` follows industry best practices to ensure security, performance, and reproducibility for production deployments:
- **Pinned Image**: Uses a specific immutable python version (`python:3.11.9-slim`).
- **Non-Root User**: Creates and switches to an `appuser` to prevent running the container as root.
- **Dependency Caching**: Installs dependencies via `uv` in a separate layer before copying application code.
- **Environment Tuning**: Disables python byte-code generation and unbuffers standard output.
- **Healthcheck**: Implements a native python health-check hitting the `/docs` endpoint.

## Local Development with Docker Compose

We provide a separated Docker Compose architecture to maintain parity between environments while keeping local development fast.

### Development Environment (Default)
To run the API with hot-reloading and an attached PostgreSQL database:
```bash
docker compose up -d
```
This automatically uses `docker-compose.yml` (base) and `docker-compose.override.yml` (which mounts local volumes and spins up a `postgres` container).

### Production Environment
To test the production image build locally without development volumes or hot-reloading:
```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```
*(Note: production environments generally connect to managed databases rather than containerized databases).*

## Database Migrations (Alembic)

The project expects a dynamic `DATABASE_URL` environment variable to run Postgres migrations using `asyncpg`.
To run migrations against the local development Postgres container:
```bash
# Set the environment variable first depending on your shell
UV_DATABASE_URL="postgresql+asyncpg://postgres:fastapi_dev_password@localhost:5433/fastapi_db" uv run alembic upgrade head
```

## Test and lint

```bash
uv run pytest
uv run pytest tests/bdd
uv run ruff check src tests
uv run ruff format src tests
```

## Project structure

```text
src/
  app/
  domain/
  use_cases/
  infra/
features/
tests/
```

## Using this Template with AI Agents

This repository is pre-configured with `AGENTS.md` and specific skills under `.agents/skills/` to help AI assistants (like GitHub Copilot Workspace, Cursor, Gemini, Claude Code, Codex, etc) understand the project architecture and workflows.

You can use prompts like:

- "Init the project"
- "I want to add a new feature..."
- "I want to fix a bug..."
- "I want to change the behavior of an endpoint..."

### SKILLS

- `fastapi-backend-scaffold`: For setting up boilerplate, repairing the repository, or dependency management.
- `fastapi-bdd-feature`: For implementing new features starting from defining the problem,Gherkin scenario, to tests, and finally to business code.

## Product-specific section (fill this)

- Domain:
- Key use cases:
- Main endpoints:
- Error model:
