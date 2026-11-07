# KRATOS Mini-PC: Dauerbetrieb und sicherer Fernzugriff

Stand: 7. November 2026

## Ziel

Diesen Auftrag auf dem KRATOS Mini-PC schrittweise ausführen, damit der Rechner im Netzbetrieb wach bleibt, der aktuelle Softwarestand sicher geprüft wird und ein belastbarer Weg für Fernwartung und spätere ChatGPT-Werkzeuge entsteht.

**Der Auftrag startet mit Bestandsaufnahme und sicheren lokalen Einstellungen.** Er darf keine Kundendaten migrieren, keine Produktionsdatenbank starten, keine pauschalen Rechte vergeben und keinen Dienst ins öffentliche Internet stellen.

## Vor dem Start: Was gemeinsam ist und was nicht

- ChatGPT-Gesprächsverlauf wird zwischen Geräten synchronisiert, wenn dieselbe Person im selben ChatGPT-Konto angemeldet ist. Auf dem PC denselben Chat öffnen.
- Ein separater GPT-/Codex-Lauf auf dem Mini-PC übernimmt diesen Chat nicht automatisch. Eine Anmeldung mit demselben Konto verbindet einen lokalen Prozess nicht mit diesem Gespräch.
- ChatGPT-Projekte bündeln Chats, Dateien und Anweisungen und können auf mehreren Geräten weiterverwendet werden. Ein Projekt ist aber kein lokaler Windows-Ordner. Chats, die mit einem Custom GPT erstellt wurden, lassen sich laut OpenAI derzeit nicht in ein Projekt verschieben.
- Für gemeinsame Arbeitsgrundlagen müssen die jeweiligen Arbeitsplätze dieselbe Quelle lesen: dieses GitHub-Repository für Code und technische Anweisungen; SharePoint/OneDrive für vertrauliche Geschäftsdokumente und Kundendaten. Jede GPT-Instanz benötigt trotzdem den passenden, ausdrücklich eingerichteten Zugriff.
- Das Repository FAM12345654/kratos-crm-minipc ist öffentlich. Keine Kundendaten, Datenbanken, Zugangsdaten, Tokens, persönlichen Schlüssel oder internen Exporte hier ablegen.

## Bestätigter Ausgangsstand

Die aktuelle Repository-Anleitung beschreibt ein Preflight-Paket. Es lädt Quellcode mit SHA-256-Prüfung, installiert Voraussetzungen und prüft eine synthetische Probe. Es konfiguriert **keinen** Windows-Dienst, keine Energieeinstellungen, keine produktive Datenbank, keine OAuth-Anmeldung, keine Firewall und keinen Fernzugriff.

Die vorhandene API ist nur an 127.0.0.1 gebunden und read-only. Laut vorhandener Doku fehlen eine geprüfte operative SQLite-Datenbank und ein OAuth-Profil. Daher vorerst keine echten Kundendaten an die API anschließen.

## Auftrag für den lokalen Codex/GPT

Arbeite im bestehenden Repository und auf dem echten Mini-PC. Lies zuerst README.md, docs/mini-pc-server-setup.md und dieses Dokument vollständig. Prüfe, ob eine lokale AGENTS.md, CODEX.md oder SECURITY.md zusätzliche Regeln enthält.

### Phase 1 — Bestandsaufnahme ohne Änderungen

1. Erfasse Windows-Edition, Version, Build, Gerätemodell, aktuellen Benutzer, Netzwerkverbindung und freien Speicherplatz.
2. Erfasse die aktuelle Energie-Richtlinie mit powercfg /getactivescheme und powercfg /query.
3. Erfasse nur Namen und Status vorhandener Kratos-Dienste und Prozesse sowie den Status von C:\Kratos. Keine Dateien daraus kopieren oder veröffentlichen.
4. Prüfe Git-Branch und Arbeitsbaum. Bewahre bestehende Dateien und alle lokalen Änderungen.
5. Prüfe, ob die laufende Installation zum veröffentlichten Quellpaket passt. Nutze nur synthetische Daten und vorhandene dokumentierte Tests.
6. Berichte die Ergebnisse und halte an, wenn ein anderer produktiver Dienst, eine Datenbank oder ein unbekannter OAuth-Schlüssel betroffen wäre.

### Phase 2 — Dauerbetrieb im Netzbetrieb

Wenn der Mini-PC am Netzteil hängt, darf der Codex/GPT die Windows-Zeitlimits für Standby und Ruhezustand auf Netzbetrieb auf „Nie“ setzen:

~~~powershell
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0
powercfg /query
~~~

Prüfe in der Ausgabe, dass die AC-Werte tatsächlich 0/„Nie“ sind. Falls Richtlinien, Modern Standby oder Geräteverwaltung die Einstellung überschreiben, nichts erzwingen: dokumentiere die konkrete Sperre und halte an.

Bildschirmabschaltung, Bildschirmsperre, Passwortschutz, Microsoft Defender, Firewall und Windows-Updates bleiben aktiv. Updates nicht deaktivieren. Batterie-Einstellungen unverändert lassen.

BIOS-/UEFI-Einstellung „Restore AC Power Loss“/„Power On after AC loss“ nur ändern, wenn Gerätemodell und die genaue Einstellung eindeutig identifiziert sind. Vorher den alten Wert dokumentieren; bei unklarem Menü nicht ändern. Diese Option betrifft nur Neustart nach einem Stromausfall, nicht normales Windows-Energiesparen.

### Phase 3 — Fernwartung für Phips

Ziel ist ein privater, authentifizierter Zugriff nur für ausdrücklich freigegebene Geräte und Benutzer.

1. Prüfe Windows-Edition. Windows Home kann keinen Microsoft-Remote-Desktop-Host bereitstellen; auf Home keine RDP-Umgehung installieren.
2. Bevorzuge ein privates VPN/Overlay-Netz wie Tailscale oder WireGuard. Kein RDP-, SSH- oder App-Port im Router ins öffentliche Internet weiterleiten.
3. Installiere oder aktiviere keine Fernwartungssoftware, die nicht zuvor anhand offizieller Quelle und Herausgeber geprüft wurde.
4. Für Tailscale/WireGuard muss Phips die Anmeldung bzw. Gerätefreigabe lokal selbst abschließen. Aktiviere MFA, sofern angeboten. Keine Zugangsdaten oder Geräte-Auth-Keys in diesem öffentlichen Repository speichern.
5. Falls Windows RDP verwendet wird: nur innerhalb des privaten Netzes, Network Level Authentication aktiv, starke Anmeldung, benannte berechtigte Konten. Fernzugriff nur für explizit autorisierte Benutzer.
6. Kein allgemeines Administratorrecht für alle GPTs oder Tools. Installationsschritte nur mit erforderlicher, zeitlich begrenzter Erhöhung; für dauerhafte Dienste ein dediziertes Konto mit minimalen Ordner- und Dienstrechten.
7. Nach dem Einrichten von einem zweiten berechtigten Gerät über das private Netz testen. Danach Negativtest mit nicht berechtigtem Konto und prüfen, dass der Dienst nicht öffentlich erreichbar ist.

**Wichtig:** Ein privates VPN ermöglicht Phips den Gerätezugriff. Es verbindet einen lokalen GPT nicht automatisch mit ChatGPT auf dem Handy.

### Phase 4 — Weg für ChatGPT-Zugriff bestimmen

Ein GPT auf einem anderen Gerät benötigt einen eigenen, unterstützten Integrationsweg. Der gleiche ChatGPT-Login reicht dafür nicht.

1. Dokumentiere die aktuelle Kratos-API, ihre Bind-Adresse, Authentifizierung und erlaubten Aktionen.
2. Behalte die API auf 127.0.0.1, bis eine sichere Integration mit HTTPS, Anmeldung, rollenbasierten Berechtigungen und Audit-Protokollierung vollständig geprüft ist.
3. ChatGPT darf zunächst nur eng begrenzte read-only CRM-Funktionen erhalten. Kein beliebiger Shell-Befehl, kein freier Dateisystemzugriff, kein Kunden-Upload und keine Schreib-/Löschfunktion.
4. Direkter Cloud-Zugriff auf einen Mini-PC erfordert eine dafür geeignete, authentifizierte HTTPS-Integration. Tailscale oder ein GitHub-Connector allein stellt diese Verbindung nicht her.
5. Vor externer Erreichbarkeit: Threat Model, Authentifizierungs- und Berechtigungstests, Rate Limits, Protokollierung ohne Geheimnisse, Backup/Wiederherstellung und dokumentierter Rollback.
6. Ohne nachweisbare Erfüllung dieser Punkte nicht ins Internet exponieren. Erstelle dann einen kurzen Architekturvorschlag mit konkreten Blockern und den minimalen zusätzlichen Freigaben.

### Phase 5 — Windows-Dienst und Datenbank

1. Prüfe zuerst, ob das Quellpaket überhaupt einen stabilen Produktivstart, produktive Schema-/Migrationsbefehle und einen dokumentierten Stop-/Rollback-Pfad enthält.
2. Vor einem Dienst: nur synthetische lokale Probe, definierter Dienstbenutzer, automatischer Start, begrenzte Berechtigungen, Wiederherstellung nach Prozessfehler und aussagekräftige, datensparsame Logs.
3. Produktive Datenbank erstellen/migrieren, OAuth/Microsoft-Anmeldung aktivieren, Kundenordner synchronisieren oder echte Kundendaten verwenden: **hier anhalten**. Das sind eigene Freigabepunkte und benötigen vorher ein geprüftes Backup, Schema-/Migrationsplan, Restore-Test, Berechtigungskonzept und ausdrückliche Freigabe von Phips.
4. Keine echten Kundenakten in Logs, Tests, GitHub oder synthetische Rehearsal-Daten übernehmen.

## Harte Stopps

Sofort anhalten und Befund melden, wenn:

- Datenbank, vorhandener Kratos-Dienst oder OAuth-Profil nicht eindeutig identifiziert ist;
- lokale Änderungen überschrieben oder gelöscht werden müssten;
- eine öffentliche Router-/Firewall-Freigabe, ein unbekanntes Administratorkonto oder ein unklarer Anbieter erforderlich wäre;
- echter Kundenbestand, Dokumente, Vollmachten oder Verträge betroffen sind;
- eine Authentifizierung, Backup-Wiederherstellung, Abnahme oder sichere Rücknahme fehlt;
- der Rechner Windows Home ausführt, aber RDP als Host vorgesehen ist.

## Abnahmekriterien

- [ ] Standby- und Ruhezustands-Timeout im Netzbetrieb sind auf „Nie“ gesetzt und mit powercfg /query verifiziert.
- [ ] Bildschirm-Sperre, Defender, Firewall und Updates sind aktiv.
- [ ] Keine Datei aus einem bestehenden Kratos-Ordner wurde gelöscht oder überschrieben.
- [ ] Aktueller Dienst-/API-Status und Bind-Adresse sind dokumentiert; keine API wurde öffentlich exponiert.
- [ ] Fernzugriff ist nur über ein privates, authentifiziertes Netz und nur für freigegebene Konten eingerichtet oder der konkrete Blocker ist festgehalten.
- [ ] Keine Geheimnisse oder Kundendaten wurden in GitHub, Logs oder Tests geschrieben.
- [ ] Synthetische Probe, autorisierter Fernzugriff und negativer Zugriffstest wurden tatsächlich ausgeführt; keine ungeprüften Erfolge behaupten.
- [ ] Offene Architektur- und Freigabepunkte sind mit konkretem nächsten Schritt dokumentiert.

## Bericht am Ende

Liefere eine knappe deutsche Zusammenfassung mit: geänderten Einstellungen, exakten Prüfergebnissen, neu eingerichteten Diensten/Programmen, getesteten Zugriffswegen, nicht durchführbaren Schritten und benötigten Freigaben. Keine Zugangsdaten ausgeben. Nichts committen oder pushen, außer Phips fordert das ausdrücklich.

## Quellen zur Recherche

- OpenAI, ChatGPT iOS/Android FAQ — Chatverlauf synchronisiert sich über Geräte mit demselben Konto: https://help.openai.com/en/articles/8142208-chatgpt-ios-and-android-app-faq
- OpenAI, Projects — Chats, Dateien und Anweisungen innerhalb eines Projekts; Projektarbeit auf mehreren Geräten: https://help.openai.com/en/articles/10169521-projects-in-chatgpt
- OpenAI, GPTs FAQ — Custom GPTs verwenden keine gespeicherten Erinnerungen, Custom Instructions oder vorherigen Gespräche; jede Unterhaltung beginnt neu: https://help.openai.com/en/articles/8554407-gpts-faq
- Microsoft Learn, Powercfg command-line options — Energiezeitlimits für AC-Netzbetrieb: https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options
- Microsoft Learn, RDP von außerhalb sicher erreichen — VPN statt PC direkt öffentlich erreichbar zu machen: https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/remotepc/remote-desktop-allow-outside-access
- Tailscale, Windows Remote Desktop — privater RDP-Zugriff über ein Tailnet ohne manuelle Portfreigabe: https://tailscale.com/docs/solutions/access-remote-desktops-using-windows-rdp
