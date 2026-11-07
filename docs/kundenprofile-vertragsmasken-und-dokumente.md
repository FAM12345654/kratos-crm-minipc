# KRATOS-Auftrag: Kundenprofile, Vertragsmasken und Dokumente

Stand: 7. November 2026

## Auftrag

Erweitere das bestehende KRATOS-Interface um eine durchsuchbare Kundenliste, ein eigenes Profil pro Kunde, aufklappbare Karten pro Vertrag und spartenspezifische Detailmasken. Lade Dokumente einmal in KRATOS und lege dieselbe Datei zusätzlich in der privaten SharePoint-/OneDrive-Ablage ab. Erfasse erkannte Vertrags- und Fahrzeugdaten strukturiert im CRM, damit sie später für Auskünfte, Berechnungen und Vertragsprüfungen wiederverwendet werden können, ohne das Bild erneut auszulesen.

Arbeite auf dem vorhandenen echten Quellstand. Das Repository enthält laut README derzeit veröffentlichte ZIP-Quellpakete statt eines direkt bearbeitbaren Source-Tree. Vor einer Codeänderung zuerst Quellpaket und Architektur lokal prüfen und bestehende Datenbanken, Funktionen oder Schnittstellen nicht ersetzen.

## Begriffe und Datenablage

Diese drei Speicherorte haben getrennte Aufgaben:

1. **Öffentliches GitHub-Repo:** nur Programmcode, technische Anleitungen und synthetische Tests. Keine Kundendokumente, persönlichen Daten, Verträge, Tokens oder Datenbankkopien.
2. **Privates SharePoint/OneDrive:** zweite Ablagekopie und bestehende geschäftliche Dokumentenablage.
3. **KRATOS-Dokumentenspeicher:** CRM-Kopie, damit das Dokument direkt beim Kunden und beim Vertrag geöffnet werden kann.

Jedes hochgeladene Vertragsdokument soll nach erfolgreichem Import in beiden privaten Ablagen vorhanden sein. Es ist nicht ausreichend, nur einen OneDrive-Link im CRM zu speichern. Die CRM-Kopie und die OneDrive-Kopie müssen dieselbe Originaldatei enthalten; Prüfsumme, Dateigröße und Synchronisationsstatus dienen zum Abgleich. Der sichtbare Status lautet beispielsweise „beide Kopien geprüft“, „OneDrive-Sync ausständig“ oder „Fehler – erneuter Versuch erforderlich“. Eine nur teilweise gesicherte Datei darf nicht als vollständig abgelegt erscheinen.

Verhindere Sync-Schleifen und Mehrfachimporte mit einer stabilen Dokument-ID und Prüfsumme. Wiederholtes Hochladen derselben Datei soll idempotent sein. Bei Bearbeitung eine neue Version anlegen und die Beziehung zur Vorgängerversion behalten; keine Kopie stillschweigend überschreiben. Löschen aus einer der beiden Ablagen darf nicht automatisch die andere Kopie löschen. Ein Löschvorgang braucht eine ausdrückliche Nutzeraktion und einen nachvollziehbaren Status.

## Vergleich mit anderen CRM-Oberflächen

Dieser Abschnitt fasst öffentlich dokumentierte Bedienmuster zusammen. Er übernimmt keine Produktgestaltung eins zu eins; die Empfehlungen für KRATOS sind eine Ableitung aus den Mustern und den Anforderungen von Familienhelden.

| CRM | Öffentlich dokumentiertes Muster | Was KRATOS übernehmen kann |
|---|---|---|
| **HubSpot** | Datensatzseite mit linker Leiste, mittlerem Arbeitsbereich und rechter Leiste für verknüpfte Datensätze/Anhänge. Informationen liegen in eigenen Karten und Tabs. | Stammdaten, Aktivitäten, Verträge und Dokumente klar nach Zweck trennen; verknüpfte Verträge erreichbar halten. |
| **Attio** | Datensatz-Vorschau öffnet neben Tabellen- oder Kanbanliste, hält den ausgewählten Eintrag markiert und lässt die Vorschau in der Breite verändern. Eine eigene vollständige Profilseite bleibt zusätzlich verfügbar. | Kundenliste sichtbar lassen, den gewählten Kunden daneben öffnen und zur Vollansicht erweitern; Spaltenbreiten anpassbar machen. |
| **Pipedrive** | Detailseiten haben getrennte Bereiche für Zusammenfassung, Felder und verknüpfte Datensätze. Seitenbereiche können ein-/ausgeblendet, sortiert und eingeklappt werden; leere Felder lassen sich ausblenden. | Vertragssparten als klar getrennte, aufklappbare Bereiche darstellen und die Ansicht bei Bedarf auf wichtige bzw. ausgefüllte Felder reduzieren. |
| **Salesforce** | Datensatzseiten stellen Kerndaten im Kopfbereich bereit und gruppieren Details, Aktivitäten und verknüpfte Listen in Tabs/Abschnitten. | Nur die wichtigsten Kunden- und Vertragsaktionen sofort zeigen; selten genutzte Verwaltungsdetails nicht in den Vordergrund stellen. |

### Abgeleitete Gestaltungsregeln für KRATOS

- Die Kundenliste mit Suche bleibt als dauerhafte Navigation erhalten. Namen und Auswahl bleiben auch bei geöffnetem Profil lesbar.
- Eine Kundenauswahl öffnet das Profil neben der Liste. Eine Vertragsauswahl ergänzt einen dritten, breiteren Arbeitsbereich, ohne die vorherigen Ebenen zu schließen.
- Das Zielverhältnis orientiert sich grob an „Liste : Kundenprofil : Vertragsdetails = 1 : 1 : 2“, wird aber nicht auf feste Prozentwerte gezwungen. Die Breite passt sich dem Fenster an und darf auf Desktop sinnvoll verstellbar sein.
- Die Vertragsdetails bekommen den größten nutzbaren Bereich. Kundenname, aktive Sparte und zurückführende Navigation bleiben sichtbar.
- Bei begrenzter Fensterbreite auf eine Ebene nach der anderen wechseln, mit klarer Zurück-Navigation. Keine unlesbar schmalen Drei-Spaltenansicht erzwingen.
- Import und OneDrive-Verwaltung bleiben Nebenaktionen; sie verdrängen weder Kundensuche noch Kundenliste aus der Startansicht.
- Leere oder seltene Felder bei Bedarf ausblendbar machen. Feldnamen, manuelles Ergänzen, Bearbeiten und Spartennotizen bleiben leicht erreichbar.

**Quellen:** HubSpot — https://knowledge.hubspot.com/records/work-with-records ; Attio — https://attio.com/help/reference/managing-your-data/records/create-and-view-records ; Pipedrive — https://support.pipedrive.com/en/article/detail-view-sidebar ; Salesforce — https://help.salesforce.com/s/articleView?id=sf.accessibility_screen_reader.htm&language=en_US&type=5

## Nutzerablauf und Oberfläche

### Kundenliste

**Befund zur bestehenden Ansicht (veröffentlichte Version 25):** Die aktuelle Oberfläche ist sauber und gut lesbar. Im ersten Bildschirm dominieren jedoch manuelle Anlage, Kundenimport und OneDrive-Linkpflege; die Kundensuche beginnt erst weiter unten. Für die neue Oberfläche muss die Kundenliste mit Suche der primäre Startpunkt sein. Import- und Ordnerpflege gehören in einen eingeklappten Verwaltungsbereich oder eine separate Admin-Aktion und dürfen die tägliche Kundenarbeit nicht nach unten verdrängen.

- Zeige die bestehende Kundenübersicht mit Suche und sinnvollen Filtern.
- Die Zeile bzw. Karte zeigt die vorhandenen Kerndaten und einen kompakten Überblick über aktive Vertragssparten.
- Auswahl eines Eintrags öffnet ein eigenes Kundenprofil; die Profilansicht bleibt eindeutig diesem Kunden zugeordnet.
- Unterstütze mehrere Verträge und mehrere Dokumente pro Kunde.
- Bestehende Kundenliste, IDs, Ordnerlinks und Funktionen erhalten.

### Kundenprofil

Gliedere die Ansicht klar in Kundendaten, Verträge, Dokumente und offene Vorgänge. Zeige Verträge als Karten mit Sparte, Versicherer, Vertragsnummer, Status, Beginn/Ende und passenden Dokumenten.

Jede Vertragskarte lässt sich aufklappen. Der aufgeklappte Bereich zeigt ausschließlich die Felder der jeweiligen Sparte. Werte müssen direkt kopiert werden können. „Bearbeiten“ oder „Vertrag hinzufügen“ öffnet die passende Spartemaske; Speichern und Abbrechen sind klar getrennt.

### Schrittweise geteilte Ansicht auf dem Desktop

Die Navigation soll sich in mehrere dauerhaft sichtbare Bereiche öffnen, statt Inhalte in einem losgelösten Dialog zu verstecken:

1. **Start:** Kundenliste als Hauptansicht.
2. **Kunde ausgewählt:** Kundenliste schiebt sich nach links in eine schmale, etwa ein Achtel der verfügbaren Breite belegende Leiste. Namen bleiben lesbar und der aktive Kunde ist markiert. Daneben erscheint das vollständige Kundenprofil.
3. **Vertrag ausgewählt:** Die Ansicht teilt sich in drei gleichzeitig sichtbare Spalten: ungefähr ein Viertel für die scrollbare Kundenleiste, ein Viertel für das geöffnete Kundenprofil und die Hälfte für den ausgewählten Vertrag samt Spartendaten und Dokument.
4. Bereits geöffnete Ebenen bleiben links sichtbar und verschieben sich beim Öffnen der nächsten Ebene. Auswahl, Scrollposition und Formularentwürfe bleiben bei der Navigation erhalten. Zurück-Navigation führt jeweils eine Ebene zurück.
5. Die Prozentwerte sind Zielverhältnisse, keine festen Pixelwerte. Spalten müssen frei von Überlagerungen bleiben. Kundennamen und wichtige Felder dürfen nicht abgeschnitten werden; bei schmalen Fenstern soll die Oberfläche auf eine gut bedienbare Einzelfenster-Navigation wechseln.

### Spartenspezifische Masken

Lege getrennte, erweiterbare Feldschemata an. Die folgenden Felder sind ein fachlicher Mindestumfang; beim Implementieren sind vorhandene Datenmodelle und Versicherungsprodukte zu prüfen. Felder, die bei konkreten Produkten nicht anwendbar sind, nicht erzwingen.

- **Kfz:** Kennzeichen, Fahrgestellnummer/VIN, Marke, Modell/Typ/Variante, Erstzulassung, Zulassungsdatum, Fahrzeugklasse, Hubraum, Leistung, Antrieb/Kraftstoff, Sitzplätze, Eigengewicht, zulässige Gesamtmasse, technisch zulässige Gesamtmasse, Verwendungszweck, Kilometerstand und Bonus-Malus-Stufe.
- **Haushalt:** versicherter Standort, Wohnfläche, Baujahr, Bauart, Nutzung, Versicherungssumme, Selbstbehalt, versicherte Zusatzbausteine und relevante Risikomerkmale.
- **Rechtsschutz:** versicherte Personen, versicherte Bereiche/Bausteine, Deckungssumme, Selbstbehalt, Wartezeiten und räumlicher Geltungsbereich.
- **Unfall:** versicherte Personen, Invaliditäts- und Todesfallsumme, Progression, Taggeld, Spitalgeld und vereinbarte Zusatzleistungen.
- **Krankenversicherung:** versicherte Personen, Tarif, Leistungsbereiche, Selbstbehalt, Beginn und Versicherer. Gesundheitsangaben nur speichern, wenn sie für die Vertragsbetreuung erforderlich und dafür ausdrücklich vorgesehen sind; Zugriffe eng begrenzen.
- **Spar-/Vorsorgeplan:** Produktart, Beginn, Beitrag, Zahlungsrhythmus, Laufzeit, Veranlagung/Fonds, vereinbarte Garantien und relevante Leistungsdaten.
- **Weitere Sparten:** Lebensversicherung, Haftpflicht, Reise, Gewerbe und weitere Produktarten müssen als zusätzliche Spartemasken ergänzt werden können. Für unbekannte Fälle kann es ein erweiterbares Schema geben, aber keine bloße Freitextmaske anstelle einer passenden Sparte.

Vertragsstatus und Vertragsdaten getrennt führen. Ein Vertrag darf nicht allein durch Upload oder OCR auf „aktiv“ wechseln.

## Zulassungsschein und OCR

1. Nutzer fotografiert oder lädt den Zulassungsschein hoch.
2. Das Dokument wird als Original in beiden Ablagen gespeichert; der Nutzer sieht den Status beider Kopien.
3. OCR extrahiert bekannte Felder zunächst in einen **Entwurf**. Zeige pro Feld den erkannten Wert, Quelle und Erkennungsqualität. Unsichere, fehlende oder widersprüchliche Werte sichtbar markieren.
4. Vor dem Speichern prüft und bestätigt der Nutzer die Erkennung. OCR ist allein keine verifizierte Angabe.
5. Nach Bestätigung werden die Werte als strukturierter Fahrzeugdatensatz im CRM gespeichert und mit dem Kunden sowie dem zugehörigen Kfz-Vertrag verknüpft. Bestehende bestätigte Werte nie still überschreiben; Abweichungen als Konflikt anzeigen.
6. Der Assistent soll bei späteren Berechnungen oder Vertragschecks zuerst die bestätigten CRM-Felder verwenden. Das Original bleibt für Nachweis, erneute Prüfung oder fehlende Felder verfügbar. Dadurch soll unnötiges wiederholtes Bildauslesen reduziert werden; eine bestimmte Tokenersparnis wird nicht garantiert.

Speichere je strukturiertem Feld, soweit die bestehende Architektur es unterstützt: Herkunft (manuell/OCR/Dokument), Dokument-ID und Seite, Bestätigungsstatus, Erstellungs- und Änderungszeitpunkt. Protokolle dürfen keine kompletten Dokumentinhalte, Tokens oder unnötigen personenbezogenen Werte enthalten.

## Datenmodell und technische Anforderungen

- Prüfe zuerst vorhandene Kunden-, Dokumenten-, Vertrags- und Fahrzeugmodelle, API-Routen, Cloud-Datenbank und Berechtigungen.
- Ergänze ein Vertragsmodell, das mehrere Sparten und mehrere Verträge je Kunde unterstützt, sowie typisierte spartenspezifische Details.
- Verknüpfe Dokumente stabil mit Kunde, Vertrag und optional Fahrzeug. Speichere Prüfsumme, Speicherorte, Version, Sync-Status und Fehlerstatus.
- Implementiere das Speichern in CRM und OneDrive als fehlertoleranten Ablauf mit Wiederholungsversuchen. Bei Ausfall einer Ablage dürfen vorhandene Dateien nicht verloren gehen; Status und Wiederaufnahme müssen funktionieren.
- Migrationen müssen rückwärts nachvollziehbar sein. Bestehende Felder, Kundendatensätze und Ordnerlinks bleiben erhalten.
- Das Interface muss auf Desktop und Mobilgerät bedienbar sein.
- OCR-Anbieter und Datenfluss zuerst prüfen. Keine echten Dokumente an ungeprüfte externe OCR-Dienste senden.
- Die Integration darf nur den benötigten Zugriff auf CRM- und OneDrive-Ordner erhalten. Rollen, Zugriffsschutz und Auditierung für sensible Vertragsdaten prüfen.

## Zusammenarbeit und Umfang

Lass parallel prüfen:
- **Bestandsaufnahme:** Architektur, Modelle, API und Dateispeicher read-only dokumentieren.
- **Implementierung:** UI und Vertrags-/Dokumentenmodell in getrennten Modulen umsetzen.
- **Validierung/Sicherheit:** unabhängig Migration, Doppelablage, Rechte und Fehlerfälle prüfen.
- Hauptagent integriert und verantwortet die Endabnahme. Agenten bearbeiten nicht gleichzeitig dieselben Dateien.

## Sicherheitsvertrag

Erlaubt: Code- und Schemaänderungen mit synthetischen Daten, lokale Tests und eine sichere Demo.

Nicht erlaubt: echte Kundendokumente in GitHub/Tests/Logs, produktive Migration ohne Backup und Restore-Test, OCR-Übertragung an nicht geprüfte Anbieter, freie Shell-/Dateisystemrechte oder automatische Vertragsaktivierung. Produktive Datenmigration und externe Freigaben erst nach bestätigtem technischem Plan und separater ausdrücklicher Freigabe.

## Validierung und Abnahmekriterien

- [ ] Kundenliste findet und öffnet den richtigen Kunden.
- [ ] Kundenprofil kann mehrere Verträge, Fahrzeuge und Dokumente anzeigen.
- [ ] Jede Sparte zeigt die passenden Felder; Kfz-, Haushalt-, Rechtsschutz-, Unfall-, Kranken- und Vorsorgemasken sind getrennt.
- [ ] Vertragskarten klappen auf, Dokumente lassen sich im CRM öffnen und Feldwerte kopieren.
- [ ] Ein Dokument-Upload erzeugt eine CRM-Kopie und eine OneDrive-Kopie; beide werden über Prüfsumme abgeglichen.
- [ ] Ausfall einer Ablage zeigt „unvollständig“ samt erneutem Versuch; erneutes Senden erzeugt keine Dubletten.
- [ ] OCR liefert einen Entwurf mit Feldherkunft/Qualität; unsichere, fehlende und widersprüchliche Werte erfordern manuelle Bestätigung.
- [ ] Erneuter Upload überschreibt keine bestätigten Fahrzeugdaten und aktiviert keinen Vertrag.
- [ ] Tests decken unscharfes/gespiegeltes Bild, fehlende VIN, ähnliche VIN-Zeichen, abweichendes Kennzeichen, Mehrseiten-PDF, zwei Fahrzeuge und vorübergehenden OneDrive-Ausfall ab.
- [ ] Sensible Daten und echte Kundenbeispiele fehlen in Tests, Logs und GitHub.
- [ ] Bestehende Tests und Regressionen bleiben grün; tatsächlich ausgeführte Prüfungen werden mit Ergebnis protokolliert.

## Übergabebericht

Nenne geänderte Dateien, Schema-/Migrationsschritte, getestete Ablagepfade und OCR-Fälle. Erkläre verständlich, wie Mitarbeitende einen Kunden öffnen, Vertrag aufklappen, Dokument beidseitig ablegen und OCR-Daten bestätigen. Liste alle nicht umgesetzten Punkte und Risiken. Keine Behauptung über Datenverlustfreiheit oder Tokenersparnis ohne ausgeführte Tests.
