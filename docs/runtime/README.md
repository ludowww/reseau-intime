# Réseau Intime — Index runtime actif

## Statut

**Catégorie : Portail technique actif**

Ce document décrit comment lire le runtime existant après la signature du corpus narratif et avant sa migration verticale.

Lire d’abord :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
docs/canon/ui/README.md
```

---

# 1. État réel du runtime

Le code sur `main` est un prototype construit par couches V0.xx.

Il comprend notamment :

- chronologie et jours ;
- phases et expirations ;
- fils persistants ;
- messages et choix ;
- notifications ;
- non-lus ;
- archives ;
- activités hors téléphone internes ;
- ouverture et premières répétitions partielles ;
- tests statiques et outils de validation.

Le projet Godot reste configuré en :

```text
1280 × 720 horizontal
```

La cible produit future est documentée en :

```text
720 × 1280 portrait
```

---

# 2. Frontière d’autorité

Le runtime existant ne doit pas être utilisé pour déduire :

- l’architecture finale de la saison ;
- la cible UI ;
- les routes ;
- les couleurs ;
- la Galerie ;
- les permissions d’image ;
- les états finaux.

Sources autoritatives :

```text
narration  → docs/canon/dialogues/
état       → registres J01–J21 + SEASON_1_NARRATIVE_STATE_CONTRACT.md
UI         → docs/canon/ui/
runtime    → code, données et tests sur main
```

---

# 3. Lecture des anciens documents V0.xx

Les documents suivants restent utiles comme historique d’implémentation :

- audits runtime ;
- plans de slices ;
- rapports V0.80–V0.90 ;
- checklists de validation ;
- notes sur TimelineState, notifications et archives.

Ils sont classés :

```text
HISTORICAL
```

sauf lorsqu’un futur plan actif les cite explicitement.

Ils ne doivent pas remplacer :

- le corpus signé J01–J21 ;
- le contrat d’état borné ;
- la charte UI portrait ;
- l’architecture des écrans.

---

# 4. État narratif du prototype

Le prototype contient des matériaux jouables antérieurs et plusieurs réconciliations ciblées.

État prudent à retenir :

```text
J01        partiellement réconcilié
J02        fondation utile
J03–J04    réconciliés dans leurs index actifs
J05–J06    runtime historique encore à réauditer depuis le canon signé
J07+       couches historiques possibles, non autoritatives pour le corpus final
```

La PR technique historique #54 reste ouverte en draft et n’est pas une base automatique de reprise.

Toute reprise J05–J06 doit repartir de `main`, relire les index actifs et comparer au corpus signé.

---

# 5. Fondations à préserver si compatibles

- `TimelineState` pour la chronologie ;
- fils persistants ;
- stockage des transcripts ;
- notification inter-fil ;
- non-lus ;
- choix manuels Player ;
- lecture seule des archives ;
- séparation des activités hors téléphone ;
- outils de validation de données ;
- tests statiques.

Ces fondations peuvent être adaptées ou remplacées si la migration portrait le justifie.

Elles ne sont pas sacrées par leur ancien numéro de version.

---

# 6. Concepts à ne pas réintroduire

Le futur runtime ne doit pas restaurer comme vérité produit :

```text
route owner
wave owner
candidate pool générique
external ticket comme sélection de femme
score d’attachement
score de mensonge
propriétaire R2 automatique
```

Le contrat futur utilise :

- états bornés ;
- promesses ;
- obligations ;
- traces ;
- connaissances ;
- contradictions actives ;
- historique de foreground léger.

---

# 7. Prochaine reprise technique

Aucune reprise technique n’est autorisée par ce document seul.

Ordre recommandé après validation UI :

```text
T‑UI‑01  coque portrait et composants
T‑UI‑02  Galerie et écrans système
T‑NAR‑01 réconciliation J01–J06
```

Chaque plan technique actif doit citer :

```text
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

---

# 8. Validation de base

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -v
git diff --check
godot --headless --path game --quit
```

Pendant la migration :

```text
conserver temporairement 1280 × 720
+ ajouter 720 × 1280
+ ajouter 1080 × 1920
+ ajouter un format portrait allongé
```

Le test horizontal pourra être supprimé seulement avec une décision explicite et des tests portrait équivalents.

---

# 9. Règle de plan runtime

Un nouveau document sous `docs/runtime/` doit être :

- lié à une branche concrète ;
- court ;
- daté par son contexte Git ;
- explicite sur les fichiers visés ;
- explicite sur les autorités canoniques ;
- marqué historique après intégration ou abandon.

Aucun nouveau plan général ne doit dupliquer la Roadmap active.
