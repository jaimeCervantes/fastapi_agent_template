---
name: fastapi-backend-scaffold
description: initialize or repair a fastapi backend repository that uses clean architecture, async sqlalchemy, alembic, pytest, pytest-bdd, and uv-managed dependencies. use this skill when the task is project setup, missing boilerplate, repo restructuring, dependency separation, docker or pytest setup, or creating the base backend folder layout. do not use it for implementing a specific business feature unless the blocking issue is missing project scaffolding.
---

# FastAPI backend scaffold

Use this skill for setup work, not feature delivery.

## Workflow

1. Decide whether the task is **initialize from scratch** or **repair existing scaffolding**.
2. Detect current dependency tooling and preserve working conventions that are already consistent.
3. If no tooling is clearly established, default to `uv`.
4. Validate `uv` availability (`uv --version`) before running any `uv ...` command.
5. If `uv` is missing, install it first and then re-check `uv --version`.
6. Validate `git` availability (`git --version`) before repository bootstrapping.
7. If `git` is missing, install it first and then re-check `git --version`.
8. If the project is not a git repository, initialize it (`git init -b main` or equivalent).
9. Create or repair the backend structure under `src/`, plus `features/` and `tests/bdd/step_defs/`.
10. Create foundational files only when missing or clearly broken:
   - `.gitignore`
   - `.dockerignore`
   - `pyproject.toml`
   - `uv.lock`
   - `pytest.ini`
   - `MUST` not include `src` directory as module root
11. Keep changes minimal and avoid inventing extra root folders.

## Dependency management (uv-first)

- Add runtime packages with `uv add <package>`.
- Add development and test packages with `uv add --dev <package>`.
- Sync the environment with `uv sync`.
- Run project commands with `uv run <command>`.
- Do not create `requirements.txt` / `requirements-dev.txt` for new scaffolding unless the repository is already standardized on them.
- Install only the database driver actually needed by the project; do not include every async driver by default.

## `uv` installation fallback

If `uv --version` fails, install `uv` before continuing:

- Windows (preferred when available):
  - `winget install --id=astral-sh.uv -e`
- Windows (Chocolatey fallback):
  - `choco install uv -y`
- macOS/Linux (official installer):
  - `curl -LsSf https://astral.sh/uv/install.sh | sh`

After installation:

- Re-open the shell if needed so PATH changes are loaded.
- Verify with `uv --version`.

## `git` installation fallback

If `git --version` fails, install Git before continuing:

- Windows (preferred when available):
  - `winget install --id Git.Git -e`
- Windows (Chocolatey fallback):
  - `choco install git -y`
- macOS:
  - `brew install git`
- Linux (Debian/Ubuntu):
  - `sudo apt-get update && sudo apt-get install -y git`

After installation:

- Re-open the shell if needed so PATH changes are loaded.
- Verify with `git --version`.

## Blocker handling

If a blocker appears (permissions, missing tooling, network restrictions, failed installs, or unclear scope), explicitly ask whether to continue by resolving the blocker now or stop and leave the task paused. Do not silently skip blocked steps.
If the blocker is likely caused by sandbox restrictions or elevated permission needs, request explicit permission to run the required command with escalation and then retry the failed command.

## Required structure

Use this layout unless the existing repository already has a clearly established equivalent:

```text
src/
  app/
    api/v1/routers/
    api/v1/schemas/
    deps/
    main.py
  domain/
    models/
    services/
    errors.py
    ports.py
  use_cases/
    commands/
    queries/
  infra/
    db/
    clients/
    scheduler/
features/
tests/
  bdd/step_defs/
```

## Scaffolding rules

- `src/domain/` stays framework-free. Use dataclasses, enums, value objects, ABCs, and stdlib only.
- Do not place Pydantic models in `src/domain/` when `src/app/api/v1/schemas/` exists for HTTP schemas.
- Keep SQLAlchemy models and repositories in `src/infra/db/`.
- Keep ports in `src/domain/ports.py` unless the repository already uses another consistent location.
- Separate production and development dependencies.
- Prefer repository-native wrappers (`make`, `just`) when already present.

## Foundation file defaults

- `.gitignore` must exclude virtual environments, caches, local SQLite files, and `.env` files.
- `.dockerignore` must keep build context small and exclude VCS data, local environments, caches, secrets, and usually `tests/` and `features/` unless the image is explicitly for testing.
- `pyproject.toml` should define project metadata and dependency groups cleanly.
- `uv.lock` must be regenerated when dependencies change.
- `pytest.ini` should match the repository's import strategy. Do not force `pythonpath = .` if the repo expects `pythonpath = src` or an editable install.

## What to avoid

- Do not add a rigid feature workflow here; that belongs to the feature-delivery skill.
- Do not rewrite a working project just to match this exact structure.
- Do not add sync DB drivers or blocking I/O in runtime paths.
- Do not add placeholder example files that the repository will not actually use.
- Do not mix unmanaged `pip install` usage with a `uv`-managed workflow.

## Deliverables

When this skill is used, produce the minimum set of files and folders needed for the backend to build, test, and accept future feature work cleanly with `uv`-managed dependencies.
