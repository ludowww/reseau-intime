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
Saison 1 J01–J21 : corpus finalisé et signé
Blocage narratif restant : aucun
```

Source :

```text
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
```

## UX/UI

```text
UI‑FOUNDATION : validé
UI‑SCREENS : validé
UI‑HANDOFF : validé
Cible future : smartphone vertical 720 × 1280, ratio 9:16
Style : sombre, anime-inspired, couleurs par personnage
Galerie : collection photo organisée par personnage
```

Source :

```text
docs/canon/ui/README.md
```

## Reprise technique

```text
Prête à être planifiée
Non encore autorisée explicitement
```

Le prochain lot possible est un plan court `T‑UI‑01` pour la coque portrait. Il doit repartir de `main` courant et être exécuté dans l’environnement Hermes avec Godot.

## Runtime actuel

Le dépôt contient un prototype jouable construit par couches historiques V0.xx.

Acquis potentiellement réutilisables :

- fils persistants ;
- choix ;
- chronologie ;
- notifications et non-lus ;
- archives ;
- outils de validation.

Limites :

```text
résolution active : 1280 × 720 horizontal
architecture narrative : antérieure au corpus final sur plusieurs journées
UI : antérieure à la cible portrait
J07–J21 : non intégrés conformément au corpus signé
```

L’ancien runtime ne définit ni le canon narratif ni la future interface.

---

# Lire avant de travailler

```text
1. docs/canon/DOCUMENTATION_READING_ORDER.md
2. docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
3. source autoritative du domaine
4. docs/runtime/README.md pour le code actif
5. ROADMAP.md pour l’ordre des lots
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

Les anciens plans et rapports V0.xx sont historiques sauf référence explicite depuis un index actif.

---

# Décisions produit verrouillées

- interface smartphone verticale future ;
- messagerie texte uniquement ;
- aucune route ou score visible ;
- Player reste principalement représenté par ses messages ;
- choix courts, naturels et non chronométrés par défaut ;
- couleurs personnages accompagnées d’avatars et de noms ;
- Galerie photo classique avec onglets par personnage ;
- images visibles, nouvelles, verrouillées ou retirées ;
- retirer une image n’efface ni les messages ni la connaissance acquise ;
- écrans système distincts du téléphone narratif ;
- narration complète avant migration runtime globale.

---

# Prochaine séquence de travail

```text
UI‑FOUNDATION  validé
UI‑SCREENS     validé
UI‑HANDOFF     validé
Décision       autoriser ou non la reprise technique
T‑UI‑01        coque portrait, safe areas, thème et navigation
T‑UI‑02        composants Messages
T‑UI‑03        Galerie et Photo
T‑UI‑04        écrans système
T‑NAR‑01       réconciliation J01–J06
T‑NAR suivants J07–J09 → J10–J12 → J13–J16 → J17–J21
```

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

Les futures branches UI devront ajouter :

```text
720 × 1280
1080 × 1920
1080 × 2340 environ
fenêtre PC portrait
texte agrandi
navigation clavier
animations réduites
```

Le test `1280 × 720` reste temporairement utile tant que l’ancienne interface n’a pas été explicitement retirée.

---

# Règle de contribution

```text
une source autoritative
→ un lot court
→ tests ciblés
→ index synchronisés dans la même PR
```

Ne jamais créer un second document actif pour contourner une contradiction.
