# Backend instructions

This repository is a Python backend only. Keep instructions here focused on persistent repository norms. Use the dedicated skills for scaffolding and feature-delivery workflows.

## Use the right instruction source
- Use `.agents/skills/fastapi-backend-scaffold/` when the task is project initialization, missing boilerplate, repo restructuring, dependency setup, Docker setup, or test-environment setup.
- Use `.agents/skills/fastapi-bdd-feature/` when the task is a feature, bugfix, endpoint change, use-case change, or a behavior change that should start from a scenario and tests.

## Feature alignment gate (mandatory)
- Before implementing any feature or behavior change, ask and capture:
  - `Problem`: real friction being solved.
  - `Savings`: expected savings (time, money, frustration, risk, operational load).
  - `Why`: connection to the broader goal.
- Propose the smallest valuable first slice and ask for explicit approval.
- Do not write feature code/tests until the user approves that first slice.

## Tooling baseline (uv-first)
- Use `uv` as the default package manager and command runner.
- For new or repaired scaffolding, prefer `pyproject.toml` with `uv.lock`.
- Add runtime dependencies with `uv add <package>`.
- Add development/test dependencies with `uv add --dev <package>`.
- Run project commands with `uv run <command>` unless a repository-native wrapper already exists.
- Do not create `requirements.txt` / `requirements-dev.txt` in new scaffolding unless the repository is already standardized on those files.

## Sandbox fallback for uv
- In restricted/sandboxed sessions, set local uv paths before running uv commands:
  - PowerShell:
    - `$env:UV_CACHE_DIR = '.uv-cache'`
    - `$env:UV_PYTHON_INSTALL_DIR = '.uv-python'`
- Use this one-liner when needed:
  - `$env:UV_CACHE_DIR = '.uv-cache'; $env:UV_PYTHON_INSTALL_DIR = '.uv-python'; uv run ruff check src tests`
- Apply the same prefix pattern to other uv commands (`uv sync`, `uv run pytest`, etc.) to avoid permission blocks.

## Repository structure
- Keep source code under `src/`.
- `src/app/` is the FastAPI boundary: routers, schemas, dependencies, exception mapping, and app startup.
  - use `src/app/api/v1/` to first endpoints version
- `src/domain/` is pure business code: entities, value objects, domain services, ports, and domain errors.
- `src/use_cases/` orchestrates application behavior using domain types and domain ports.
- `src/infra/` contains concrete adapters such as SQLAlchemy repositories, DB models, external clients, and schedulers.
- `features/` stores Gherkin specifications.
- `tests/bdd/step_defs/` stores pytest-bdd step definitions.
- `MUST` not include `src` directory as module root

## Architecture rules
- Inner layers must not import outer layers.
- `src/domain/` must not depend on FastAPI, SQLAlchemy, or Pydantic.
- Keep ports in `src/domain/ports.py` unless the existing repo already uses a different consistent location.
- HTTP schemas belong in `src/app/api/v1/schemas/`.
- SQLAlchemy models belong in `src/infra/db/` only.

## Runtime rules
- In request-handling and application runtime paths, database and HTTP I/O must be async and non-blocking.
- Prefer `asyncpg`, `aiosqlite`, or `mssql+aioodbc` according to the database actually used by the project. Do not install every driver by default.
- Catch specific exceptions in `src/app/` and return structured JSON errors.

## Coding rules
- Add strict type hints to every public function and method.
- Use snake_case for functions and variables, PascalCase for classes.
- Add docstrings only where business logic is non-obvious.
- Follow existing repository conventions before introducing new patterns.
- Add or update tests for behavior changes.
- If SQLAlchemy models change, add an Alembic migration.

## Default validation commands
- `uv run pytest`
- `uv run pytest tests/bdd`
- `uv run ruff check src tests`
- `uv run ruff format src tests`
- `uv run alembic upgrade head`
- `uv run uvicorn src.app.main:app --reload`

If the repository already defines wrappers such as `make test` or `just test`, prefer the repository-native command instead of replacing it.
