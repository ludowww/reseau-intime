# Documentation Reading Order — Bible Narrative Current

> **Phase actuelle : Bible Narrative / North Star**
>
> La Bible Narrative est la source principale pour la promesse, les routes, les scènes, les visuels, les conséquences, le calendrier et les plans de production de la première saison.
>
> Les canons complets restent l’autorité première sur les personnes.
>
> Le runtime décrit ce qui est implémenté.

---

# 1. Ordre de conception

```text
North Star
→ Expérience joueur
→ Fantasmes
→ Canons complets
→ Routes
→ Évolution érotique
→ Actes
→ Séquences
→ Scènes
→ Visuels
→ Conséquences
→ Journées
→ Audits et plans détaillés
→ Dialogues / images
→ Runtime
```

---

# 2. Ordre de lecture officiel

## 1–5 — Vision et personnages

```text
docs/canon/bible/00_NORTH_STAR.md
docs/canon/bible/01_EXPERIENCE_JOUEUR.md
docs/canon/bible/02_FANTASMES_CENTRAUX.md
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
```

Ajouter selon le besoin :

```text
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
cartes de dépréciation ou de réconciliation
```

## 6 — Grammaire

`docs/canon/bible/03_GRAMMAIRE_NARRATIVE.md`

## 7 — Trame et actes

`docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md`

## 8 — Routes

`docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md`

## 9 — Évolution érotique

`docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md`

## 10 — Séquences

`docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md`

## 11 — Règles des scènes

`docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md`

## 12 — Progression visuelle

`docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md`

## 13 — Conséquences

`docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md`

## 14 — Distribution en journées

`docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md`

Ce document fixe les 21 journées et leurs fonctions.

## 15 — Plans détaillés et audit runtime

`docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`

Ce document :

- corrige le périmètre actif à J01–J06 ;
- audite les scènes et visuels actuels ;
- classe les scènes en `COMPATIBLE`, `ADAPTABLE`, `RELOCATE`, `REWRITE` ou `ARCHIVE` ;
- définit les cartes J05–J08 ;
- ne conçoit aucune image ;
- réserve les assets à une production ultérieure par Ludovic via ComfyUI.

## 16 — Dialogues

Futurs documents de rédaction.

## 17 — Production et intégration des images

Future couche après fourniture des assets.

## 18 — Runtime

Plans, index, conversations, tests et données effectivement actifs.

---

# 3. Runtime actuel

Le `DataLoader` actif charge :

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
chapter_04_modular_index.json
chapter_05_modular_index.json
chapter_06_modular_index.json
```

Donc :

```text
J01–J06 sont jouables
J07–J21 ne sont pas jouables
```

Le document `12` corrige les anciennes mentions limitées à J01–J04.

---

# 4. Audit actuel J01–J06

```text
J01 ADAPTABLE
J02 COMPATIBLE avec déficit visuel
J03 RESTRUCTURE / RELOCATE
J04 ADAPTABLE
J05 COMPATIBLE FOUNDATION
J06 ADAPTABLE
```

Aucune scène active n’est automatiquement archivée.

---

# 5. Visuels

Le document `09` reste l’autorité sur la fonction, l’audience et les métadonnées.

Le document `12` ne définit que des slots fonctionnels.

La conception et la génération sont différées à Ludovic via ComfyUI.

---

# 6. Contrats complémentaires

Lire selon le besoin :

- `docs/canon/CHOICE_DESIGN_CANON.md` ;
- `docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md` ;
- `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md` ;
- `docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md` ;
- `docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md`.

Ils ne peuvent pas contredire les documents `08–12`.

---

# 7. Règle finale

```text
07 choisit l’événement.
08 adapte la scène.
09 gouverne l’image.
10 gouverne la mémoire et la dette.
11 distribue la saison.
12 décide ce qui est conservé, déplacé ou réécrit.
Le runtime décrit ce qui est jouable.
```