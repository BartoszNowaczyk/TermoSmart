import logging
import azure.functions as func
import os
import json
from azure.storage.blob import BlobServiceClient
from azure.core.exceptions import ResourceNotFoundError, HttpResponseError

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("HTTP trigger function processed a request.")

    # Pobranie połączenia do Azure Blob Storage
    BLOB_CONNECTION_STRING = os.getenv("AzureWebJobsStorage")
    if not BLOB_CONNECTION_STRING:
        return func.HttpResponse(
            "Brak ustawionej zmiennej środowiskowej 'AzureWebJobsStorage'.",
            status_code=500
        )

    try:
        # Inicjalizacja klienta
        blob_service_client = BlobServiceClient.from_connection_string(BLOB_CONNECTION_STRING)
        container_name = "telemetry"
        container_client = blob_service_client.get_container_client(container_name)

        data = []

        # Iteracja po blobach w kontenerze
        for blob in container_client.list_blobs():
            try:
                blob_client = container_client.get_blob_client(blob.name)
                blob_data = blob_client.download_blob().readall()
                blob_json = json.loads(blob_data)
                data.append(blob_json)
            except json.JSONDecodeError:
                logging.warning(f"Błąd dekodowania JSON w pliku {blob.name}. Pomijam.")
                continue
            except HttpResponseError as e:
                logging.error(f"Błąd pobierania bloba {blob.name}: {e}")
                continue

        return func.HttpResponse(json.dumps(data), mimetype="application/json", status_code=200)

    except ResourceNotFoundError:
        return func.HttpResponse(
            f"Kontener '{container_name}' nie istnieje.",
            status_code=404
        )
    except Exception as e:
        logging.error(f"Wystąpił błąd: {str(e)}")
        return func.HttpResponse(
            f"Wystąpił błąd: {str(e)}",
            status_code=500
        )
