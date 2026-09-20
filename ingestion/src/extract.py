import json
import os
import sys
import tempfile
from http.server import BaseHTTPRequestHandler, HTTPServer

from google.cloud import secretmanager, storage

PROJECT_ID = os.environ.get("PROJECT_ID")
SECRET_ID = os.environ.get("SECRET_ID", "kaggle_api_key")
BUCKET_NAME = os.environ.get("BUCKET_NAME", "olist-dataops-73908-raw-bronze")
DATASET = "olistbr/brazilian-ecommerce"


def get_kaggle_credentials() -> dict:
    """Retrieve Kaggle credentials from Google Secret Manager."""
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{PROJECT_ID}/secrets/{SECRET_ID}/versions/latest"
    response = client.access_secret_version(request={"name": name})
    payload = response.payload.data.decode("UTF-8").strip()
    try:
        return json.loads(payload)
    except json.JSONDecodeError:
        return {"token": payload}


def setup_kaggle_env():
    """Set Kaggle environment variables and files from retrieved credentials."""
    creds = get_kaggle_credentials()
    if "token" in creds:
        token = creds["token"]
        os.environ["KAGGLE_API_TOKEN"] = token
        kaggle_dir = os.path.expanduser("~/.kaggle")
        os.makedirs(kaggle_dir, exist_ok=True)
        token_file = os.path.join(kaggle_dir, "access_token")
        with open(token_file, "w") as f:
            f.write(token)
        os.chmod(token_file, 0o600)
    else:
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


class IngestionHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        try:
            print("Received trigger request. Starting ingestion...")
            main()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(b'{"status": "success", "message": "Ingestion completed"}\n')
        except Exception as e:
            print(f"Ingestion failed: {e}", file=sys.stderr)
            self.send_response(500)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(f'{{"status": "error", "message": "{str(e)}"}}\n'.encode("utf-8"))

    def do_GET(self):
        # Health check endpoint for Cloud Run
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.end_headers()
        self.wfile.write(b"OK\n")


def run_server():
    port = int(os.environ.get("PORT", "8080"))
    server = HTTPServer(("0.0.0.0", port), IngestionHandler)
    print(f"Ingestion service listening on port {port}...")
    server.serve_forever()


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--cli":
        main()
    else:
        run_server()
