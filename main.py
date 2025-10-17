from fastapi import FastAPI, Request
import os

app = FastAPI()

@app.post("/api-endpoint")
async def api_endpoint(request: Request):
    data = await request.json()
    expected_secret = os.getenv("MY_SECRET_KEY")

    # --- Secret Verification ---
    if data.get("secret") != expected_secret:
        return {"error": "unauthorized"}

    # --- Round Handling Logic ---
    round_number = data.get("round")

    if round_number == 2:
        # This is where the "Revise" logic will go.
        # For now, we'll just print a message to the server console.
        print("✅ Received a Round 2 (Revise) request.")
        return {"message": "Round 2 request acknowledged."}
    else:
        # This is the original "Build" logic for Round 1.
        print("✅ Received a Round 1 (Build) request.")
        return {
            "message": "Access granted",
            "task_received": data.get("task"),
            "brief_received": data.get("brief")
        }
