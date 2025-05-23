import logging
import azure.functions as func
import json
from shared.auth import verify_user

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        data = req.get_json()
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return func.HttpResponse("Missing email or password.", status_code=400)

        if verify_user(email, password):
            return func.HttpResponse("Login successful.", status_code=200)
        else:
            return func.HttpResponse("Invalid credentials.", status_code=401)

    except Exception as e:
        logging.exception("Login error")
        return func.HttpResponse("Server error", status_code=500)
