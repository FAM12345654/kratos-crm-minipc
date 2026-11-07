# Kratos Mini-PC Einrichtung

Dieses öffentliche Repository enthält Quellcode und Einrichtungsunterlagen für Kratos auf dem Mini-PC. Alle Dateien sind für jede Person im Internet sichtbar. Keine Kundendaten, Zugangsdaten, Tokens, privaten Schlüssel, Produktions-Exporte oder lokalen Datenbanken hinzufügen.

## Windows-Vorbereitung starten

Auf dem Mini-PC PowerShell öffnen und diese Befehle ausführen:

    New-Item -ItemType Directory -Path C:\Kratos -Force
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FAM12345654/kratos-crm-minipc/main/Start-Kratos-Preflight.ps1" -OutFile C:\Kratos\Start-Kratos-Preflight.ps1
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Kratos\Start-Kratos-Preflight.ps1

Das Skript prüft und lädt das veröffentlichte Quellpaket mit SHA-256-Prüfung, installiert bei Bedarf Node.js LTS und pnpm, installiert Abhängigkeiten anhand der Lockdatei und führt die synthetische Probe aus. Es verändert keine vorhandenen Kratos-Ordner und startet keinen produktiven Dienst.

- [Vorbereitungsskript ansehen](Start-Kratos-Preflight.ps1)
- [Read-only-Bestandsaufnahme für den Mini-PC](Get-Kratos-MiniPcReadiness.ps1)
- [Detaillierte Einrichtungsanleitung](docs/mini-pc-server-setup.md)
- [Server-Quellpaket herunterladen](kratos-crm-minipc-server-source-2026-11-06-v2.zip)

## Auf dem Mini-PC abholen

Falls das Repository am Mini-PC nicht lokal geöffnet ist, kann der lokale GPT die Checkliste über PowerShell in einen eigenen Unterordner laden. Der Befehl bricht ab, wenn die Zieldatei schon existiert, und überschreibt daher keine vorhandene Datei:

    New-Item -ItemType Directory -Path C:\Kratos\handoff -Force
    $taskFile = "C:\Kratos\handoff\mini-pc-dauerbetrieb-fernwartung-chat-sync.md"
    if (Test-Path $taskFile) { throw "Zieldatei existiert bereits; erst prüfen, nicht überschreiben." }
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/FAM12345654/kratos-crm-minipc/main/docs/mini-pc-dauerbetrieb-fernwartung-chat-sync.md" -OutFile $taskFile
    Get-Content -LiteralPath $taskFile

## Nächster Arbeitsschritt

- [Dauerbetrieb, sicherer Fernzugriff und Chat-Synchronisierung](docs/mini-pc-dauerbetrieb-fernwartung-chat-sync.md)
- [ChatGPT-Anbindung über Secure MCP Tunnel und Prüfliste für zuhause](docs/chatgpt-tunnel-handoff.md)

## Interface-Ausbau

- [Kundenprofile, Vertragsmasken und doppelte Dokumentablage](docs/kundenprofile-vertragsmasken-und-dokumente.md)

## Was noch nicht bereit ist

Das Quellpaket enthält eine lokale, nur an Loopback gebundene Lese-API und ihren SQLite-Adapter. Es ist kein eigenständiger Windows-CRM-Installer. Die API benötigt eine passende lokale SQLite-Datenbank und ein geprüftes OAuth-Profil. Das Paket erstellt oder migriert diese Datenbank nicht. Der lokale Miniflare-Zustand ist keine operative SQLite-Datenbank.

Die Sites/Vinext-Weboberfläche benötigt weiterhin Cloudflare D1 und Sites-Identität. Externes HTTPS, Microsoft-Anmeldung, Datenmigration, Windows-Dienst, ChatGPT-/Mobilzugriff und Abnahme auf dem Mini-PC sind noch offen. Die API ist nicht von anderen Geräten erreichbar. Keine Routerfreigaben und keinen Dokumenten-Upload oder Schreibzugriff aktivieren.

Die Vorbereitung erzeugt keine Kundendaten und greift nicht auf OneDrive, Produktions-D1 oder Kundenordner zu. Sie ist kein signiertes oder getaggtes Software-Release.
