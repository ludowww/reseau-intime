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
Paquets de production Actes I–V : READY
Blocage narratif restant : aucun
```

Le corpus signé reste la référence pour les scripts J01–J21. Toute adaptation technique part de la hiérarchie canonique :

```text
routes → actes → séquences → scènes → dialogues/photos → journées → runtime
```

Sources :

```text
docs/canon/bible/
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md
...
docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md
```

## Runtime Saison 1

Baseline stable :

```text
main / origin/main
c27bd9331c01bed6c9a40c0c642d246cf26bb6cf
ui-msg-04c-interactive-notifications
```

État réellement jouable dans la nouvelle chaîne portrait :

```text
J01 → intégré et validé
J02 → intégré après J01 et validé
J03 → intégré après J02 et validé
J04–J21 → canon prêt, intégration runtime à poursuivre
```

La chaîne J01→J03 repose sur `Season1RuntimeProvider`, un `Season1State` partagé, des providers bornés par journée, des transcripts cumulatifs, un temps narratif autoritaire, des transitions unifiées et des snapshots versionnés.

Les corrections apportées sur J01–J03 deviennent le contrat obligatoire des journées futures. Elles sont héritées lorsque J04+ utilise les mêmes composants et interfaces communes ; elles ne doivent pas être recopiées ou contournées dans un runtime parallèle.

Source technique active :

```text
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

## UX/UI

Le cœur portrait comprend :

- coque smartphone et safe areas ;
- Messages et Galerie ;
- conversations privées et de groupe ;
- choix Player, non-lus et typing ;
- livraison progressive des messages ;
- bandeau conversation avec jour et heure courants ;
- notifications interactives ;
- transitions `CLOCK`, `OFF_PHONE`, `NIGHT`, `NEW_DAY` et fin de contenu ;
- séparateurs de journées normalisés par `source_day` ;
- ImageMessage et PhotoViewer ;
- états locaux Galerie `NEW / VIEWED / LOCKED` ;
- responsive portrait, reduced motion et navigation clavier.

Règle de vitesse verrouillée :

```text
×1 / ×3 / ×8 → messages et typing uniquement
transitions   → temps réel
```

Les vrais assets, la persistance Galerie, `REMOVED`, les permissions runtime et les écrans système restent différés.

Sources :

```text
docs/canon/ui/README.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

---

# Lire avant de travailler

```text
1. docs/canon/DOCUMENTATION_READING_ORDER.md
2. docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
3. source autoritative du domaine
4. docs/runtime/README.md pour le code actif
5. docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
6. ROADMAP.md pour la priorité courante
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
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
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
- photos comme étapes relationnelles, pas comme récompenses détachées du récit ;
- temps narratif possédé par le runtime, jamais par un composant visuel ;
- futures journées branchées sur la chaîne commune J01–J03, sans runtime parallèle.

---

# Priorité de travail

```text
intégrer J04 depuis la baseline J01–J03
→ préserver les corrections communes
→ valider le handoff J03→J04
→ poursuivre ensuite par blocs courts d’acte
```

Un nouveau lot UI ne s’ouvre que pour un besoin bloquant démontré, les vrais assets, la persistance/sauvegarde, les écrans système explicitement décidés ou une régression avérée.

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

Les lots runtime ajoutent leurs tests statiques, smokes jouables, handoffs, snapshots et matrices portrait. La gate globale compare les échecs historiques par identité exacte.

---

# Règle de contribution

```text
une source autoritative
→ un lot court
→ adaptation dans la chaîne commune
→ tests ciblés et non-régression J01–J03
→ portails synchronisés
```

Ne jamais créer une seconde vérité pour contourner une contradiction.
