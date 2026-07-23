# Réseau Intime

**Réseau Intime** est un jeu narratif adulte en interface smartphone, développé avec Godot 4.6.x.

Le joueur incarne **Player**, en couple avec **Marie**, et fait lentement évoluer plusieurs relations crédibles par ses messages, ses actes, ses absences, ses promesses et la manière dont il traite les images et les secrets.

```text
Quand les personnages sont ensemble, ils parlent hors téléphone.
Quand la distance, la confidentialité, une trace ou l’après-coup le justifie,
le téléphone enregistre l’échange.
```

---

# État actuel du projet

## Narration

```text
Bible Narrative / North Star : autorité produit active
Saison 1 J01–J21 : corpus consolidé et signé
Priorité produit : production narrative sous l’autorité de la Bible
```

Le corpus signé reste la référence pour les scripts J01–J21. La prochaine décision narrative détaillée n’est pas imposée par ce portail : elle doit partir de la hiérarchie canonique `routes → actes → séquences → scènes → dialogues/photos → journées`.

Sources :

```text
docs/canon/bible/
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
```

## UX/UI

```text
T‑UI‑01 à T‑UI‑03D : implémentés et validés
UI CORE PROTOTYPE : verrouillé
Extension UI par défaut : gelée
Baseline UI documentée : 25928abf9149b5305fea2c08dfae9a47cdbf775c
```

Le dépôt possède désormais un cœur UI portrait additif comprenant la coque, Messages, Galerie, ImageMessage, PhotoViewer et les états locaux `NEW / VIEWED / LOCKED`.

Les vrais assets, la persistance Galerie, `REMOVED`, les permissions runtime et les écrans système restent des cibles canoniques différées.

Source :

```text
docs/canon/ui/README.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

## Runtime actuel

`main` contient deux réalités à distinguer :

1. un runtime narratif historique construit par couches V0.xx ;
2. un prototype UI portrait additif et validé.

Le cœur UI portrait ne constitue pas encore une migration complète du runtime narratif. Le contrôle historique `1280 × 720` reste présent, tandis que les scènes portrait sont testées à `720 × 1280`, `1080 × 1920` et `1080 × 2340`.

Le code, les données et les tests sur `main` décrivent ce qui est réellement implémenté. Ils ne redéfinissent ni la Bible Narrative ni la cible UI.

---

# Lire avant de travailler

```text
1. docs/canon/DOCUMENTATION_READING_ORDER.md
2. docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
3. source autoritative du domaine
4. docs/runtime/README.md pour le code actif
5. ROADMAP.md pour la priorité courante
```

---

# Sources autoritatives

## Vision et narration

```text
docs/canon/bible/
docs/canon/characters/
docs/canon/dialogues/
```

## État narratif pré-runtime

```text
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md
docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md
docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
```

## UX/UI

```text
docs/canon/ui/
```

## État technique

```text
code + données + tests sur main
docs/runtime/README.md
```

Les documents `docs/V0_*.md`, les anciens fichiers numérotés à la racine de `docs/`, ainsi que `docs/narrative/` et `docs/story_state/`, sont historiques sauf référence explicite depuis l’ordre de lecture actif.

---

# Décisions produit verrouillées

- interface smartphone verticale ;
- messagerie principalement textuelle ;
- aucune route ou score visible ;
- Player reste principalement représenté par ses messages ;
- choix courts, naturels et non chronométrés par défaut ;
- couleurs personnages accompagnées d’avatars et de noms ;
- Galerie organisée par personnage ;
- images accessibles, nouvelles, verrouillées ou retirées selon le contrat canonique ;
- retirer une image n’efface ni les messages ni la connaissance acquise ;
- écrans système distincts du téléphone narratif ;
- photos comme étapes relationnelles, pas comme récompenses détachées du récit.

---

# Priorité de travail

```text
Bible Narrative / North Star
→ choix du prochain lot narratif
→ routes macro
→ actes et séquences
→ scènes modulaires
→ dialogues et photos attendues
→ découpage des journées
→ adaptation runtime lorsque nécessaire
```

Un nouveau lot UI ne s’ouvre que pour un besoin bloquant, l’intégration future des vrais assets, la persistance/sauvegarde, les écrans système explicitement décidés ou une régression avérée.

Voir `ROADMAP.md`.

---

# Validation technique de base

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
```

Les lots UI disposent en plus de matrices portrait, safe areas, reduced motion et navigation clavier. La gate globale compare les échecs historiques par identité exacte.

---

# Règle de contribution

```text
une source autoritative
→ un lot court
→ tests ciblés
→ portails synchronisés
```

Ne jamais créer une seconde vérité pour contourner une contradiction.
