# Documentation Reading Order — Réseau Intime

> **Phase active : Actes I–V validés, production des assets à préparer**

```text
Bible Narrative / North Star : autorité active
Corpus J01–J21 : consolidé et signé
NAR‑PROD‑01 : terminé et intégré
NAR‑PROD‑02 : Acte I / J01–J04 READY
NAR‑PROD‑03 : Acte II / J05–J08 READY
NAR‑PROD‑04 : Acte III / J09–J12 READY
NAR‑CANON‑01 : contrats J14→J16 réparés
NAR‑PROD‑05 : Acte IV / J13–J16 READY
NAR‑PROD‑06 : Acte V / J17–J21 READY
UI et runtime : gelés
Assets : spécifiés, non produits
```

---

# 0. Gouvernance

Lire avant toute modification :

```text
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
```

Ce document définit les sources autoritatives, les statuts actifs ou historiques, la séparation Canon / UI / Runtime et la règle anti-dispersion.

---

# 1. Vision produit

```text
docs/canon/bible/00_NORTH_STAR.md
docs/canon/bible/01_EXPERIENCE_JOUEUR.md
docs/canon/bible/02_FANTASMES_CENTRAUX.md
```

---

# 2. Personnages et voix

```text
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/canon/bible/13_BIBLE_VOIX_MESSAGERIE_ET_TESTS_DISTINCTION.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

---

# 3. Architecture narrative

```text
docs/canon/bible/03_GRAMMAIRE_NARRATIVE.md
docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md
docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md
docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md
docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md
docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md
docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md
docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md
docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md
```

Hiérarchie :

```text
North Star
→ routes macro
→ actes
→ séquences
→ scènes modulaires
→ dialogues et photos
→ journées
→ runtime
```

---

# 4. Plans détaillés et communication

```text
docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md
docs/canon/bible/12B_PLANS_SCENES_J09_J12.md
docs/canon/bible/12C_PLANS_SCENES_J13_J16.md
docs/canon/bible/12D_PLANS_SCENES_J17_J21.md
docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md
docs/canon/TEXT_ONLY_MESSAGING_CANON.md
```

`12E` est historique. Certains diagnostics et cases de `12A–12D` précèdent le sign-off final. Les scripts consolidés, registres et sign-off prévalent.

---

# 5. Sources narratives consolidées

```text
docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md
docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J13_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J15_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J16_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J18_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J20_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md
```

## Addenda adultes validés

Lire ensuite, dans cet ordre :

```text
docs/canon/dialogues/NAR_PROD_07_ADULT_PAYOFF_AUDIT_SPECIFICATION.md
docs/canon/dialogues/NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md
docs/canon/dialogues/NAR_ADULT_02_PAYOFF_SANDRA_J18.md
docs/canon/dialogues/NAR_ADULT_03_PAYOFFS_PAULINE_RAPHAELLE.md
```

Les addenda adultes ont été intégrés aux scripts, registres et paquets NAR-PROD à la baseline `0820d87`.

Ils restent des dossiers de décision actifs et ne remplacent pas les scripts consolidés.

---

# 6. Contrats pré-runtime

Lire ensemble :

```text
docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md
docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md
docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
```

Pour J14→J16, lire d’abord :

```text
docs/canon/dialogues/NAR_CANON_01_REPARATION_PROMESSES_ATTEIGNABILITE_J14_J16.md
```

NAR-CANON-01 a corrigé :

```text
J01_J21_PROMISE_REGISTRY.md
J01_J21_REACHABILITY_MATRIX.md
SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

NAR-PROD-05 a ensuite corrigé uniquement T17 et T18 dans :

```text
J01_J21_TRACE_REGISTRY.md
```

Contrat synthétique :

```text
P14 : D-C avec heure précise uniquement
P15 : PAID ou FAILED en J14
7 promesses conditionnelles J14→J15
S28 FULL_COLLISION : deux fiches prouvées
S28 sans paire : S28_MUTATION_NO_COLLISION
T17 : Pauline / L’Annexe / enfant de C12-03
T18 : PHOTO autonome Maud / Raphaëlle
T20 / T21 / T22 : FACT_RECORD sans asset
P17 : conséquence réelle restante uniquement
T23 / T25 / T27 : FACT_RECORD ou TEXT_MESSAGE sans asset
T24 : PHYSICAL_PRINT Sandra réutilisant T01
T26 : ACCESS_GRANT ou ACCESS_REVOCATION sans photo
T28 : ABSENCE_MARKER, jamais fichier restauré
```

---

# 7. Audits, corrections et sign-off

```text
docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
docs/canon/dialogues/J01_J21_AUDIT_GLOBAL_DIALOGUES_CONTINUITE.md
docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md
docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
docs/canon/dialogues/NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md
docs/canon/dialogues/NAR_CANON_01_REPARATION_PROMESSES_ATTEIGNABILITE_J14_J16.md
```

Les anciens audits et lots correctifs restent des archives de décision. Les scripts consolidés et le sign-off final ont autorité. NAR‑PROD‑01 classe la préparation à la production. NAR‑CANON‑01 corrige uniquement le contrat J14→J16 sans réécrire les dialogues signés.

---

# 8. Paquets de production

```text
docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md
docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md
docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md
docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md
docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md
docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md
docs/canon/dialogues/ASSET_02_CHARACTER_REFERENCES.md
docs/canon/dialogues/ASSET_03_LOCATION_REFERENCES_AND_PILOT_BATCH.md
```

Ces paquets sont dérivés des sources autoritatives. Ils ne constituent ni une seconde carte de saison, ni un nouveau canon concurrent.

## Acte I — NAR-PROD-02

```text
13 contenus principaux
15 fichiers visuels sources
2 PHOTO_DIÉGÉTIQUE
11 SOUVENIR_IMAGE_DE_SCÈNE
0 variante conditionnelle
J01–J04 : READY
```

## Acte II — NAR-PROD-03

```text
12 beats servis par partie
11 nouveaux contenus principaux
6 contenus Acte I réutilisés
14 nouveaux fichiers sources
3 variantes conditionnelles J08
J05–J08 : READY
```

## Acte III — NAR-PROD-04

```text
14 beats servis par partie
21 nouveaux contenus principaux
8 réutilisations antérieures distinctes
30 nouveaux fichiers sources
2 variantes conditionnelles J11
J09–J12 : READY
```

Décisions structurantes de l’Acte III :

- J09 possède Marie comme pivot unique ; l’ancien prototype Sandra-only est non autoritatif ;
- J10 ne foreground qu’une seule continuité extérieure ou aucune ;
- J11 continue exclusivement le pivot actif ou Marie ;
- J12 évite toute image de groupe all-cast universelle ;
- Player reste non identifiable ;
- C10-05 couvre uniquement la seconde comparaison Raphaëlle R-A ;
- C10-06 et C10-07 sont créées par Sophie ;
- C12-03 est créé et possédé par Pauline.

## Acte IV — NAR-PROD-05

```text
12 beats servis par partie
10 nouveaux contenus principaux
12 réutilisations antérieures distinctes
12 nouveaux fichiers sources
2 fichiers enfants
1 variante conditionnelle
2 PHOTO_DIÉGÉTIQUE
8 SOUVENIR_IMAGE_DE_SCÈNE
0 FACT_RECORD visuel
J13–J16 : READY
```

Décisions structurantes de l’Acte IV :

- J13 foreground une seule conséquence et conserve un écho Marie ;
- C13-01 Pauline et C13-02 Raphaëlle sont mutuellement exclusifs ;
- T17 est la quatrième frame privée Pauline issue de C12-03 à L’Annexe ;
- T18 est une photographie autonome créée par Maud et sélectionnée par Raphaëlle ;
- J14 n’invente aucune découverte ;
- J15 utilise `FULL_COLLISION` avec deux fiches prouvées, puis `S28_MUTATION_NO_COLLISION` sinon ;
- Raphaëlle et Nico ne reçoivent aucune seconde obligation inventée ;
- P17 est conditionnelle à une conséquence réelle ;
- J16 peut atteindre la priorité 8 après fermeture propre.

## Acte V — NAR-PROD-06

```text
15 beats servis par partie
8 nouveaux contenus principaux
14 réutilisations historiques distinctes disponibles
13 nouveaux fichiers sources
3 fichiers enfants
2 variantes conditionnelles
J21 : 0 nouveau contenu, 0 fichier, 0 trace, 0 photographie
J17–J21 : READY
```

Décisions structurantes de l’Acte V :

- J17 utilise trois contenus et deux familles visuelles du couple sans fusionner les états narratifs ;
- T23 reste un `FACT_RECORD` sans fichier ;
- T24 est une impression physique contrôlée par Sandra et réutilise le fichier photographique T01 ;
- C18-01 reste une image de scène non diégétique distincte de T24 ;
- l’intimité tardive Sandra remplace la résolution standard et son aftercare réutilise C18-02 en J19 ;
- J19 contient deux foregrounds de catalogue alternatifs, jamais servis ensemble comme deux foregrounds ;
- T25 et T26 restent message ou état d’accès sans photographie ;
- J20 ne produit qu’un contenu Nico, sans variante par état ;
- P23 est créée à la proposition précise et activée seulement après acceptation ;
- T27 et T28 restent fait ou absence ;
- J21 est strictement `REFERENCE_ONLY` / `NO_NEW_ASSET` pour toute ancienne proposition de nouveau visuel ;
- les traces non photographiques guident le sens mais ne deviennent jamais « la dernière photo » ;
- aucune restauration, aucun onglet Galerie et aucun onglet « Souvenir ».

## Manifeste transversal — ASSET-01

```text
63 contenus principaux
84 fichiers physiques
8 variantes
J21 = 0 nouveau fichier
tous SPECIFIED_NOT_PRODUCED
```

ASSET-01 consolide l’identité, le comptage, l’ordre et le statut des fichiers physiques. Les briefs détaillés restent dans NAR-PROD-02 à NAR-PROD-06.

Règles transversales :

- Player reste non identifiable ;
- un `FACT_RECORD` ne devient jamais une photo ;
- une image de scène ne devient jamais preuve ou trace ;
- les réutilisations conservent leur `asset_id`, audience et permanence ;
- aucun onglet visible « Souvenir » ;
- les comportements Galerie non spécifiés restent différés ;
- aucun paquet n’autorise à lui seul une modification runtime ou une production d’asset.

Les cinq paquets constituent désormais la référence de production visuelle J01–J21, sans concurrencer le document `11`.

## Référence de préproduction visuelle — ASSET-02

ASSET-02 verrouille les références humaines récurrentes de Marie, Sandra, Mathilde, Pauline, Raphaëlle, Nico, Bastien, Jeff et Maud.

Il se lit après ASSET-01 et avant toute préparation de planches, de prompts ou de lots de génération. Il ne crée aucun asset, ne modifie aucun comptage et ne remplace ni le canon personnage ni les briefs détaillés.

## Référence des lieux et batch pilote — ASSET-03

ASSET-03 verrouille les principales références de lieux et sélectionne PILOT-01, huit fichiers non générés.

Il se lit après ASSET-01 et ASSET-02, avant tout workflow ou batch ComfyUI.

---

# 9. UX/UI active

```text
docs/canon/ui/README.md
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

Ordre d’autorité :

```text
UI_01 système visuel et responsive
→ UI_02 écrans et états canoniques
→ UI_03 intégration, état implémenté et différé
```

Le cœur UI prototype est implémenté et gelé. Les maquettes conceptuelles ne sont pas des assets finaux.

---

# 10. Runtime

Après lecture du canon, des paquets de production et de l’UI :

```text
docs/runtime/README.md
code + données + tests sur main
```

Le runtime historique et le cœur UI portrait additif coexistent. Aucun des deux ne redéfinit le canon produit.

---

# 11. Documents historiques

Sont `HISTORICAL` sauf lien explicite depuis un index actif :

```text
docs/V0_*.md
docs/NN_*.md à la racine de docs/
docs/narrative/
docs/story_state/
anciens rapports et plans de branche
```

`docs/01_NARRATIVE_BIBLE.md` et `docs/03_ROUTE_ARCHITECTURE.md` ne sont pas des sources actuelles.

---

# 12. Ordre de production actuel

```text
corpus narratif signé
→ cœur UI portrait verrouillé
→ NAR‑PROD‑01 terminé
→ NAR‑PROD‑02 Acte I / J01–J04 READY
→ NAR‑PROD‑03 Acte II / J05–J08 READY
→ NAR‑PROD‑04 Acte III / J09–J12 READY
→ NAR‑CANON‑01 J14→J16 READY
→ NAR‑PROD‑05 Acte IV / J13–J16 READY
→ NAR‑PROD‑06 Acte V / J17–J21 READY
→ ASSET‑01 manifeste final / 84 fichiers READY
→ préparation des références avant production effective
→ adaptation runtime seulement lorsque nécessaire
```

Aucun ancien lot UI ou runtime n’est automatiquement la prochaine action.

---

# 13. Autorité synthétique

```text
Vision et structure : docs/canon/bible/
Personnages : docs/canon/characters/
Narration J01–J21 : scripts consolidés + registres + sign-off
Audit de préparation : NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md
Correctif J14→J16 : NAR_CANON_01_REPARATION_PROMESSES_ATTEIGNABILITE_J14_J16.md
Paquets de production : NAR_PROD_02, NAR_PROD_03, NAR_PROD_04, NAR_PROD_05, NAR_PROD_06
Manifeste physique global : ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md
UI/UX : docs/canon/ui/
Runtime réel : code, données et tests sur main
Statut et priorité : README.md + ROADMAP.md
Historique : anciens rapports, plans V0.xx et fichiers racine non indexés
```

Aucun résumé ne doit redéfinir la source de son domaine.
