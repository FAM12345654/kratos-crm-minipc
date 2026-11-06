# Kratos auf dem Windows-Mini-PC

Stand: 6. November 2026

## Offizielle Downloads

- [Node.js LTS für Windows](https://nodejs.org/en/download) — erforderlich ist Node.js >=22.13.0; dort x64 oder ARM64 passend zum Gerät auswählen.
- [Git for Windows](https://git-scm.com/install/windows) — offiziellen Installer für die Gerätearchitektur wählen.
- [GitHub CLI](https://cli.github.com/) — optional für GitHub-Arbeit im Terminal.

Installer direkt vom offiziellen Anbieter herunterladen. Keine Installer, Tokens oder Passwörter in dieses Repository stellen.

## Quellcode aus GitHub holen

PowerShell öffnen und ausführen:

    git clone https://github.com/FAM12345654/kratos-crm-minipc.git C:\Kratos\source
    Set-Location C:\Kratos\source

Das Repository enthält eine vollständige Quellcode-ZIP-Datei. Falls du die ZIP verwendest, lade kratos-crm-minipc-source.zip aus GitHub herunter und entpacke sie in C:\Kratos\source.

## Lokale Vorschau mit synthetischen Daten

    npm install --global pnpm@10
    pnpm install --frozen-lockfile
    pnpm run lint
    pnpm exec tsc --noEmit
    pnpm run dev

Die Vorschau bindet standardmäßig an 127.0.0.1:5173. Für synthetische lokale Anmeldung öffne http://127.0.0.1:5173/signin-with-chatgpt?return_to=/. Lokale Wrangler-Daten bleiben im ignorierten .wrangler/-Ordner. Es werden keine produktiven CRM-Daten kopiert.

## Serverstatus: noch nicht produktionsbereit

Dieses Projekt ist aktuell die gehostete Sites-Webanwendung mit Cloudflare D1. Die lokale Wrangler-Vorschau ist kein Windows-Dienst und nicht für echte Kundendaten oder externen Zugriff vorgesehen. Der bestehende D1-Adapter funktioniert nicht als eigenständiger Mini-PC-Dienst.

Vor produktivem Betrieb müssen SQLite-Anbindung, geschützte OAuth-Anmeldung, Microsoft-Graph-Token-Erneuerung, eingeschränktes Dienstkonto, automatischer Start, Protokollrotation, verschlüsselte Backups und eine geprüfte Wiederherstellung implementiert werden. Danach zuerst mit synthetischen Daten testen. Keine Routerfreigabe für Datenbank, SMB oder Verwaltungszugang. OneDrive-Originale und Produktion bleiben bis zu einem separaten Migrationsplan unverändert.

Die Repository-ZIP enthält Quellcode und Dokumentation, aber keinen fertigen Server-Installer.
