# Kratos: Vorbereitung auf dem Mini-PC

Stand: 7. November 2026. Das Repository ist öffentlich. Jede Datei ist im Internet sichtbar. Keine Kundendaten, Datenbanken, Tokens, Passwörter, privaten Schlüssel oder Produktions-Exporte hochladen.

## Einmalige Vorbereitung starten

Auf dem Mini-PC PowerShell öffnen und die drei Befehle ausführen:

    New-Item -ItemType Directory -Path C:\Kratos -Force
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FAM12345654/kratos-crm-minipc/main/Start-Kratos-Preflight.ps1" -OutFile C:\Kratos\Start-Kratos-Preflight.ps1
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Kratos\Start-Kratos-Preflight.ps1

Das Skript lädt das Quellpaket herunter und prüft dessen SHA-256. Es installiert bei Bedarf Node.js LTS und pnpm, entpackt das Paket nach C:\Kratos\server-v2, installiert die gesperrten Abhängigkeiten und führt die synthetische Probe aus. Es verwendet nur synthetische Daten. Vorhandene Serverordner werden nicht gelöscht oder überschrieben.

Die Probe muss `status: "ok"` und `scope: "synthetic_rehearsal"` melden. Bei einem Fehler anhalten und die vollständige Fehlermeldung sichern. Keine echten Kundendaten verwenden.

## Veröffentlichtes Quellpaket

- Archiv: `kratos-crm-minipc-server-source-2026-11-06-v2.zip`
- SHA-256: `7BAEE5EAD83D3F48093080C39EAC95138EF58A31283156E2D5788A3987E27D75`
- Die unveränderte ZIP-Datei bleibt unter C:\Kratos erhalten.

## Was die Vorbereitung nicht einrichtet

Das Paket enthält eine lokale, nur an 127.0.0.1 gebundene Lese-API und einen SQLite-Adapter. Die API darf noch nicht mit echten Daten gestartet werden: Eine passende operative SQLite-Datenbank und ein geprüftes OAuth-Profil fehlen. Das Paket erstellt oder migriert diese Datenbank nicht. Der .wrangler-Miniflare-Zustand ist keine operative SQLite-Datenbank.

Die Sites/Vinext-Oberfläche benötigt weiterhin Cloudflare D1 und die Sites-Identität. Dieses Quellpaket macht daraus keine eigenständige Windows-App.

Noch offen sind: produktive Datenbank samt Schema/Migration, OAuth-/Microsoft-Anmeldung, Windows-Dienst und automatischer Start, HTTPS und geschützter Zugriff von anderen Geräten, ChatGPT-MCP-Anbindung, Datenmigration, Backups und Abnahme auf dem Mini-PC. Das Vorbereitungsskript ändert keine Firewall-, Router-, SSH-, Benutzerkonto- oder Energieeinstellungen und startet keinen Dienst.

Keine Routerfreigaben, keinen Dokumenten-Upload und keinen Schreibzugriff aktivieren, bevor Authentifizierung, Berechtigungen, Auditierung und sichere HTTPS-Erreichbarkeit umgesetzt und geprüft sind.
