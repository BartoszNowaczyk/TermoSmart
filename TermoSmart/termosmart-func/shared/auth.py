import json
import os
import bcrypt

USERS_FILE = os.path.join(os.path.dirname(__file__), '..', 'users.json')

def load_users():
    if not os.path.exists(USERS_FILE):
        return []
    with open(USERS_FILE, 'r') as f:
        return json.load(f)

def save_users(users):
    with open(USERS_FILE, 'w') as f:
        json.dump(users, f, indent=2)

def register_user(email, password):
    users = load_users()
    if any(u['email'] == email for u in users):
        return False, "User already exists."
    hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()
    users.append({'email': email, 'password': hashed})
    save_users(users)
    return True, "User registered."

def verify_user(email, password):
    users = load_users()
    for user in users:
        if user['email'] == email and bcrypt.checkpw(password.encode(), user['password'].encode()):
            return True
    return False
