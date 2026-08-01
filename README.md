# Réseau Intime

**Réseau Intime** est un jeu narratif adulte en interface smartphone, développé avec Godot 4.6.x.

Le joueur incarne **Player**, en couple avec **Marie**, et fait évoluer plusieurs relations crédibles par ses messages, ses actes, ses absences, ses promesses, ses silences et la manière dont il traite les images et les secrets.

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

Hiérarchie canonique :

```text
routes → actes → séquences → scènes → dialogues/photos → journées → runtime
```

Sources principales :

```text
docs/canon/bible/
docs/canon/characters/
docs/canon/dialogues/
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

## Runtime Saison 1

Baseline technique verrouillée :

```text
fa2880c1ad168569b148ed85bedf4774324f87dd
runtime-s1-11e-j11-a5-scene-presentation
```

État présent dans la chaîne portrait Saison 1 :

```text
J01–J21 → orchestrés par Season1RuntimeProvider
J09–J12 → providers, données runtime et tests dédiés présents
J11 A5 → dernier jalon produit explicitement verrouillé
```

Cette présence runtime ne signifie pas que toutes les journées sont définitivement
polies, que tous les contenus ou visuels sont finalisés, ni que la gate globale est
entièrement verte.

La chaîne J01→J21 repose sur :

- `Season1RuntimeProvider` ;
- un `Season1State` partagé ;
- des providers bornés par journée ;
- des transcripts, fils et contenus cumulatifs ;
- un temps narratif autoritaire ;
- des transitions unifiées ;
- des snapshots versionnés ;
- `RuntimeUnread` pour la règle commune des non-lus.

Portail technique actif :

```text
docs/runtime/README.md
```

Le contrat J01–J04 est conservé comme fondation historique des règles communes ;
le code, les données et les tests sur la baseline priment pour l’état exécuté actuel.

## UX/UI

Le cœur portrait comprend :

- coque smartphone et safe areas ;
- Messages et Galerie ;
- conversations privées et de groupe ;
- choix Player, typing et livraison progressive ;
- bandeau conversation avec jour et heure ;
- notifications interactives et neutres ;
- transitions `CLOCK`, `OFF_PHONE`, `NIGHT`, `NEW_DAY` et fin de contenu ;
- séparateurs normalisés par `source_day` ;
- ImageMessage et PhotoViewer ;
- responsive portrait, reduced motion et clavier.

### Non-lus

Un fil non lu affiche :

```text
nom en TEXT_PRIMARY et gras fort
Nouveau message ! en TEXT_PRIMARY et gras fort
variation_embolden = 1.5
heure réelle
aucun badge ni compteur
```

Après présentation complète, le vrai aperçu et `TEXT_SECONDARY` sont restaurés.

### Vitesse

```text
×1 / ×3 / ×8 → messages et typing uniquement
transitions   → temps réel
```

L’architecture visuelle commune est opérationnelle : ImageMessage, Galerie et
PhotoViewer utilisent `VisualMediaResolver` et `ResourceLoader`. Les placeholders
et prototypes ne valent pas livraison finale. J11 A5 contient deux parents Galerie
et six enfants de séquence ; aucun de ces six assets finaux n’est livré sur la
baseline. Le fallback attendu reste **« Visuel non livré »**. La persistance Galerie,
l’état `REMOVED`, certaines permissions runtime et les écrans système restent différés.

---

# Lire avant de travailler

```text
1. docs/canon/DOCUMENTATION_READING_ORDER.md
2. docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
3. source autoritative du domaine
4. docs/runtime/README.md pour le code actif
5. code, données et tests de la baseline pour l’état exécuté
6. ROADMAP.md pour la priorité courante
```

---

# Sources autoritatives

| Domaine | Autorité |
|---|---|
| Vision et narration | `docs/canon/bible/`, `characters/`, `dialogues/` |
| État narratif | registres J01–J21 + contrat d’état |
| UX/UI produit | `docs/canon/ui/` |
| Runtime actif | code, données et tests sur `main` |
| Continuité technique | orchestrateur, providers, données et tests sur la baseline |

Les documents `docs/V0_*.md`, les anciens fichiers numérotés à la racine de `docs/`, `docs/narrative/` et `docs/story_state/` sont historiques sauf référence explicite depuis un portail actif.

---

# Décisions produit verrouillées

- interface smartphone verticale ;
- messagerie principalement textuelle ;
- aucune route ou score visible ;
- Player principalement représenté par ses messages ;
- choix courts, naturels et non chronométrés par défaut ;
- couleurs accompagnées d’avatars et de noms ;
- Galerie organisée par personnage ;
- photos comme étapes relationnelles ;
- temps narratif possédé par le runtime ;
- journées J01–J21 branchées sur une chaîne commune unique ;
- aucun runtime parallèle.

---

# Priorité de travail

```text
préparer un futur lot borné pour les six assets enfants J11 A5
→ conserver les deux parents Galerie et l’ordre des deux triplets
→ passer par le pipeline visuel commun
→ ne remplacer « Visuel non livré » qu’après livraison effective
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

Les lots runtime ajoutent tests statiques, smokes jouables, handoffs, snapshots, matrices portrait et contrôle des fuites. La gate globale compare les échecs historiques par identité exacte.

---

# Règle de contribution

```text
une source autoritative
→ un lot court
→ adaptation dans la chaîne commune
→ tests ciblés et comparaison des identités historiques
→ validation visuelle
→ portails synchronisés
```

Ne jamais créer une seconde vérité pour contourner une contradiction.
