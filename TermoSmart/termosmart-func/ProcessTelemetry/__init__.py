import logging
import azure.functions as func
import json
from datetime import datetime
from azure.storage.blob import BlobServiceClient

# Storage connection string
STORAGE_CONNECTION = "DefaultEndpointsProtocol=https;AccountName=termosmartstorage;AccountKey=+dV/Hbrku+gHWTYOpQ2odOXvsnCnkCCA9Kf0P6FdCs1gzwSH4/gYW6MBj2j0078Nqff/pGT0Wp/6+ASt0gKSoA==;EndpointSuffix=core.windows.net"

def main(event: func.EventHubEvent):
    logging.info('📥 Wiadomości odebrane z IoT Hub')

    blob_service_client = BlobServiceClient.from_connection_string(STORAGE_CONNECTION)

    for single_event in event:  # iterujemy po liście eventów
        message = single_event.get_body().decode('utf-8')
        logging.info(f"📨 Przetwarzam wiadomość: {message}")
        data = json.loads(message)

        timestamp = datetime.utcnow().strftime("%Y%m%dT%H%M%S")
        filename = f"telemetry_{timestamp}.json"

        blob_client = blob_service_client.get_blob_client(container="telemetry", blob=filename)

        blob_client.upload_blob(json.dumps(data), overwrite=True)
        logging.info(f"✅ Zapisano plik: {filename}")

