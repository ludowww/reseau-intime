# Réseau Intime — Index runtime actif

## Statut

**Catégorie : portail technique actif**

**Baseline stable décrite : `c27bd9331c01bed6c9a40c0c642d246cf26bb6cf`**

**Tag : `ui-msg-04c-interactive-notifications`**

Ce document décrit l’état réellement présent sur `main`. Il distingue le canon narratif, la nouvelle chaîne jouable J01→J03 et les matériaux runtime historiques encore conservés dans le dépôt.

Lire d’abord :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

---

# 1. État réel de `main`

## Nouvelle chaîne Saison 1 jouable

```text
J01 → intégré, jouable et validé
J02 → intégré après J01, jouable et validé
J03 → intégré après J02, jouable et validé
J04–J21 → corpus canonique prêt, non intégré dans cette chaîne
```

La chaîne active repose sur :

```text
game/scripts/runtime/season_1/Season1RuntimeProvider.gd
game/scripts/runtime/season_1/Season1State.gd
game/scripts/runtime/season_1/J01RuntimeProvider.gd
game/scripts/runtime/season_1/J02RuntimeProvider.gd
game/scripts/runtime/season_1/J03RuntimeProvider.gd
game/data/runtime/season_1/j01_runtime_map.json
game/data/runtime/season_1/j02_runtime_map.json
game/data/runtime/season_1/j03_runtime_map.json
```

Elle fournit :

- un état de saison partagé ;
- des providers bornés par journée ;
- des transcripts persistants entre les jours ;
- des identifiants de messages produits empêchant les doublons ;
- des fils débloqués cumulatifs ;
- un temps narratif autoritaire et monotone ;
- des transitions de temps et de journée unifiées ;
- des snapshots versionnés et une restauration J01–J03 ;
- une présentation portrait intégrée à Messages et Galerie.

## Couche UI/runtime validée

La baseline inclut également :

- bandeau de conversation compact avec jour et heure courants ;
- livraison progressive de tous les messages ;
- typing isolé par conversation ;
- conservation du scroll et du focus ;
- notifications interactives ouvrant le fil concerné ;
- transitions `CLOCK`, `OFF_PHONE`, `NIGHT`, `NEW_DAY` et fin de contenu ;
- séparateurs historiques normalisés par `source_day` ;
- un seul séparateur par journée et par fil ;
- impossibilité de rendre `SYSTEM_DAY_DIVIDER` comme bulle ;
- vitesse `×1 / ×3 / ×8` limitée aux messages et au typing ;
- transitions exécutées en temps réel ;
- ImageMessage, Galerie et PhotoViewer partagés ;
- matrices responsive portrait et contrôle historique `1280 × 720`.

## Matériaux runtime historiques

Le dépôt conserve des couches V0.xx et d’anciens index couvrant d’autres journées. Ils servent à :

- comprendre l’historique ;
- localiser d’anciens dialogues ou comportements ;
- mesurer une migration ;
- préserver des tests historiques encore utiles.

Ils ne définissent plus :

- la structure narrative J04–J21 ;
- le prochain provider à intégrer ;
- les états de route ;
- les traces et permissions ;
- les comportements UI communs ;
- le contrat de sauvegarde cible.

---

# 2. Frontière d’autorité

```text
vision et routes        → docs/canon/bible/
personnages et voix     → docs/canon/characters/
dialogues J01–J21       → docs/canon/dialogues/
état narratif           → registres + SEASON_1_NARRATIVE_STATE_CONTRACT.md
UX/UI produit           → docs/canon/ui/
runtime réellement actif→ code + données + tests sur main
continuité J01–J21      → SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

Le runtime n’est jamais utilisé pour déduire une nouvelle vérité narrative. Le canon n’impose pas non plus une classe Godot ou un format JSON sans décision technique explicite.

---

# 3. Statut J01–J21

| Journées | Narration | Runtime portrait actuel |
|---|---|---|
| J01–J03 | consolidée et signée | intégré, jouable, validé |
| J04 | consolidée et signée | prochaine intégration recommandée |
| J05–J08 | consolidée et paquet Acte II READY | non intégré |
| J09–J12 | consolidée et paquet Acte III READY | non intégré |
| J13–J16 | consolidée et paquet Acte IV READY | non intégré |
| J17–J21 | consolidée et paquet Acte V READY | non intégré |

La présence d’anciens JSON ou chapitres ne change pas ce tableau.

---

# 4. Règles communes à toutes les prochaines journées

Toute intégration J04+ doit conserver :

- `Season1State` partagé ;
- handoff cumulatif des transcripts, identifiants, fils et contenus Galerie ;
- temps narratif fourni par le provider ;
- timestamp Player capturé à l’acceptation du choix ;
- `source_day` exact sur chaque présentation ;
- livraison Messages commune ;
- notification commune ;
- transition unifiée ;
- snapshot versionné ;
- validation de cohérence à la restauration ;
- absence de scores, owner, candidate pool ou route visible.

Les corrections J01–J03 sont héritées automatiquement seulement si la nouvelle journée utilise les composants et contrats communs. Un provider ne doit pas fabriquer directement des bulles, des séparateurs, une horloge ou un système de notification parallèle.

Source détaillée :

```text
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

---

# 5. Documents historiques

Sont historiques sauf lien explicite depuis un plan actif :

- rapports et plans V0.xx ;
- anciens audits runtime ;
- fichiers numérotés à la racine de `docs/` ;
- `docs/narrative/` ;
- `docs/story_state/` ;
- anciennes checklists de branche ;
- observations runtime du document `12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md` antérieures à la nouvelle chaîne J01–J03.

Leurs diagnostics narratifs peuvent rester utiles lorsqu’ils ne contredisent pas les sources consolidées. Leurs descriptions de l’état technique ne prévalent jamais sur `main` et le présent portail.

---

# 6. Fondations à préserver

- chronologie canonique J01–J21 ;
- fils persistants ;
- transcripts cumulés ;
- choix Player comme messages ;
- notifications inter-fil ;
- non-lus ;
- activités hors téléphone représentées par transitions ;
- temps narratif monotone ;
- snapshots bornés ;
- composants portrait validés ;
- tests statiques et smokes jouables ;
- comparaison de la gate globale par identité exacte.

Une fondation peut évoluer uniquement si un besoin canonique ou une limite technique est démontré et si la non-régression J01–J03 est protégée.

---

# 7. Concepts à ne pas réintroduire

```text
route owner
wave owner
candidate pool générique
external ticket comme sélection de personnage
score d’attachement
score de mensonge
propriétaire automatique d’une relation
horloge UI concurrente
séparateur de journée fabriqué comme message visible
transition accélérée par la vitesse de lecture
```

Le contrat actif utilise des actes observables, des états bornés, des promesses, des obligations, des traces, des connaissances et des conséquences dues.

---

# 8. Validation de base

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
```

Pour toute nouvelle journée, ajouter :

- test statique dédié ;
- smoke jouable dédié ;
- smoke de handoff depuis la journée précédente ;
- snapshot/restore aux phases sensibles ;
- contrôle des doublons, heures, `source_day`, notifications et non-lus ;
- matrices portrait nécessaires ;
- non-régression J01, J02, J03, 03B, 03C et UI-MSG-04A à 04C.

À la baseline `c27bd933…`, la gate globale validée contient 388 tests avec les mêmes 17 `FAIL`, 2 `ERROR` et 19 identités historiques que la baseline de comparaison. Les smokes 04C/04C1 sont exempts de warnings `ObjectDB`, `leaked` et `orphan`.

---

# 9. Prochaine étape technique

```text
J04 seul
→ adaptation du canon signé dans un provider borné
→ handoff depuis J03
→ non-régression complète J01–J03
→ validation visuelle
→ verrouillage
```

J04 ne doit pas réactiver automatiquement les anciens index modulaires et ne doit pas ouvrir un nouveau chantier UI sans besoin bloquant démontré.
