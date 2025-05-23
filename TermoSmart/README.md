# TermoSmart – Inteligentny System IoT do Monitorowania Temperatury

## 📌 Opis projektu

TermoSmart to aplikacja IoT umożliwiająca zdalne monitorowanie temperatury w pomieszczeniach za pomocą symulatora urządzenia. Użytkownik może dodawać urządzenia, przeglądać dane oraz zarządzać kontem.

## 🧩 Komponenty systemu

- **Symulator IoT**: symuluje urządzenie wysyłające dane temperatury.
- **Azure IoT Hub**: odbiera dane z urządzeń.
- **Azure Function App**: backend z logiką biznesową oraz REST API.
- **Azure Storage**: przechowuje dane.
- **Frontend**: prosty interfejs użytkownika (`index.html`).
- **Postman**: kolekcja do testowania API.

---

## ☁️ Zasoby Azure (Region: West Europe)

| Nazwa                | Typ zasobu                    |
|----------------------|-------------------------------|
| TermoSmart-RG        | Resource Group                |
| termosmartfunction   | Function App                  |
| termosmartstorage    | Storage Account               |
| termosmartHub        | IoT Hub                       |
| termosmartfunction   | Application Insights          |
| WestEuropeLinuxDynamicPlan | App Service Plan (Linux)|
| Smart Detection AG   | Action Group (Alerts)         |

---

## 🚀 Uruchomienie lokalne

### 1. Wymagania:
- Python 3.10+
- Azure CLI
- Node.js (do obsługi frontendu – opcjonalnie)
- Visual Studio Code (rekomendowane)

### 2. Instalacja backendu (Azure Functions)

```bash
cd termosmart-func
python -m venv .venv
source .venv/bin/activate  # lub .venv\Scripts\activate na Windows
pip install -r requirements.txt
func start
3. Uruchomienie symulatora IoT
Edytuj sensor_simulator.py i ustaw:

python
iot_hub_connection_string = "<YOUR_IOTHUB_DEVICE_CONNECTION_STRING>"

Potem uruchom:

bash
python sensor_simulator.py
🧪 Testowanie API (Postman)
Otwórz plik termostart.postman_collection.json w Postmanie.

Przetestuj endpointy: rejestracja użytkownika, logowanie, dodanie urządzenia, pobieranie temperatury.

👥 Przykładowi użytkownicy
Plik users.json zawiera wstępnie dodanych użytkowników.
Możesz dodać nowe konta przez REST API (POST /register).

🔐 Bezpieczeństwo
Dane przechowywane lokalnie (JSON); dla produkcji należy użyć bazy danych.

Brak autoryzacji JWT – rekomendowane do wdrożenia.

Komunikacja z IoT Hub przez bezpieczne połączenie.

⚙️ Infrastruktura jako kod (przykład komend do utworzenia zasobów)
bash
# Utwórz grupę zasobów
az group create --name TermoSmart-RG --location "westeurope"

# Storage Account
az storage account create \
  --name termosmartstorage \
  --location westeurope \
  --resource-group TermoSmart-RG \
  --sku Standard_LRS

# IoT Hub
az iot hub create \
  --name termosmartHub \
  --resource-group TermoSmart-RG \
  --location westeurope \
  --sku F1

# App Service Plan
az appservice plan create \
  --name WestEuropeLinuxDynamicPlan \
  --resource-group TermoSmart-RG \
  --location westeurope \
  --is-linux \
  --sku Y1

# Function App
az functionapp create \
  --name termosmartfunction \
  --storage-account termosmartstorage \
  --resource-group TermoSmart-RG \
  --plan WestEuropeLinuxDynamicPlan \
  --runtime python \
  --runtime-version 3.10 \
  --functions-version 4 \
  --os-type Linux

# Application Insights
az monitor app-insights component create \
  --app termosmartfunction \
  --location westeurope \
  --resource-group TermoSmart-RG \
  --application-type web