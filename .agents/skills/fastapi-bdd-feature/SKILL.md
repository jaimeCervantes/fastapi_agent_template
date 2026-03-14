---
name: fastapi-bdd-feature
description: implement or change backend behavior in a fastapi clean-architecture project by working from a small gherkin scenario to tests and then code, using uv for execution and validation. use this skill for features, bug fixes, endpoint changes, query or command behavior, and domain-driven backend work that should be validated with pytest or pytest-bdd. do not use it for first-time project setup or boilerplate-only tasks; use the scaffold skill for that.
---

# FastAPI BDD feature delivery

Use this skill for behavior changes. Start from a small scenario, then tests, then implementation.

## Default workflow

0. Alignment gate (mandatory, no exceptions):
  1. Ask the user for:
     - **The Problem:** What real friction exists?
     - **The Savings:** What do we save? (time, money, frustration, risk, operational load)
     - **The Why:** How does it connect to the bigger goal? Purpose and direction
  2. Propose the smallest valuable behavior slice based on the request.
  3. Ask for explicit agreement before writing any feature code/tests.
  4. If agreement is missing, stop and wait. Do not scaffold or implement.
1. Ask clarifying questions only if a real blocker prevents implementation. Maximum: three concise questions.
2. Create or update one Gherkin spec in `features/<feature_name>.feature`.
3. Choose one priority scenario that can be implemented end-to-end in a small slice.
4. Add or update tests first.
5. Implement from inner layers outward:
   - `src/domain/`
   - `src/use_cases/`
   - `src/infra/`
   - `src/app/`
6. If new dependencies are needed, use the best ones and add them with `uv add ...` or `uv add --dev ...` and sync the environment with `uv sync`.
7. Run validations with `uv run ...` commands and report any migration command if models changed.
8. Suggest the next scenario instead of forcing an artificial loop.

Use this exact prompt template in step 0:
- Problem:
- Savings:
- Why:
- Proposed first slice:
- Do you approve this first slice before implementation? (yes/no)

## Blocker handling

If a blocker appears (permissions, missing tooling, network restrictions, failed tests/install, or unclear scope), explicitly ask whether to continue by resolving the blocker now or stop and leave the task paused.
If the blocker is likely caused by sandbox restrictions or elevated permission needs, request explicit permission to run the required command with escalation and then retry the failed command.

## Gherkin rules

Use a compact feature file with business context when it is known or can be inferred safely.

```gherkin
Feature: [Feature Name]

  Context:
  - Problem: [real friction]
  - Savings: [time, money, risk, or frustration saved]
  - Why: [connection to the broader goal]

  As a [role]
  I want to [action]
  So that [benefit]
```

Do not skip this framing stage. If context is incomplete, ask concise clarification questions and wait for explicit agreement on feature scope and the first scenario.

## Testing rules

- Prefer `pytest-bdd` for behavior-level coverage tied to the feature file.
- Use unit tests with mocks for use-case logic.
- Use async integration tests only when the behavior genuinely depends on infra wiring.
- Keep test data minimal and focused on the scenario under implementation.
- Do not overbuild multiple scenarios before the first one is green.

Recommended validation commands:
- `uv run pytest`
- `uv run pytest tests/bdd`
- `uv run ruff check src tests`

## Implementation rules

- Follow repository conventions before introducing new abstractions.
- Keep `src/domain/` free of FastAPI, SQLAlchemy, and Pydantic.
- Keep HTTP schemas in `src/app/api/v1/schemas/`.
- Catch specific exceptions in `src/app/` and map them to structured HTTP errors.
- Make runtime DB and HTTP I/O async and non-blocking.
- Write only the code needed to satisfy the selected scenario cleanly.
- `MUST` not include `src` directory as module root

## Coding Standards (STRICT)

You already know PEP 8, Clean Code, Clean Architecture and SOLID principles. Apply them ruthlessly. Additionally, enforce these specific rules:

- **Typing:** EVERY function signature MUST have strict Python type hints (e.g., `def get_user(user_id: int) -> User:`).
- **Docstrings:** Use Google-style docstrings ONLY for complex business logic. Do not write obvious docstrings for simple getters/setters.
- **Error Handling:** Never return generic 500 errors. Catch specific exceptions in the `app` layer and return structured JSON responses.
- **Naming:** Variables and functions `MUST` be in `snake_case`. Classes in `PascalCase`.

## Migration rule

If SQLAlchemy models under `src/infra/db/` change, report the exact Alembic command needed:

```bash
uv run alembic revision --autogenerate -m "<desc>"
```

## What to avoid

- Do not stop after writing Gherkin if the task can be implemented now.
- Do not ask the user for a "small scenario" if you can derive one from the request.
- Do not turn every task into a multi-round ceremony.
- Do not let outer layers leak into inner layers.
- Do not jump into coding before problem framing and feature-scope agreement.
- Do not start implementation without explicit user approval from the alignment gate.
