import time
import random
import json
from azure.iot.device import IoTHubDeviceClient, Message

CONNECTION_STRING = "HostName=termosmartHub.azure-devices.net;DeviceId=device01;SharedAccessKey=SEIRhMTakvzUT8h1WCJm2JyhEvZNi+fnz2JszBykn9g="

def create_client():
    client = IoTHubDeviceClient.create_from_connection_string(CONNECTION_STRING)
    print("✅ Połączono z Azure IoT Hub!")

    # Dodaj obsługę odbierania wiadomości
    def message_handler(message):
        print(f"📥 Otrzymano wiadomość C2D: {message.data.decode('utf-8')}")

    client.on_message_received = message_handler
    return client

def send_telemetry(client):
    while True:
        temperature = round(random.uniform(18.0, 30.0), 2)
        humidity = round(random.uniform(30.0, 70.0), 2)

        payload = {
            "temperature": temperature,
            "humidity": humidity,
            "timestamp": time.strftime('%Y-%m-%d %H:%M:%S')
        }

        message = Message(json.dumps(payload))
        message.content_encoding = "utf-8"
        message.content_type = "application/json"

        print(f"📤 Wysyłanie danych: {payload}")
        client.send_message(message)
        print("✅ Wysłano do IoT Hub")
        time.sleep(10)

if __name__ == '__main__':
    try:
        client = create_client()
        send_telemetry(client)
    except KeyboardInterrupt:
        print("⛔️ Zatrzymano przez użytkownika")
