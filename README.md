# Kratos Mini-PC Einrichtung

Dieses öffentliche Repository enthält Quellcode und Einrichtungsunterlagen für Kratos auf dem Mini-PC. Alle Dateien sind für jede Person im Internet sichtbar. Keine Kundendaten, Zugangsdaten, Tokens, privaten Schlüssel, Produktions-Exporte oder lokalen Datenbanken hinzufügen.

- [Server-Quellpaket herunterladen](kratos-crm-minipc-server-source-2026-11-06-v2.zip)
- [Einrichtungsanleitung für den Mini-PC](docs/mini-pc-server-setup.md)

## Stand

Das Paket enthält die lokale, nur an Loopback gebundene Lese-API und ihren SQLite-Adapter. Eine synthetische Probe für Upload, Wiederholung, Sicherung, Wiederherstellung und Abruf lief am 6. November 2026 auf dem Entwicklungsrechner erfolgreich. Das Paket wurde noch nicht auf dem Mini-PC installiert oder verbunden.

Die Sites/Vinext-Weboberfläche benötigt weiterhin Cloudflare D1 und Sites-Identität. Die lokale API ist kein eigenständiger Windows-CRM-Installer. Vor dem Start braucht sie eine passende lokale SQLite-Datenbank und eine geprüfte OAuth-Konfiguration. Das Paket enthält keine Kundendaten oder Produktionsdatenbank.

Die lokale API bindet ausschließlich an 127.0.0.1. Externes HTTPS, Microsoft-Anmeldung, Datenmigration, Windows-Dienst und Abnahme auf dem Mini-PC sind noch offen.

