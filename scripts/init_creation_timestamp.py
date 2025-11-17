import os
import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud.firestore_v1 import SERVER_TIMESTAMP
from datetime import datetime

# Path to your service account key file
SERVICE_ACCOUNT_KEY_PATH = os.environ.get('SERVICE_ACCOUNT_KEY_PATH', 'serviceAccountKey.json')

def initialize_firebase():
    """Initializes Firebase Admin SDK."""
    try:
        if not firebase_admin._apps:
            if SERVICE_ACCOUNT_KEY_PATH == 'serviceAccountKey.json':
                print("Warning: Using default 'serviceAccountKey.json'. For production, set the SERVICE_ACCOUNT_KEY_PATH environment variable.")
            cred = credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH)
            firebase_admin.initialize_app(cred)
            print("Firebase Admin SDK initialized successfully.")
        else:
            print("Firebase Admin SDK already initialized.")
    except Exception as e:
        print(f"Error initializing Firebase Admin SDK: {e}")
        print("Please ensure 'serviceAccountKey.json' is in the same directory as the script and is valid.")
        exit(1)

def add_creation_timestamp_to_items():
    """
    Adds a 'createdAt' field with the current server timestamp to all items
    in each user's 'items' collection if it doesn't already exist.
    """
    db = firestore.client()
    users_ref = db.collection('users')

    print("Starting to add 'createdAt' timestamp to all items...")

    user_count = 0
    try:
        users = users_ref.stream()
        for user_doc in users:
            user_count += 1
            user_id = user_doc.id
            print(f"Processing user: {user_id}")
            items_ref = users_ref.document(user_id).collection('items')
            items = items_ref.stream()

            for item_doc in items:
                item_id = item_doc.id
                item_data = item_doc.to_dict()

                if 'createdAt' not in item_data:
                    print(f"  Adding 'createdAt' to item: {item_id} for user: {user_id}")
                    items_ref.document(item_id).update({
                        'createdAt': SERVER_TIMESTAMP
                    })
                else:
                    print(f"  Item {item_id} for user {user_id} already has 'createdAt'. Skipping.")
                            print(f"Finished processing {user_count} users and adding 'createdAt' timestamp to their items.")
                        except Exception as e:
                            print(f"An error occurred during item processing: {e}")
                            exit(1)
def main():
    initialize_firebase()
    add_creation_timestamp_to_items()

if __name__ == "__main__":
    main()
