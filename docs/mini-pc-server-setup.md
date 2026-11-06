# Kratos: Quellpaket für den Mini-PC

Stand: 6. November 2026. Dieses Repository ist öffentlich. Jede Datei ist im Internet sichtbar. Keine Kundendaten, Datenbanken, Tokens, Passwörter, privaten Schlüssel oder Produktions-Exporte hochladen.

## Quellpaket herunterladen

Auf dem Mini-PC PowerShell öffnen und ausführen:

    New-Item -ItemType Directory -Path C:\Kratos -Force
    Invoke-WebRequest -Uri "https://github.com/FAM12345654/kratos-crm-minipc/raw/refs/heads/main/kratos-crm-minipc-server-source-2026-11-06-v2.zip" -OutFile C:\Kratos\kratos-crm-minipc-server-source.zip
    Get-FileHash C:\Kratos\kratos-crm-minipc-server-source.zip -Algorithm SHA256
    Expand-Archive -LiteralPath C:\Kratos\kratos-crm-minipc-server-source.zip -DestinationPath C:\Kratos\server

SHA-256 des Pakets: 7BAEE5EAD83D3F48093080C39EAC95138EF58A31283156E2D5788A3987E27D75

Das ZIP als unveränderten Quellstand aufbewahren. Nicht in einen bestehenden Ordner entpacken.

## Voraussetzungen und synthetische Probe

Benötigt werden Windows x64/ARM64 passend zum Gerät, Node.js 22.16 oder neuer und pnpm 11. Node.js nur von der offiziellen Node.js-Webseite installieren. Danach ein neues PowerShell-Fenster öffnen und in C:\Kratos\server ausführen:

    pnpm install --frozen-lockfile
    node scripts/kratos-local-rehearsal.mjs

Die Probe verwendet temporäre synthetische Datensätze und Dateien und entfernt die temporären Daten anschließend. Sie greift nicht auf OneDrive, die Produktions-D1-Datenbank oder Kundenordner zu. Die Ausgabe muss status "ok" und scope "synthetic_rehearsal" melden.

## Was noch nicht bereit ist

Den Dienst noch nicht mit echten Daten starten. Die API benötigt eine vorhandene lokale SQLite-Datenbank mit passendem Kratos-Schema und ein separat eingerichtetes, geprüftes OAuth-Profil. Das Paket erstellt und migriert diese Datenbank nicht. Den .wrangler-Miniflare-Zustand nicht als operative SQLite-Datenbank verwenden.

Die API ist auf 127.0.0.1 beschränkt. Ohne geprüfte Authentifizierung, HTTPS und separate Zugangsplanung ist sie weder vom Laptop noch von ChatGPT, Claude oder aus dem Internet erreichbar. Keine Routerfreigaben und keinen Dokumenten-Upload oder Schreibzugriff aktivieren.

Die bestehende Sites/Vinext-Oberfläche benötigt weiterhin Cloudflare D1 und die von Sites bereitgestellte Identität. Dieses Paket macht sie nicht zu einer eigenständigen Windows-App. Es installiert keinen Windows-Dienst und ändert keine Energie-, Firewall-, SSH- oder Benutzerkontoeinstellungen.

Der lokale Quellstand basiert auf Branch dev/kratos-vollmacht-status mit Basis-Commit 88199c9 und enthält unveröffentlichte Arbeitsänderungen vom 6. November 2026. Dies ist ein Einrichtungspaket, keine signierte oder getaggte Softwareveröffentlichung.

