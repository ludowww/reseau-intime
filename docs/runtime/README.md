# Réseau Intime — Index runtime actif

## Statut

**Catégorie : Portail technique actif**

Ce document décrit l’état réellement présent sur `main`. Il distingue le runtime narratif historique du cœur UI portrait additif.

Lire d’abord :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
docs/canon/ui/README.md
```

---

# 1. État réel de `main`

## Runtime narratif historique

Le dépôt conserve un prototype construit par couches V0.xx comprenant notamment :

- chronologie et jours ;
- phases et expirations ;
- fils persistants ;
- messages et choix ;
- notifications ;
- non-lus ;
- archives ;
- activités hors téléphone internes ;
- matériaux narratifs partiellement réconciliés ;
- tests statiques et outils de validation.

## Cœur UI portrait additif

Les lots T‑UI‑01 à T‑UI‑03D ont ajouté et validé :

- coque portrait ;
- safe areas ;
- navigation Messages / Galerie ;
- famille Messages ;
- ImageMessage ;
- Galerie responsive ;
- PhotoViewer partagé ;
- états locaux `NEW / VIEWED / LOCKED` ;
- matrices portrait, reduced motion et clavier.

Le projet conserve encore un contrôle historique :

```text
1280 × 720
```

Le cœur portrait est testé à :

```text
720 × 1280
1080 × 1920
1080 × 2340
```

Cette coexistence ne signifie pas que le runtime narratif complet, la persistance, les vrais assets ou les écrans système ont été migrés.

---

# 2. Frontière d’autorité

Le runtime existant ne doit pas être utilisé pour déduire :

- l’architecture narrative finale ;
- les routes ;
- les voix ;
- les fonctions relationnelles des photos ;
- les permissions Galerie ;
- les écrans système finaux.

Sources autoritatives :

```text
vision     → docs/canon/bible/
personnages→ docs/canon/characters/
narration  → docs/canon/dialogues/
état       → registres J01–J21 + SEASON_1_NARRATIVE_STATE_CONTRACT.md
UI         → docs/canon/ui/
runtime    → code, données et tests sur main
```

---

# 3. Documents historiques

Sont historiques sauf lien explicite depuis un plan actif :

- rapports et plans V0.xx ;
- anciens audits runtime ;
- fichiers numérotés à la racine de `docs/` ;
- `docs/narrative/` ;
- `docs/story_state/` ;
- anciennes checklists de branche.

Ils ne remplacent pas :

- la Bible Narrative ;
- le corpus signé J01–J21 ;
- le contrat d’état borné ;
- la charte UI portrait ;
- le checkpoint UI implémenté.

---

# 4. État narratif du prototype

Le prototype contient des matériaux jouables antérieurs et plusieurs réconciliations ciblées.

État prudent :

```text
J01–J06   matériaux historiques et réconciliations partielles
J07+      couches possibles, non autoritatives pour le corpus final
UI        cœur portrait additif disponible
```

Le corpus canonique J01–J21 ne doit pas être inféré depuis les JSON ou scènes historiques.

Toute adaptation runtime future repart de `main`, relit l’ordre canonique et définit un bloc court.

---

# 5. Fondations à préserver si compatibles

- chronologie ;
- fils persistants ;
- stockage des transcripts ;
- notification inter-fil ;
- non-lus ;
- choix manuels Player ;
- archives en lecture seule ;
- séparation des activités hors téléphone ;
- outils de validation ;
- tests statiques ;
- composants portrait validés.

Ces fondations peuvent être adaptées ou remplacées si un besoin canonique le démontre. Elles ne sont pas sacrées par leur ancien numéro de version.

---

# 6. Concepts à ne pas réintroduire

```text
route owner
wave owner
candidate pool générique
external ticket comme sélection de personnage
score d’attachement
score de mensonge
propriétaire automatique d’une route
```

Le contrat futur utilise des états bornés, promesses, obligations, traces, connaissances, contradictions actives et historique léger.

---

# 7. Gel et réouverture technique

Le cœur UI est gelé par défaut après T‑UI‑03D.

Un nouveau lot technique ne s’ouvre que pour :

- un besoin narratif bloquant ;
- l’intégration future des vrais assets ;
- la persistance ou la sauvegarde ;
- les écrans système explicitement décidés ;
- une régression avérée ;
- l’adaptation runtime d’un bloc narratif clairement cadré.

Aucun ancien `T‑UI‑01` ou `T‑NAR‑01` n’est automatiquement réactivé.

Chaque plan actif cite :

```text
docs/canon/bible/00_NORTH_STAR.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
besoin produit et fichiers visés
tests d’acceptation
```

---

# 8. Validation de base

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
```

Les lots UI ajoutent leurs matrices portrait. La gate globale compare les échecs historiques par identité exacte.

Le test horizontal ne sera retiré qu’après une décision explicite et une couverture portrait équivalente du flux concerné.

---

# 9. Règle de plan runtime

Un nouveau document sous `docs/runtime/` doit être :

- lié à une branche ou un objectif concret ;
- court ;
- explicite sur les fichiers visés ;
- explicite sur les autorités canoniques ;
- marqué historique après intégration ou abandon.

Aucun nouveau plan général ne duplique `ROADMAP.md`.
