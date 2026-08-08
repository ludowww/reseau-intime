# Documentation Reading Order — Réseau Intime

> **Phase active :** R8C — fondation du nouveau moteur narratif
> **Baseline consolidée par A4 :** `4dda96f437d1e44658b7fc0748dca421ab98c0cc`

## 1. Portails

1. `README.md` — état synthétique et gate.
2. `docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md` — autorité et statuts.
3. `docs/architecture/README.md` — ordre canonique R8A–R8C.
4. `docs/runtime/README.md` — oracle exécutable temporaire.
5. `ROADMAP.md` — lots à venir; il ne redéfinit pas le canon.

## 2. Autorité narrative

Lire d'abord :

- `docs/canon/bible/00_NORTH_STAR.md`;
- `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md`;
- `docs/canon/characters/CHARACTER_CANON_INDEX.md` puis les canons personnages;
- `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` et les
  scripts/registres auxquels il renvoie.

Les scripts J01–J21 restent un corpus narratif et un oracle de comportement. Le
nouveau moteur ne dépend ni de 21 journées fixes, ni d'une route par score.

## 3. Architecture R8A–R8C

L'ordre normatif complet est maintenu dans `docs/architecture/README.md` :

```text
contrat narratif R8A verrouillé
→ blueprint d'état R8A
→ contrat produit R8A-D1
→ vue de lecture R8B
→ fondation transactionnelle R8C-A1
→ contrat de scène R8C-A2
→ prototype synthétique R8C-A3
→ consolidation R8C-A4
```

Rappels :

- état relationnel qualitatif, aucun `route_points` ou `consent_score`;
- consentement local et retirable;
- micro-signal émis, reçu, interprété, puis effet `LOCAL`, `TEMPORAIRE` ou
  `DURABLE`;
- aucune accumulation automatique ni seuil d'emoji;
- une journée est un contenant diégétique, pas un quota;
- aucune nouvelle clé `jNN_*` dans le futur moteur.

## 4. Runtime et UI actuels

Le runtime démarré est :

```text
PortraitMain
→ PortraitShell (runtime_s1)
→ Season1RuntimeProvider
→ providers et runtime maps J01–J21
```

Il reste temporairement l'oracle exécutable. Pour un travail sur cette chaîne,
lire `docs/runtime/README.md`, puis le code, les données et les tests du SHA
courant. L'UI portrait canonique est décrite sous `docs/canon/ui/`.

## 5. À consulter si besoin — payoffs et montée dramatique

`docs/narrative/SEASON_1_DRAMATIC_SCENE_IDEA_BANK.md` est un
`NON_CANONICAL / CREATIVE_IDEA_BANK` à consulter uniquement pour les payoffs
futurs, les scènes modulaires, la montée dramatique et le calibrage d'intensité.
Il aide à vérifier que les scènes d'ouverture sèment les bonnes préconditions.

Ce réservoir ne promet aucune scène et ne modifie ni canon, ni chronologie, ni
route. Il ne prévaut jamais sur les blueprints, le canon, les scripts signés, les
contrats verrouillés ou la baseline exécutable concernée.

## 6. Matériaux historiques

Git et les tags sont l'archive. Un fichier ancien n'est pas conservé sur `main`
uniquement pour raconter l'évolution du projet. Les rapports V0.xx encore
présents n'ont aucune autorité, sauf lien explicite depuis un portail actif pour
une nécessité opérationnelle précise.

Le rapport `docs/maintenance/R8C_A4_CONSOLIDATION_CANONIQUE_ET_NETTOYAGE_LEGACY.md`
documente les suppressions et les composants temporairement conservés.
