from azure.iot.hub import IoTHubRegistryManager

# Podstaw swoje dane z Azure IoT Hub (connection string do IoT Hub, nie urządzenia!)
CONNECTION_STRING = "HostName=termosmartHub.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=+hwT3cMhNEj2HLQuFl/dg5NiFN/mPc+/TAIoTARnI6g="

DEVICE_ID = "device01"

def send_c2d_message(message_text):
    try:
        registry_manager = IoTHubRegistryManager(CONNECTION_STRING)
        print(f"🚀 Wysyłam wiadomość do urządzenia {DEVICE_ID}: {message_text}")
        registry_manager.send_c2d_message(DEVICE_ID, message_text)
        print("✅ Wiadomość wysłana!")
    except Exception as e:
        print(f"❌ Błąd podczas wysyłania wiadomości: {e}")

if __name__ == "__main__":
    send_c2d_message("Testowa wiadomość C2D z chmury!")
