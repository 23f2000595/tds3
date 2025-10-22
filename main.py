from fastapi import FastAPI, Request, Response

app = FastAPI()

@app.post("/api-endpoint")
async def check_secret(request: Request):

    # Read the raw body as bytes
    body_bytes = await request.body()

    # Decode bytes into a string (and strip any whitespace)
    received_secret = body_bytes.decode().strip()

    # This is the secret from your instructions
    expected_secret = "supersecret123"

    if received_secret == expected_secret:
        # If secret is correct, return success
        return {"status": "success", "message": "Secret is correct!"}
    else:
        # If secret is wrong, return an error
        # Use a 401 status code for "Unauthorized"
        return Response(content='{"error":"unauthorized"}', status_code=401)
