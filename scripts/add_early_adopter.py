import os
import argparse
import firebase_admin
from firebase_admin import credentials, auth, firestore

# Path to your service account key file
# You need to download this from your Firebase project settings
# Project settings -> Service accounts -> Generate new private key
SERVICE_ACCOUNT_KEY_PATH = os.environ.get('SERVICE_ACCOUNT_KEY_PATH', 'serviceAccountKey.json')

def initialize_firebase():
    """Initializes Firebase Admin SDK."""
    try:
        if SERVICE_ACCOUNT_KEY_PATH == 'serviceAccountKey.json':
            print("Warning: Using default 'serviceAccountKey.json'. For production, set the SERVICE_ACCOUNT_KEY_PATH environment variable.")
        cred = credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH)
        firebase_admin.initialize_app(cred)
        print("Firebase Admin SDK initialized successfully.")
    except Exception as e:
        print(f"Error initializing Firebase Admin SDK: {e}")
        print("Please ensure 'serviceAccountKey.json' is in the same directory as the script and is valid.")
        exit(1)

def add_early_adopter(email):
    """
    Records a user as an early adopter in Firestore.
    Fetches UID from Firebase Auth and adds 'type: early_adopter' to their Firestore document.
    """
    try:
        user = auth.get_user_by_email(email)
        uid = user.uid
        print(f"Found user with email '{email}', UID: {uid}")

        db = firestore.client()
        user_ref = db.collection('users').document(uid)
        user_ref.set({'type': 'early_adopter'}, merge=True)
        print(f"User '{email}' (UID: {uid}) marked as early adopter in Firestore.")

    except auth.UserNotFoundError:
        print(f"Error: User with email '{email}' not found in Firebase Authentication.")
        exit(1)
    except Exception as e:
        print(f"An error occurred: {e}")
        exit(1)

def main():
    parser = argparse.ArgumentParser(description="Add an early adopter user to Firestore.")
    parser.add_argument("--email", required=True, help="Email of the early adopter user.")
    args = parser.parse_args()

    initialize_firebase()
    add_early_adopter(args.email)

if __name__ == "__main__":
    main()
