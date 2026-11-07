# ChatGPT-Anbindung: vorhandenen Gateway-Code weiterverwenden

Stand: 7. November 2026. Dieses Dokument enthält nur technische Abläufe und öffentliche Quellen. Keine Tunnel-IDs, Schlüssel, Kundendaten oder Datenbankdateien eintragen.

## Was im Quellpaket schon vorhanden ist

Die aktuelle Quell-ZIP enthält einen lokalen MCP-/HTTP-Gateway unter `/mcp`, die vorhandenen Kratos-Lese-Werkzeuge, eine OAuth-/JWT-Prüfung, ein optionales Microsoft-Entra-Profil und eine SQLite-Lese-API. Der lokale Server bindet ausschließlich an `127.0.0.1`; die Gateway-Werkzeuge sind auf Lesen beschränkt und prüfen Token, Scope und eine feste Benutzer-Allowlist.

Die bestehende Implementierung muss für den ersten Verbindungsversuch nicht neu geschrieben werden. Vorhanden sind sieben Gateway-Werkzeuge: Kundensuche, Kundendetails, Wiedervorlagen, Dokumentindex, Dokument-Suchplan und Metadaten für gespeicherte Dateien. Physische Dokumentinhalte werden nicht über diese MCP-Werkzeuge zurückgegeben.

## Verbindungsweg

Für einen privaten Mini-PC passt OpenAIs Secure MCP Tunnel: Der offizielle `tunnel-client` läuft im selben privaten Netz, erreicht den lokalen MCP-Endpunkt und baut eine ausgehende HTTPS-Verbindung zu OpenAI auf. Dafür ist kein öffentlicher Router-Port erforderlich. Der Tunnel transportiert Anfragen; er ersetzt weder Kratos-Authentifizierung noch Benutzerrechte.

ChatGPT und der OpenAI Platform-Tunnel sind getrennte Berechtigungsbereiche. Vor der Umsetzung im Konto prüfen, ob ChatGPT das Hinzufügen eines benutzerdefinierten MCP-Servers für den Nutzerplan und Workspace anbietet. Die aktuelle OpenAI-Hilfe nennt Business sowie Enterprise/Edu für benutzerdefinierte MCP-Verbindungen; Plus ist dort nicht aufgeführt. Ohne bestätigte Unterstützung keine öffentliche API oder Routerfreigabe als Ersatz einrichten. Benutzerdefinierte MCP-Verbindungen sind laut Hilfe außerdem nur im ChatGPT-Web verfügbar, nicht in der Android-/iOS-App. Daher zuerst im Webkonto prüfen, ob das gewünschte Konto tatsächlich die Funktion anbietet; keine mobile Verfügbarkeit einplanen, bevor OpenAI sie bestätigt.

Secure MCP Tunnel benötigt eine Tunnel-ID und einen Runtime-API-Schlüssel. Der Schlüssel für den dauerhaften Tunnelprozess ist vom Admin-Schlüssel für Tunnelverwaltung zu unterscheiden. Schlüssel ausschließlich lokal eingeben oder als Prozessumgebungsvariable bereitstellen; niemals im Repository, in Screenshots oder im Chat speichern.

## Offene Voraussetzungen

- ChatGPT-Plan/Workspace muss benutzerdefinierte MCP-Verbindungen erlauben; im Produktkonto prüfen.
- Eine vorhandene, passende lokale SQLite-Datenbank samt geprüftem Schema ist nötig. Das Quellpaket erstellt oder migriert sie nicht.
- Für echte Kontodaten braucht es eine konfigurierte OAuth-/Entra-Registrierung, die delegierte Tokens für die Kratos-API ausstellt. Die API prüft bereits Signatur, Issuer, Zielgruppe, Scope und ausdrücklich erlaubte Benutzer.
- Der externe Autorisierungsserver muss für den Anmeldevorgang erreichbar sein. Der Secure MCP Tunnel stellt nicht automatisch den OAuth-Autorisierungsserver bereit.
- Tunnel-ID und Runtime-Schlüssel müssen im OpenAI Platform-Konto angelegt beziehungsweise freigegeben werden.

## Ablauf, wenn Phips wieder am Mini-PC ist

1. **Nur lokale Bestandsaufnahme:** `Get-Kratos-MiniPcReadiness.ps1` meldet Windows-Version, Gerätemodell, freien C:-Speicher, Energieprofil, Schlafzeitlimits sowie passende Prozesse/Dienste und nur die Anzahl der Einträge in `C:\\Kratos`. Das Skript liest keine Dateiinhalte und ändert keine Einstellungen. Git-Branch und Arbeitsbaum danach separat prüfen; bestehende Dateien nicht überschreiben.
2. **Synthetische Vorbereitung:** vorhandenes Preflight-Skript ausführen und die synthetische Probe prüfen. Keine Produktionsdatenbank öffnen oder migrieren.
3. **Kontofähigkeit klären:** In ChatGPT prüfen, ob „Benutzerdefinierten MCP-Server hinzufügen“ im verwendeten Plan/Workspace verfügbar ist. In OpenAI Platform Tunnel-ID und Runtime-Schlüssel anlegen oder vorhandene Berechtigungen prüfen.
4. **Lokalen Gateway konfigurieren:** nur eine bestehende Datenbank verwenden; Authentifizierungsprofil, Ressource, Scope und erlaubte Benutzer-ID ausdrücklich festlegen. Keine echte Datenbank automatisch erzeugen oder migrieren.
5. **Tunnel-Client installieren:** aktuelle Version ausschließlich über OpenAI Platform oder das offizielle Repository beziehen. Mit `tunnel-client help quickstart` die aktuellen CLI-Optionen prüfen. MCP-Server auf `http://127.0.0.1:<Port>/mcp` zeigen lassen.
6. **Vor dem ChatGPT-Test:** lokalen MCP-Endpunkt und Tunnel-Client-Health/Readiness prüfen. Tunnel-Client muss für Tool-Erkennung und Aufrufe laufen.
7. **Synthetischer Ende-zu-Ende-Test:** ChatGPT-Werkzeugliste erkennen lassen und genau eine harmlose Suche gegen ausschließlich synthetische Daten ausführen. Erfolg erst melden, wenn die Antwort tatsächlich zurückkommt.
8. **Erst danach Dauerbetrieb planen:** Windows-Dienst/Autostart, Backup/Restore und Fernwartung getrennt abnehmen. Kein Dienst mit Adminrechten, keine öffentliche Portfreigabe und keine Schreib-/Upload-Werkzeuge aktivieren.

## Kompakte Wartungsregel

Die bestehende Quell-ZIP bleibt die einzige eingecheckte Codekopie. Neue Funktionen in vorhandenen Modulen ergänzen, nicht parallel neu aufbauen. Bei Codeänderungen nur die betroffenen Dateien im Paket anfassen und dessen Preflight-Prüfsumme mit aktualisieren. Die Regeln in `AGENTS.md` gelten für weitere Änderungen.

## Offizielle Quellen

- OpenAI Secure MCP Tunnel: https://developers.openai.com/api/docs/guides/secure-mcp-tunnels
- OpenAI-Hilfe zu benutzerdefinierten MCP-Servern und Planvoraussetzungen: https://help.openai.com/en/articles/12584461-connecting-custom-mcp-servers-in-chatgpt
- Offizieller Tunnel-Client und Onboarding: https://github.com/openai/tunnel-client/blob/master/docs/onboarding.md
