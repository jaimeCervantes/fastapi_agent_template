from fastapi import FastAPI

app = FastAPI(
    title="FastAPI Backend Template",
    description="Reusable template for FastAPI backends with clean architecture and BDD",
    version="0.1.0",
)


@app.get("/health")
async def health_check():
    return {"status": "ok"}
