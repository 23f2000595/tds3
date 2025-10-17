from fastapi import FastAPI, Request
import os

app = FastAPI()

@app.post("/api-endpoint")
async def api_endpoint(request: Request):
    data = await request.json()
    expected_secret = os.getenv("MY_SECRET_KEY")
    
    # Secret verification
    if data.get("secret") != expected_secret:
        return {"error": "unauthorized"}
    
    # Minimal response
    response = {
        "message": "Access granted",
        "task_received": data.get("task"),
        "brief_received": data.get("brief")
    }
    return response
