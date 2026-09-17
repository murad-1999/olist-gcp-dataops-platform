import os
import json
import tempfile
from google.cloud import secretmanager
from google.cloud import storage
PROJECT_ID = os.environ.get("PROJECT_ID")
SECRET_ID = os.environ.get("SECRET_ID", "kaggle_api_key")
BUCKET_NAME = os.environ.get("BUCKET_NAME", "olist-dataops-73908-raw-bronze")
DATASET = "olistbr/brazilian-ecommerce"


def get_kaggle_credentials() -> dict:
    """Retrieve Kaggle credentials from Google Secret Manager."""
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{PROJECT_ID}/secrets/{SECRET_ID}/versions/latest"
    response = client.access_secret_version(request={"name": name})
    payload = response.payload.data.decode("UTF-8")
    return json.loads(payload)


def setup_kaggle_env():
    """Set Kaggle environment variables from retrieved credentials."""
    creds = get_kaggle_credentials()
    os.environ["KAGGLE_USERNAME"] = creds.get("username", "")
    os.environ["KAGGLE_KEY"] = creds.get("key", "")


def download_dataset(download_path: str):
    """Download and unzip the Kaggle dataset to the specified path."""
    import kaggle

    kaggle.api.authenticate()
    kaggle.api.dataset_download_files(DATASET, path=download_path, unzip=True)


def upload_to_gcs(source_path: str, bucket_name: str):
    """Upload extracted files to a Google Cloud Storage bucket."""
    storage_client = storage.Client(project=PROJECT_ID)
    bucket = storage_client.bucket(bucket_name)

    for root, _, files in os.walk(source_path):
        for file in files:
            file_path = os.path.join(root, file)
            blob_name = os.path.relpath(file_path, source_path)
            blob = bucket.blob(blob_name)

            # Idempotency check: skip if file already exists
            if blob.exists():
                print(f"File {blob_name} already exists in {bucket_name}, skipping.")
                continue

            print(f"Uploading {blob_name} to {bucket_name}...")
            blob.upload_from_filename(file_path)


def main():
    if not PROJECT_ID:
        raise ValueError("PROJECT_ID environment variable is not set")

    print("Setting up Kaggle credentials from Secret Manager...")
    setup_kaggle_env()

    with tempfile.TemporaryDirectory() as temp_dir:
        print(f"Downloading dataset '{DATASET}' to temporary directory...")
        download_dataset(temp_dir)

        print(f"Uploading files to GCS bucket '{BUCKET_NAME}'...")
        upload_to_gcs(temp_dir, BUCKET_NAME)

    print("Ingestion complete.")


if __name__ == "__main__":
    main()
