# Réseau Intime — Roadmap active

## Statut

**Catégorie : portail projet actif**

**Baseline stable : `5a6a832c148c68ee69d8991474ec778f33bc456d`**

**Tag de verrouillage : `runtime-s1-04-j04-playable`**

Cette roadmap résume la priorité courante. Elle ne remplace pas les sources canoniques.

---

# 1. État acquis

## Narration canonique

```text
North Star : validée
Personnages et voix : validés
Architecture Saison 1 : validée
Scripts J01–J21 : consolidés et signés
Contrats traces / promesses / connaissances : validés
Reachability : validée
Actes I–V : READY
Réécriture structurelle globale : non requise
```

## Production narrative

```text
NAR-PROD-02  Acte I   J01–J04   READY
NAR-PROD-03  Acte II  J05–J08   READY
NAR-PROD-04  Acte III J09–J12   READY
NAR-PROD-05  Acte IV  J13–J16   READY
NAR-PROD-06  Acte V   J17–J21   READY
```

## Runtime portrait Saison 1

```text
J01 : intégré et validé
J02 : intégré après J01 et validé
J03 : intégré après J02 et validé
J04 : intégré après J03 et validé
J05–J21 : non intégrés dans la chaîne active
```

L’Acte I J01–J04 est jouable.

La baseline comprend :

- `Season1RuntimeProvider` ;
- `Season1State` partagé ;
- providers bornés J01–J04 ;
- transcripts, fils et Galerie cumulatifs ;
- temps narratif monotone ;
- transitions unifiées ;
- snapshots et restauration ;
- livraison progressive ;
- notifications interactives neutres ;
- séparateurs par `source_day` ;
- `RuntimeUnread` ;
- vitesse limitée aux messages et au typing.

Contrat actif :

```text
docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

## UX/UI

```text
T-UI-01   Coque portrait             TERMINÉ
T-UI-02   Famille Messages           TERMINÉ
T-UI-03A  Gallery Core               TERMINÉ
T-UI-03B  ImageMessage               TERMINÉ
T-UI-03C  PhotoViewer                TERMINÉ
T-UI-03D  Gallery States             TERMINÉ
UI-MSG-04A à 04C                     INTÉGRÉS ET VALIDÉS
```

Le cœur UI est verrouillé. Son extension est gelée par défaut.

## Assets

```text
ASSET-01 : manifeste intégré
ASSET-02 : références personnages intégrées
ASSET-03 : lieux et lot pilote intégrés
PILOT-01 : sélectionné, non généré
Production visuelle réelle : non commencée
```

La production visuelle n’est pas la priorité immédiate tant que la chaîne jouable progresse journée par journée.

---

# 2. Positionnement verrouillé

```text
J01–J21 restent la Saison 1 de référence.
```

La future intégration runtime ne doit pas :

- réécrire les dialogues signés sans contradiction démontrée ;
- reprendre les anciens index modulaires comme autorité ;
- créer une seconde chaîne de saison ;
- réintroduire scores, owners ou candidate pools ;
- contourner la livraison Messages commune ;
- recréer une horloge, des séparateurs, non-lus ou notifications par journée ;
- accélérer les transitions avec la vitesse de lecture.

---

# 3. Priorité immédiate — J05

## Objectif

```text
Rendre J05 jouable après J04 dans Season1RuntimeProvider.
```

J05 ouvre l’Acte II. Le lot doit rester borné à une seule journée.

## Sources obligatoires

```text
docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md
docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md
docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md
docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

## Point narratif structurant

J05 doit traiter la demande de Marie d’une heure réelle et la promesse structurée associée :

```text
marie_j05_shared_hour
```

Le runtime doit distinguer :

- engagement concret ;
- horaire alternatif précis ;
- refus clair ;
- absence de promesse pour une réponse vague ;
- conséquence si Marie agit seule.

Aucune promesse ne doit être créée avant le choix autoritatif.

## Périmètre recommandé

- `J05RuntimeProvider.gd` ;
- `j05_runtime_map.json` ;
- extension bornée de `Season1State` ;
- handoff J04→J05 ;
- snapshot/restore J05 ;
- fils, horaires, transitions et contenus J05 ;
- tests statiques et smoke jouable ;
- non-régression complète J01–J04 et UI-MSG-04A à 04C.

## Hors périmètre

- intégration simultanée de J06–J08 ;
- réécriture générale de l’Acte II ;
- nouveau système de route ;
- refactor massif des providers ;
- production d’assets finaux ;
- persistance Galerie globale ;
- écrans système ;
- nouveau chantier UI sans blocage démontré.

Branche recommandée :

```text
work/runtime-s1-05-j05-playable
```

---

# 4. Ordre d’intégration recommandé

```text
J05
→ validation et verrouillage
→ J06
→ validation et verrouillage
→ J07
→ validation et verrouillage
→ J08
→ verrouillage de l’Acte II jouable
→ actes suivants par blocs courts
```

Le découpage journée par journée reste préférable tant que chaque nouvelle journée révèle des comportements transversaux à stabiliser.

Chaque lot doit :

1. partir de la dernière baseline stable ;
2. citer ses sources canoniques ;
3. prolonger la chaîne commune ;
4. préserver toutes les journées déjà jouables ;
5. ajouter handoff et restauration ;
6. passer la gate globale par identité exacte ;
7. obtenir une validation visuelle avant verrouillage.

---

# 5. Contrat de non-régression commun

Les règles J01–J04 sont normatives :

- heure provider-authoritative ;
- choix Player horodaté à l’acceptation ;
- transcripts cumulatifs ;
- absence de doublons ;
- `source_day` obligatoire ;
- un seul DayDivider par journée et par fil ;
- typing et livraison isolés ;
- non-lus calculés par `RuntimeUnread` ;
- nom et **« Nouveau message ! »** en `TEXT_PRIMARY`, gras `1.5` ;
- aucun badge numérique ;
- notification neutre et ouvrable ;
- transition unifiée et temps réel ;
- vitesse réservée aux messages et au typing ;
- snapshot versionné ;
- restauration cohérente ;
- teardown sans fuite ObjectDB.

---

# 6. Validation minimale d’un lot runtime

```text
validation des données
simulation des routes
statique dédié
smoke jouable dédié
handoff depuis la journée précédente
snapshot / restore
transcripts et doublons
heure et source_day
non-lus et notifications
transitions temps réel
responsive portrait
gate globale comparée par identité exacte
contrôle visuel utilisateur
```

Les nombres d’échecs historiques ne sont jamais codés en dur. La comparaison porte sur leurs identités réelles.

---

# 7. Chantiers différés

## Production visuelle réelle

```text
ASSET-04
workflow pilote Anima / ComfyUI
préparation technique de PILOT-01
production et sélection des vrais assets
```

## Persistance et système

- sauvegarde/chargement cible ;
- persistance Galerie ;
- état `REMOVED` ;
- permissions ajouter/retirer/partager ;
- écrans Titre, Pause, Paramètres et première configuration ;
- migration de sauvegardes si nécessaire.

## UI

L’UI ne se rouvre que pour un blocage narratif réel, les vrais assets, la persistance, les écrans système décidés ou une régression avérée.

---

# 8. Prochaine décision

```text
auditer précisément J05
→ définir son provider, ses états et son handoff
→ intégrer J05 seul
→ valider technique et visuel
→ verrouiller avant J06
```

Aucun nouveau plan général ne doit dupliquer le contrat runtime actif.