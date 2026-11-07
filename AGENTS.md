# Arbeitsregeln für KRATOS

- Vor jeder Änderung die vorhandene Quell-ZIP, README, Architektur und relevanten Module prüfen.
- Die Quell-ZIP bleibt die einzige eingecheckte Kopie des Programmcodes. Keine entpackte Zweitkopie oder parallele Ersatzimplementierung hinzufügen.
- Bestehende Services, Datenmodelle, Autorisierung, Fehlerbehandlung und Abhängigkeiten wiederverwenden. Neue Abstraktionen nur einführen, wenn sie echte Wiederholung oder Komplexität reduzieren.
- Änderungen klein und auf den konkreten Zweck begrenzen. Keine großflächigen Formatierungen, Umbenennungen, generierten Kopien oder rein kosmetischen Zeilenkürzungen.
- Code lesbar lassen: nicht minifizieren. Gleiche Sicherheitsprüfungen nicht zusammenlegen, wenn dadurch ihre unterschiedlichen Grenzen unklar werden.
- Keine neue Abhängigkeit für kleine Hilfsfunktionen. Vorhandene Bibliotheken und Muster bevorzugen.
- Bei Änderungen am Quellpaket dessen Build-/Preflight-Prüfsumme aktualisieren. Keine Geheimnisse, Kundendaten, echten Datenbanken oder Produktions-Exporte in dieses öffentliche Repository legen.
- Im Arbeitsbericht angeben, welche Dateien geändert wurden und welche Prüfungen tatsächlich gelaufen sind. Nicht ausgeführte Prüfungen klar benennen.
