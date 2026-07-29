# Réseau Intime — Index runtime actif

## Statut

**Catégorie : portail technique actif**

**Baseline stable décrite : `5a6a832c148c68ee69d8991474ec778f33bc456d`**

**Tag de verrouillage : `runtime-s1-04-j04-playable`**

Ce document résume l’état réellement présent sur `main`. Le code, les données et les tests restent l’autorité d’exécution.

Lire d’abord :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

---

# 1. État réel de `main`

## Chaîne Saison 1 jouable

```text
J01 → intégré, jouable et validé
J02 → intégré après J01, jouable et validé
J03 → intégré après J02, jouable et validé
J04 → intégré après J03, jouable et validé
J05–J21 → corpus canonique prêt, non intégré dans la chaîne active
```

L’Acte I J01–J04 est jouable.

La chaîne active repose notamment sur :

```text
game/scripts/runtime/season_1/Season1RuntimeProvider.gd
game/scripts/runtime/season_1/Season1State.gd
game/scripts/runtime/season_1/RuntimeUnread.gd
game/scripts/runtime/season_1/J01RuntimeProvider.gd
game/scripts/runtime/season_1/J02RuntimeProvider.gd
game/scripts/runtime/season_1/J03RuntimeProvider.gd
game/scripts/runtime/season_1/J04RuntimeProvider.gd
game/data/runtime/season_1/j01_runtime_map.json
game/data/runtime/season_1/j02_runtime_map.json
game/data/runtime/season_1/j03_runtime_map.json
game/data/runtime/season_1/j04_runtime_map.json
```

Elle fournit :

- état de saison partagé ;
- providers bornés par journée ;
- handoffs J01→J04 ;
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
- matrices responsive portrait et contrôle historique `1280 × 720`.

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
| J01–J04 | consolidée et signée | intégré, jouable, validé |
| J05–J08 | consolidée, paquet Acte II READY | non intégré |
| J09–J12 | consolidée, paquet Acte III READY | non intégré |
| J13–J16 | consolidée, paquet Acte IV READY | non intégré |
| J17–J21 | consolidée, paquet Acte V READY | non intégré |

La présence d’anciens JSON ou chapitres ne change pas ce tableau.

---

# 4. Frontière d’autorité

```text
vision et routes         → docs/canon/bible/
personnages et voix      → docs/canon/characters/
dialogues J01–J21        → docs/canon/dialogues/
état narratif            → registres + SEASON_1_NARRATIVE_STATE_CONTRACT.md
UX/UI produit            → docs/canon/ui/
runtime actif            → code + données + tests sur main
continuité technique     → SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

Le runtime ne déduit jamais une nouvelle vérité narrative. Le canon n’impose pas une classe Godot ou un format JSON sans décision technique.

---

# 5. Règles obligatoires pour J05+

Toute nouvelle journée doit conserver :

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

Source détaillée :

```text
docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

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

La gate globale compare les échecs historiques par identité exacte ; elle ne fige pas leurs nombres dans le code.

---

# 8. Prochaine étape technique

```text
J05 seul
→ adaptation du canon signé de l’Acte II
→ handoff depuis J04
→ préservation complète de J01–J04
→ validation technique et visuelle
→ verrouillage
```

Branche recommandée :

```text
work/runtime-s1-05-j05-playable
```

Aucun nouveau chantier UI ne s’ouvre sans besoin bloquant démontré.