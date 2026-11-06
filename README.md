# Kratos CRM — Familienhelden

Öffentliches Repository für den Kratos-Quellcode und die Mini-PC-Anleitung.

- [Quellcode als ZIP herunterladen](kratos-crm-minipc-source.zip)
- [Mini-PC-Anleitung](docs/mini-pc-server-setup.md)

## Quellcode auf dem Mini-PC holen

Das GitHub-Repository enthält das Quellcode-Paket als ZIP. Klone das Paket-Repository und entpacke die ZIP in einen getrennten Quellcodeordner:

    git clone https://github.com/FAM12345654/kratos-crm-minipc.git C:\Kratos\github
    Expand-Archive C:\Kratos\github\kratos-crm-minipc-source.zip -DestinationPath C:\Kratos\source
    Set-Location C:\Kratos\source
    pnpm install --frozen-lockfile --store-dir C:\Kratos\pnpm-store

## Status

Der aktuelle Quellcode ist die veröffentlichte Sites-Webanwendung mit Cloudflare D1. Er ist noch kein produktionsfertiger Windows-CRM-Server. Für sicheren Mini-PC-Produktivbetrieb müssen SQLite-Adapter, geschützte OAuth-Anmeldung, Graph-Token-Erneuerung, Dienstbetrieb sowie Backup und Wiederherstellung umgesetzt und geprüft werden.

Keine echten Kundendaten, Zugangsdaten oder privaten Schlüssel in dieses öffentliche Repository laden.
