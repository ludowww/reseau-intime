# Réseau Intime — Index runtime actif

## Statut

**Catégorie : portail technique actif**

**Baseline stable décrite : `fa2880c1ad168569b148ed85bedf4774324f87dd`**

**Tag de verrouillage : `runtime-s1-11e-j11-a5-scene-presentation`**

Ce document résume l’état réellement présent sur `main`. Le code, les données et les tests restent l’autorité d’exécution.

Lire d’abord :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

---

# 1. État réel de `main`

## Chaîne Saison 1 présente

```text
J01–J21 → orchestrés dans Season1RuntimeProvider
J09–J12 → providers, maps runtime et tests dédiés présents
J11 A5 → dernier jalon produit explicitement verrouillé
```

La présence de J01–J21 dans le runtime ne prouve pas que chaque journée est
définitivement polie, que tous les contenus sont finalisés ou que toutes les
validations globales sont vertes.

La chaîne active repose notamment sur :

```text
game/scripts/runtime/season_1/Season1RuntimeProvider.gd
game/scripts/runtime/season_1/Season1State.gd
game/scripts/runtime/season_1/RuntimeUnread.gd
game/scripts/runtime/season_1/J01RuntimeProvider.gd
game/scripts/runtime/season_1/J02RuntimeProvider.gd
game/scripts/runtime/season_1/J03RuntimeProvider.gd
game/scripts/runtime/season_1/J04RuntimeProvider.gd
...
game/scripts/runtime/season_1/J21RuntimeProvider.gd
game/data/runtime/season_1/j01_runtime_map.json
game/data/runtime/season_1/j02_runtime_map.json
game/data/runtime/season_1/j03_runtime_map.json
game/data/runtime/season_1/j04_runtime_map.json
...
game/data/runtime/season_1/j21_runtime_map.json
```

Elle fournit :

- état de saison partagé ;
- providers bornés par journée ;
- handoffs et restauration couvrant J01→J21 ;
- transcripts, fils, identifiants et Galerie cumulatifs ;
- temps narratif monotone ;
- transitions unifiées ;
- snapshots versionnés et restauration ;
- présentation portrait Messages/Galerie.

---

# 2. Couche UI/runtime validée

La baseline inclut :

- bandeau de conversation avec jour et heure courants ;
- livraison progressive de tous les messages ;
- typing isolé par conversation ;
- conservation du scroll et du focus ;
- notifications interactives et neutres ;
- transitions `CLOCK`, `OFF_PHONE`, `NIGHT`, `NEW_DAY` et fin de contenu ;
- séparateurs normalisés par `source_day` ;
- vitesse `×1 / ×3 / ×8` limitée aux messages et au typing ;
- ImageMessage, Galerie et PhotoViewer partagés ;
- résolution commune des médias par `VisualMediaResolver` et `ResourceLoader` ;
- matrices responsive portrait et contrôle historique `1280 × 720`.

Les placeholders et prototypes ne sont jamais comptés comme assets finaux. J11 A5
contient deux parents Galerie et six enfants de séquence. Aucun des six assets finaux
n’est livré sur cette baseline ; le comportement verrouillé est **« Visuel non livré »**.

## Non-lus

La règle commune est portée par `RuntimeUnread.gd`.

Un fil non lu affiche :

- nom en `TEXT_PRIMARY` et gras fort ;
- **« Nouveau message ! »** en `TEXT_PRIMARY` et gras fort ;
- `variation_embolden = 1.5` ;
- heure réelle ;
- aucun badge ni compteur.

Après présentation complète, le véritable aperçu et `TEXT_SECONDARY` sont restaurés.

Fermer une notification, changer de journée ou ouvrir un autre fil ne marque rien comme lu.

## Notifications

```text
Titre : contact ou groupe
Corps : Nouveau message !
```

Aucun extrait narratif ni compteur n’est affiché. Le clic ouvre le fil concerné.

---

# 3. Statut J01–J21

| Journées | Narration | Runtime portrait |
|---|---|---|
| J01–J08 | consolidée et signée | providers, données et tests disponibles |
| J09–J12 | consolidée, paquet Acte III READY | providers, données et tests dédiés présents |
| J13–J16 | consolidée, paquet Acte IV READY | providers, données et tests disponibles |
| J17–J21 | consolidée, paquet Acte V READY | providers, données et tests disponibles |

Ce tableau décrit la présence sur la baseline, pas un niveau uniforme de polish ou
de validation produit. Les scripts signés et le sign-off restent l’autorité narrative.

---

# 4. Frontière d’autorité

```text
vision et routes         → docs/canon/bible/
personnages et voix      → docs/canon/characters/
dialogues J01–J21        → docs/canon/dialogues/
état narratif            → registres + SEASON_1_NARRATIVE_STATE_CONTRACT.md
UX/UI produit            → docs/canon/ui/
runtime actif            → code + données + tests sur main
continuité technique     → orchestrateur, providers, maps et tests sur la baseline
```

Le runtime ne déduit jamais une nouvelle vérité narrative. Le canon n’impose pas une classe Godot ou un format JSON sans décision technique.

---

# 5. Règles communes de la chaîne Saison 1

Toute évolution d’une journée doit conserver :

- `Season1State` partagé ;
- handoff cumulatif ;
- temps narratif du provider ;
- `source_day` exact ;
- livraison Messages commune ;
- `RuntimeUnread` ;
- notifications neutres ;
- transitions unifiées ;
- snapshot versionné ;
- restauration cohérente ;
- absence de scores, owner, candidate pool ou route visible.

Un provider ne fabrique pas directement des bulles, séparateurs, horloge, non-lus ou notifications parallèles.

Fondation historique de ces règles :

```text
docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

Ce contrat conserve la trace de la baseline J01–J04 ; il n’est plus le statut
runtime courant.

---

# 6. Matériaux historiques

Sont historiques sauf lien explicite depuis un portail actif :

- rapports et plans V0.xx ;
- anciens audits runtime ;
- fichiers numérotés à la racine de `docs/` ;
- `docs/narrative/` ;
- `docs/story_state/` ;
- anciens index et observations antérieurs à `Season1RuntimeProvider`.

Ils peuvent aider à localiser une ancienne intention, mais ne prévalent jamais sur `main` et le corpus canonique signé.

---

# 7. Validation de base

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
```

Pour chaque journée, ajouter :

- test statique ;
- smoke jouable ;
- handoff ;
- snapshot/restore ;
- contrôle des doublons, heures et `source_day` ;
- contrôle des non-lus et notifications ;
- transitions temps réel ;
- responsive portrait ;
- teardown sans fuite ObjectDB ;
- validation visuelle utilisateur.

La gate globale compare les échecs historiques par identité exacte ; elle ne fige
pas leurs nombres dans le code. Sur cette baseline, les 32 identités historiques
connues restent une dette existante et ne constituent pas une régression documentaire.

---

# 8. Recommandation suivante

```text
préparer un lot futur borné aux six assets enfants J11 A5
→ conserver les deux parents Galerie et les triplets ordonnés
→ utiliser le pipeline visuel commun
→ valider la livraison avant de retirer le fallback
```

Ne pas élargir ce futur lot vers un manifeste Acte III complet. Aucun nouveau
chantier UI ne s’ouvre sans besoin bloquant démontré.
