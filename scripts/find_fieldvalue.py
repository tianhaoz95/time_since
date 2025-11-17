import inspect
import sys

try:
    import google.cloud.firestore_v1 as firestore_v1
    print("Successfully imported google.cloud.firestore_v1")

    found_field_value = False
    for name in dir(firestore_v1):
        obj = getattr(firestore_v1, name)
        if inspect.isclass(obj) and name == 'FieldValue':
            print(f"Found FieldValue as a class directly in google.cloud.firestore_v1: {obj}")
            found_field_value = True
            break
        elif inspect.ismodule(obj):
            try:
                for sub_name in dir(obj):
                    sub_obj = getattr(obj, sub_name)
                    if inspect.isclass(sub_obj) and sub_name == 'FieldValue':
                        print(f"Found FieldValue as a class in google.cloud.firestore_v1.{name}: {sub_obj}")
                        found_field_value = True
                        break
            except Exception:
                # Some modules might not be inspectable or raise errors
                pass
        if found_field_value:
            break

    if not found_field_value:
        print("FieldValue class not found directly in google.cloud.firestore_v1 or its immediate submodules.")
        print("Attempting to find FieldValue within google.cloud.firestore.base_base.field_value")
        try:
            from google.cloud.firestore_v1.base_base import field_value as base_field_value
            if hasattr(base_field_value, 'FieldValue'):
                print(f"Found FieldValue in google.cloud.firestore_v1.base_base.field_value: {base_field_value.FieldValue}")
                found_field_value = True
        except ImportError:
            print("Could not import google.cloud.firestore_v1.base_base.field_value")
        except Exception as e:
            print(f"Error checking google.cloud.firestore_v1.base_base.field_value: {e}")

    if not found_field_value:
        print("FieldValue class still not found. Listing top-level attributes of google.cloud.firestore_v1:")
        for name in dir(firestore_v1):
            print(f"- {name}")

except ImportError as e:
    print(f"Failed to import google.cloud.firestore_v1: {e}")
    print("Please ensure google-cloud-firestore is installed in your environment.")
except Exception as e:
    print(f"An unexpected error occurred: {e}")

