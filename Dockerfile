# Use a specific, immutable image version
FROM python:3.11.9-slim

# Set standard environment variables for Python and uv
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# Create a non-root user and group for security
RUN groupadd -r appuser && useradd -r -g appuser -d /app appuser

# Pin the uv version
COPY --from=ghcr.io/astral-sh/uv:0.10.9 /uv /uvx /bin/

# Change working directory and set initial permissions
WORKDIR /app
RUN chown appuser:appuser /app

# Switch to the non-root user early to ensure installed files are owned correctly
USER appuser

# Copy dependency definition files
COPY --chown=appuser:appuser pyproject.toml uv.lock ./

# Install dependencies before source code to maximize caching
RUN uv sync --frozen --no-install-project --no-dev

# Copy the rest of the application source code
COPY --chown=appuser:appuser . .

# Final installation of the project payload
RUN uv sync --frozen --no-dev

# Expose API port
EXPOSE 8000

# Specify health check with Python's standard library to avoid installing curl
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/docs')" || exit 1

# Start the application
CMD ["uv", "run", "uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "8000"]
