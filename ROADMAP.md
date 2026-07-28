# Réseau Intime — Roadmap active

## Statut

**Catégorie : portail projet actif**

**Baseline stable : `c27bd9331c01bed6c9a40c0c642d246cf26bb6cf`**

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

Le corpus signé reste autoritaire pour J01–J21. La Bible Narrative reste autoritaire pour toute nouvelle production, révision structurelle ou extension.

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
J04–J21 : non intégrés dans la nouvelle chaîne
```

La baseline J01–J03 comprend :

- `Season1RuntimeProvider` ;
- `Season1State` partagé ;
- providers bornés par journée ;
- transcripts et fils cumulatifs ;
- temps narratif monotone ;
- transitions unifiées ;
- snapshots et restauration ;
- livraison progressive des messages ;
- notifications interactives ;
- séparateurs par `source_day` ;
- vitesse limitée aux messages et au typing.

Contrat actif :

```text
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
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

Le cœur UI est verrouillé. Son extension est gelée par défaut. Les correctifs communs restent obligatoires pour toutes les futures journées.

## Assets

```text
ASSET-01 : manifeste intégré
ASSET-02 : références personnages intégrées
ASSET-03 : lieux et lot pilote intégrés
PILOT-01 : sélectionné, non généré
Production visuelle réelle : non commencée
```

La production visuelle reste prête à démarrer, mais elle n’est pas la priorité technique immédiate tant que la chaîne narrative jouable n’a pas dépassé J03.

---

# 2. Positionnement verrouillé

```text
J01–J21 restent la Saison 1 de référence.
```

Le corpus signé n’est pas rouvert comme chantier structurel général. Une correction narrative exige une contradiction canonique, une rupture de continuité, un problème de consentement ou d’audience, une incohérence entre sources ou un blocage de production démontré.

La future intégration runtime ne doit pas :

- réécrire les dialogues signés sans raison démontrée ;
- reprendre les anciens index modulaires comme autorité ;
- créer une seconde chaîne de saison ;
- réintroduire scores, owners ou candidate pools ;
- contourner la livraison Messages commune ;
- recréer une horloge, des séparateurs ou des notifications par journée ;
- accélérer les transitions avec la vitesse de lecture.

---

# 3. Priorité immédiate — J04

## Objectif

```text
Rendre J04 jouable après J03 dans la chaîne Season1RuntimeProvider.
```

## Sources obligatoires

```text
docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md
docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md
docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md
docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

## Périmètre recommandé

- `J04RuntimeProvider.gd` ;
- `j04_runtime_map.json` ;
- extension bornée de `Season1State` ;
- handoff J03→J04 ;
- snapshot/restore J04 ;
- intégration des fils, horaires, transitions et contenus J04 ;
- tests statiques et smoke jouable ;
- non-régression complète J01–J03 et UI-MSG-04A à 04C.

## Hors périmètre

- réécriture globale J04 ;
- migration simultanée J05–J21 ;
- nouveau système de route ;
- refactor massif des providers ;
- production des assets finaux ;
- persistance Galerie globale ;
- écrans système ;
- nouveau chantier UI sans blocage démontré.

---

# 4. Ordre d’intégration recommandé

```text
J04
→ verrouillage de l’Acte I jouable
→ J05–J08 par blocs courts
→ J09–J12
→ J13–J16
→ J17–J21
```

Chaque bloc doit :

1. partir de la dernière baseline stable ;
2. citer les sources canoniques ;
3. prolonger la chaîne commune ;
4. préserver les journées déjà jouables ;
5. ajouter ses tests de handoff et restauration ;
6. passer la gate globale par identité exacte ;
7. obtenir une validation visuelle avant verrouillage.

Le découpage exact après J04 peut être affiné selon la densité réelle. Aucun bloc ne doit devenir une migration globale incontrôlable.

---

# 5. Contrat de non-régression commun

Les corrections J01–J03 et UI-MSG-04A à 04C sont normatives :

- heure provider-authoritative ;
- choix Player horodaté à l’acceptation ;
- transcripts cumulatifs ;
- pas de doublon ;
- `source_day` obligatoire ;
- un seul DayDivider par journée et par fil ;
- aucun `SYSTEM_DAY_DIVIDER` en bulle ;
- typing et livraison isolés par conversation ;
- notification ouvrable ;
- transition unifiée et temps réel ;
- `×1 / ×3 / ×8` réservé aux messages et au typing ;
- snapshot versionné ;
- restauration cohérente ;
- teardown de smoke sans fuite ObjectDB.

Une journée future hérite automatiquement de ces corrections uniquement en passant par les couches communes.

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
notifications et non-lus
transitions temps réel
responsive portrait
gate globale comparée par identité exacte
contrôle visuel utilisateur
```

Baseline connue à `c27bd933…` :

```text
388 tests
17 FAIL historiques
2 ERROR historiques
19 identités historiques identiques
6 avertissements J6/J7 historiques
04C/04C1 sans ObjectDB, leaked ou orphan
```

Ces nombres sont une preuve de la baseline, pas une valeur à coder en dur. Toute validation future compare les identités réelles.

---

# 7. Chantiers différés

## Production visuelle réelle

À reprendre après décision explicite :

```text
ASSET-04
workflow pilote Anima / ComfyUI
préparation technique de PILOT-01
production et sélection des vrais assets
```

## Persistance et système

Restent différés :

- sauvegarde/chargement cible ;
- persistance Galerie ;
- état `REMOVED` ;
- permissions ajouter/retirer/partager ;
- écrans Titre, Pause, Paramètres et première configuration ;
- migration de sauvegardes si le format global évolue.

## UI

L’UI ne se rouvre que pour :

- un blocage narratif réel ;
- l’intégration des vrais assets ;
- la persistance ;
- les écrans système décidés ;
- une régression avérée.

---

# 8. Prochaine décision

```text
Ouvrir un lot J04 documentation technique courte
→ auditer les sources exactes
→ définir le provider et le handoff
→ intégrer sans réécriture narrative
```

Aucun nouveau plan général ne doit dupliquer le contrat runtime actif ou créer un calendrier concurrent.
