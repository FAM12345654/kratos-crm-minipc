# Kratos auf dem Windows-Mini-PC

Stand: 6. November 2026

## Was dieses Repository bereitstellt

Das GitHub-Repository ist öffentlich und enthält diese Anleitung sowie ein ZIP mit dem vollständigen aktuellen Quellcode. Keine echten Kundendaten, Zugangsdaten oder privaten Schlüssel hier hochladen.

Der Quellcode ist die veröffentlichte Sites-Webanwendung mit Cloudflare D1. Es gibt noch keinen fertigen Windows-CRM-Server-Installer. Die lokale Vorschau ist nur für synthetische Daten und nicht für Dauerbetrieb oder externen Zugriff gedacht.

## Offizielle Downloads

- [Node.js LTS für Windows](https://nodejs.org/en/download) — Node >=22.13.0; passenden x64- oder ARM64-Installer auswählen.
- [Git for Windows](https://git-scm.com/install/windows) — offiziellen Installer für die Gerätearchitektur wählen.
- [GitHub CLI](https://cli.github.com/) — optional.

Installer direkt vom Anbieter laden. Installer nicht ins Repository einchecken.

## Repository und Quellcode holen

Das Repository enthält Dokumentation und das Quellcode-ZIP. Klone es in einen eigenen Ordner und entpacke das ZIP daneben:

    git clone https://github.com/FAM12345654/kratos-crm-minipc.git C:\Kratos\github
    Expand-Archive C:\Kratos\github\kratos-crm-minipc-source.zip -DestinationPath C:\Kratos\source
    Set-Location C:\Kratos\source

Auf dem Mini-PC sind Git 2.56.0, Node 24.22.1 und pnpm 11.25.0 vorhanden. Auf einem anderen Windows-Gerät Node.js und Git aus den offiziellen Links installieren. Falls pnpm dort fehlt und npm verfügbar ist: npm install --global pnpm@11.

## Lokale Vorschau mit synthetischen Daten

    pnpm install --frozen-lockfile --store-dir C:\Kratos\pnpm-store
    pnpm run build
    $migrations = Get-ChildItem drizzle\*.sql | Sort-Object Name
    foreach ($migration in $migrations) {
      pnpm exec wrangler d1 execute DB --local --config dist\server\wrangler.json --persist-to .wrangler/state --file $migration.FullName
    }
    pnpm run dev -- --port 5174 --host 127.0.0.1

Die Migrationen werden mit --local in die lokale Wrangler-Datenbank im ignorierten .wrangler-Ordner geschrieben. Sie erstellen nur das Schema und laden keine Kundendaten. Die Vorschau bindet an 127.0.0.1:5174. Für synthetische lokale Anmeldung öffne http://127.0.0.1:5174/signin-with-chatgpt?return_to=/.

pnpm run start ist ebenfalls nur eine lokale Wrangler-Vorschau und richtet keinen Windows-Dienst ein.

## Was vor einem echten Serverbetrieb noch fehlt

1. D1 durch einen geprüften SQLite-Adapter ersetzen und SQL, Transaktionen sowie Nebenläufigkeit testen.
2. Geschützte OAuth-Anmeldung für ChatGPT/Claude und serverseitige Rechteprüfung umsetzen. Der lokale Mock-Login ist dafür ungeeignet.
3. Microsoft-Graph-Token-Erneuerung und geschützten Token-Speicher einrichten.
4. Eingeschränktes Dienstkonto, automatischen Start, Protokollrotation sowie verschlüsselte Backups und Wiederherstellungsprobe einrichten.
5. Einen geprüften HTTPS-Zugangsweg planen. Keine Routerfreigabe für Datenbank, SMB oder Verwaltungszugang.
6. Erst synthetische Daten verwenden; eine echte Migration braucht einen separaten Sicherungs-, Prüf- und Rückfallplan.

OneDrive-Originale und die aktuelle Produktion bleiben bis zu einem separaten Migrationsplan unverändert.
