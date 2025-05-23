import logging
import azure.functions as func
import json
from shared.auth import register_user

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        data = req.get_json()
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return func.HttpResponse("Missing email or password.", status_code=400)

        success, message = register_user(email, password)
        status = 200 if success else 400
        return func.HttpResponse(message, status_code=status)

    except Exception as e:
        logging.exception("Registration error")
        return func.HttpResponse("Server error", status_code=500)
