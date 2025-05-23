import logging
import azure.functions as func
import json
import os
from azure.iot.hub import IoTHubRegistryManager

IOTHUB_CONNECTION_STRING = "HostName=termosmartHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=+hwT3cMhNEj2HLQuFl/dg5NiFN/mPc+/TAIoTARnI6g="
DEVICE_FILE = "devices.json"

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        body = req.get_json()
        device_id = body.get('deviceId')
        user_email = body.get('userEmail')

        if not device_id or not user_email:
            return func.HttpResponse("Brak deviceId lub userEmail", status_code=400)

        # Dodaj urządzenie do IoT Hub
        registry_manager = IoTHubRegistryManager(IOTHUB_CONNECTION_STRING)
        device = registry_manager.create_device_with_sas(device_id, None, None, 'enabled')

        # Wczytaj istniejące powiązania (jeśli istnieje plik)
        devices = []
        if os.path.exists(DEVICE_FILE):
            with open(DEVICE_FILE, 'r') as f:
                try:
                    devices = json.load(f)
                except json.JSONDecodeError:
                    devices = []

        # Dodaj nowe powiązanie
        devices.append({
            "deviceId": device_id,
            "userEmail": user_email
        })

        # Zapisz z powrotem do pliku
        with open(DEVICE_FILE, 'w') as f:
            json.dump(devices, f, indent=2)

        return func.HttpResponse(
            json.dumps({
                'status': 'success',
                'deviceId': device.device_id,
                'userEmail': user_email
            }),
            status_code=200,
            mimetype="application/json"
        )

    except Exception as e:
        logging.error(f"Błąd przy dodawaniu urządzenia: {e}")
        return func.HttpResponse(f"Błąd: {str(e)}", status_code=500)
