# R8C-A4 — Consolidation canonique et nettoyage legacy

> **Catégorie :** rapport de maintenance canonique
> **Statut :** `VALIDE`
> **Baseline auditée :** `main` / `origin/main` au SHA `4dda96f437d1e44658b7fc0748dca421ab98c0cc`
> **Branche :** `work/r8c-a4-canonical-consolidation-legacy-cleanup`

## 1. Décision

Il n'existe aucune donnée de production ni sauvegarde utilisateur à préserver.
Git et les tags sont l'archive. R8C-A4 maintient une seule direction canonique,
supprime les prototypes concurrents non démarrés et ne crée ni double écriture,
ni migration de confort, ni suite legacy rouge.

## 2. Cartographie et classement

| Classe | Éléments | Motif vérifié |
| --- | --- | --- |
| `CANON_CONSERVE` | `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md`, `docs/architecture/R8A_*`, `R8B_*`, `R8C_A1_*`, `R8C_A2_*`, `R8C_A3_*` | Autorité R8A–R8C et contrats verrouillés. |
| `CANON_CONSERVE` | `game/scripts/narrative_state/`, `game/scripts/narrative_scene/`, tests A1/A3 | Fondation et prototype synthétique sans scores. |
| `CANON_CONSERVE` | `game/tests/fixtures/r8c_a3_minimal_scene_definitions.json` | Marquée `FIXTURE_NON_CANONIQUE`; seules références depuis les deux tests A3; aucun loader ne parcourt `game/tests/fixtures`. |
| `ENCORE_UTILISE_TEMPORAIREMENT` | `PortraitMain → PortraitShell → Season1RuntimeProvider`, `Season1State`, providers et runtime maps J01–J21, conversations référencées | Chaîne réellement démarrée; oracle fonctionnel temporaire, pas modèle futur. |
| `ENCORE_UTILISE_TEMPORAIREMENT` | `TimelineState.mark_day_complete`, `DataLoader.load_json`, catalogue de médias | Appels directs du runtime portrait courant; les autres API historiques ont été supprimées. |
| `ENCORE_UTILISE_TEMPORAIREMENT` | snapshots mémoire Season1 v21 / state v25 et leurs restaurations | Aucun fichier de sauvegarde n'existe. Seules les versions courantes sont acceptées; tout ancien snapshot est refusé sans migration. |
| `A_REECRIRE` | `tools/simulate_route_paths.py` | Ancien calcul de routes par scores; remplacé par un lint de frontière et un lanceur du smoke Godot A3 canonique. |
| `A_REECRIRE` | deux outils emoji | Logique utile, sortie non portable sous console Windows CP1252. |
| `SUPPRIME` | `docs/14_*` à `docs/26_*` ciblés, décision passive-signals et plans journaliers associés | Information utile déjà absorbée par R8A–R8C; accumulation, seuils, jours rigides ou topologies explicitement abandonnés. |
| `SUPPRIME` | `Main.tscn`, `LegacyMain`, chaîne smartphone `PhonePrototype` V081–V096A, anciens sélecteurs et smokes dédiés | Aucun lien depuis la scène de démarrage; seconde chaîne runtime concurrente. |
| `SUPPRIME` | `GameState`, `EffectApplier`, `DebugRouteProbe`, `initial_state.json` | Autoloads de l'ancien téléphone; scores et signaux accumulatifs absents de `Season1RuntimeProvider`. |
| `SUPPRIME` | index J01–J09 et conversations absentes des 21 `conversation_paths` | Non chargés par l'oracle portrait; Git conserve l'historique. |

## 3. Références directes et indirectes vérifiées

- Entrée Godot : `game/project.godot` charge `PortraitMain.tscn`, qui monte
  `PortraitShell` en mode `runtime_s1`.
- `PortraitShell.gd` précharge `Season1RuntimeProvider.gd`; ce dernier précharge
  `Season1State` et les providers J01–J21.
- Chaque provider charge ses JSON par les tables `conversation_paths` des
  runtime maps. Les suppressions de données sont calculées contre l'union exacte
  de ces chemins, puis revérifiées par recherche statique et validation JSON.
- Aucun `DirAccess` ou scan automatique de `res://` n'existe côté runtime.
- `DataLoader` reste requis pour `load_json` et `get_visual_content`; ses index,
  son état initial et ses helpers de navigation appartenaient à l'ancien téléphone.
- `TimelineState.mark_day_complete` reste appelé par les providers actifs.
- Les restaurations Season1, J13, J14 et J15 n'acceptent plus les payloads
  historiques; les migrations R5A–R7A et les rollbacks de compatibilité ont été
  retirés.
- Aucun `SaveManager`, `user://`, `save_game`, `store_var` ou fichier de
  sauvegarde de jeu n'est présent.

## 4. Documentation des tests historiques

La baseline contenait 570 tests : 28 échecs et 4 erreurs. Aucun rouge n'était
nouveau par rapport au rapport R1.

### Audit individuel des 32 rouges de la baseline

| Test en échec/erreur | Décision | Raison produit/architecture |
| --- | --- | --- |
| `OpeningJ3J4…ordinary_household` | `SUPPRIME` | Ancien contenu J3/J4 absent des runtime maps canoniques. |
| `RuntimeDayIntegrity…day5_day6_ids` | `SUPPRIME` | Validait les anciens index et `moment_flow` automatiques. |
| `J03…snapshot_v2` | `REECRIT` | Invariants J03 gardés; coexistence remplacée par rejet current-only. |
| `J04…season_handoff_snapshot` | `REECRIT` | Handoff gardé; anciennes versions supprimées. |
| `J04…exact_j04_records` | `REECRIT` | Mappings exacts Pauline conservés; compatibilité retirée. |
| `J05…j04_hands_off` | `REECRIT` | Handoff courant conservé; ancienne matrice de versions retirée. |
| `J05…bounded_j05_outcomes` | `REECRIT` | Refus, éligibilité Sandra et interdits de route conservés. |
| `J06…j05_hands_off` | `REECRIT` | Handoff courant conservé; ancienne version retirée. |
| `J07…handoff_and_snapshot_versions` | `REECRIT` | Handoff courant conservé; restauration legacy supprimée. |
| `J07…bounded_idempotent_records` | `REECRIT` | Registres bornés et interdits conservés; version actualisée. |
| `J08…bounded_outcomes` | `REECRIT` | Non-progression relationnelle conservée; version actualisée. |
| `UI-MSG-04B2…automatic_flows` | `CORRIGE` | J07 effectue désormais un handoff J08, pas `CONTENT_END`. |
| `UI-MSG-04C…scope_excludes` | `CORRIGE` | Suppression d'une comparaison à un SHA historique de ticket. |
| `V081…active_scenes_use_v089` | `SUPPRIME` | Vérifiait la chaîne d'héritage smartphone abandonnée. |
| `V082…preserve_v082_foundation` | `SUPPRIME` | Adaptateur runtime non démarré. |
| `V082…exact_moments` | `SUPPRIME` | Topologie rigide de jeudi abandonnée. |
| `V082…authorized_visual` | `SUPPRIME` | Contenu de l'ancien index, non chargé par l'oracle courant. |
| `V084…ordered_timeline_phases` | `SUPPRIME` | Phases automatiques d'index supprimées avec l'ancien loader. |
| `V084…optional_phase_expires` | `SUPPRIME` | Expiration issue de l'ancienne topologie. |
| `V084…TimelineState_registered` | `SUPPRIME` | Ancien moteur de journée; seul le marquage utile subsiste. |
| `V085…authored_beat_state` | `SUPPRIME` | État du téléphone historique non démarré. |
| `V086…friday_index` | `SUPPRIME` | Index et chaîne d'unlock rigides abandonnés. |
| `V086…Pauline_three_p0` | `SUPPRIME` | Quota de choix/contenu de l'ancien opening. |
| `V086…public_visual` | `SUPPRIME` | Visuel gouverné par l'ancien index supprimé. |
| `V086A…active_scenes_use_v089` | `SUPPRIME` | Adaptateurs temporels du téléphone abandonné. |
| `V089…records_ticket` | `SUPPRIME` | Sélecteur de répétition et tickets retirés. |
| `V090…v092_closure_adapter` | `SUPPRIME` | Chaîne d'adaptateurs successive supprimée. |
| `V092…preserves_v090_inheritance` | `SUPPRIME` | Héritage du runtime concurrent supprimé. |
| `emoji context_pack` | `CORRIGE` | Sortie UTF-8 explicite sous Windows; comportement conservé. |
| `emoji voice_check` | `CORRIGE` | Même correction UTF-8; contrôle vocal conservé. |
| `V082…unlock_graph` (`KeyError`) | `SUPPRIME` | Référençait `chapter_03_marie_event_offer`, contenu abandonné. |
| `V086…Nico opening` (`StopIteration`) | `SUPPRIME` | Cherchait une variante de l'ancien opening supprimé. |

### Tests supprimés avec leur sous-système

- `test_godot_prototype_static`, `test_j03_j04_opening_reconciliation` et
  `test_runtime_day_integrity_audit` vérifiaient le loader/index et les contenus
  du téléphone historique supprimé. `test_j1_sandra_selected_image` dépendait
  du même index J1 supprimé; ses assertions de contenu restantes sont déjà
  couvertes par les tests runtime J01 et les contrats visuels.
- `test_v081_*`, `test_v082_*`, `test_v084_*`, `test_v085_*`, `test_v086*`,
  `test_v089_*`, `test_v090_*`, `test_v092_*`, `test_v095_*`, `test_v096*`
  épinglaient des adaptateurs successifs d'une scène qui n'est plus démarrée.
  Cela couvre explicitement le `KeyError chapter_03_marie_event_offer` et le
  `StopIteration` de l'ancienne ouverture Nico.

### Tests réécrits ou corrigés

- Dix-neuf méthodes de tests J03–J15 qui validaient la coexistence de snapshots
  successifs ont été réécrites : elles conservent les invariants narratifs et de
  handoff utiles, exigent la version courante et vérifient l'absence de migration.
- Le test UI-MSG-04B2 attend le handoff J07→J08 courant, pas un ancien
  `CONTENT_END`.
- Le test UI-MSG-04C ne compare plus le dépôt à un SHA historique propre à son
  ancien ticket.
- Les deux `CalledProcessError` emoji sont corrigés à la source par une sortie
  UTF-8 portable, avec les tests fonctionnels conservés.

Un test dédié couvre le marqueur non canonique, l'absence d'accumulateurs et la
frontière de la fixture. Les sémantiques de résolution restent exclusivement
couvertes par le moteur GDScript canonique et son smoke de 50 contrôles.

Au total, 18 fichiers de tests attachés aux sous-systèmes supprimés ont été
retirés. La suite passe de 570 cas historiques à 371 cas canoniques; la baisse
nette de 199 cas correspond aux adaptateurs, topologies et contenus abandonnés, pas à
des tests masqués ou ignorés.

## 5. Sauvegardes de développement

Il n'existe pas de sauvegarde persistée. Les snapshots `Dictionary` de l'oracle
Season1 sont des objets mémoire utilisés par le runtime et ses smokes. R8C-A4
conserve les schémas courants Season1 v21 et state v25, mais refuse désormais
immédiatement toute autre version. Les migrations et adaptateurs historiques
ont été supprimés. Une future sauvegarde de développement devra donc repartir
du schéma courant ou être réinitialisée; aucune coexistence n'est entretenue.

## 6. Validations

- [x] tests statiques R8C-A1/A3 : 21/21;
- [x] smokes Godot R8C-A1/A3 : `OK`, dont 50 contrôles A3;
- [x] validation JSON : 88 fichiers, zéro erreur, zéro avertissement;
- [x] simulation canonique : smoke Godot A3 de 50 contrôles lancé par l'outil;
- [x] smokes de politique de snapshots J13/J14/J15 : formats courants restaurés,
  versions obsolètes et corruptions refusées;
- [x] Godot 4.6.2 headless standard : zéro erreur;
- [x] Godot 4.6.2 headless 1280×720 : zéro erreur;
- [x] recherche anti-scores/signaux accumulatifs : aucun usage dans le runtime
  ou les données; les seules mentions restantes hors canon sont des garde-fous
  de validation ou des constats historiques explicites;
- [x] gate globale : 371/371 tests;
- [x] 48/48 scènes smoke Godot encore présentes, avec leurs arguments
  contractuels;
- [x] `git diff --check` : vert.

### 6.1 Revue produit et UX finale

Le point d'entrée réel reste `game/project.godot` vers
`PortraitMain.tscn`, avec `PortraitShell.content_mode = "runtime_s1"`. Le smoke
final A4 instancie cette scène de production, jamais une coque de test parallèle.

| Journée | Preuve `PortraitMain` | Résultat |
| --- | --- | --- |
| J01 | Messages au démarrage, fils Marie/Sandra, choix, notifications, transitions, retour conversation, image-message et PhotoViewer placeholder | `OK` |
| J09 | handoff J08→J09, choix de présence/qualité, transitions, Galerie et fin de journée; snapshots courants restaurés | `OK` |
| J12 | Messages, notification/non-lu Sandra, fil et choix P11, transition, retour liste, Galerie cumulative, PhotoViewer placeholder et précédent/suivant | `OK` |
| J15 | Messages, notification/non-lu Marie, choix de mutation, transition, retour liste, Galerie cumulative, PhotoViewer placeholder et précédent/suivant | `OK` |
| J21 | Messages, notification/non-lu Marie, choix final du matin, transition, retour liste, Galerie cumulative, PhotoViewer placeholder et précédent/suivant | `OK` |

L'UX canonique conservée est donc explicitement : **Messages + Galerie +
PhotoViewer + transitions temporelles + notifications/non-lus**. Le smoke final
vérifie aussi l'absence de crop à 720×1280 et ne produit aucune erreur Godot.

Les éléments supprimés ne sont pas réintroduits : Contacts, Historique,
sélection manuelle des jours, Debug/Reset/vitesse, ancienne galerie verrouillée
et ancienne chaîne smartphone parallèle.

### 6.2 Décision J09

Le rouge J09 a été reproduit : ses neuf assertions en échec exigeaient
exclusivement la restauration de snapshots Season1 v7/v8 et state v6/v7. Le
parcours canonique J08→J09, les choix, données, Galerie et surfaces
`PortraitMain` n'étaient pas en régression.

Le smoke a été réécrit pour le contrat actuel : restauration exacte des
snapshots Season1 v21 / state v25 à J08 puis J09, handoff J08→J09 conservé, et
rejet explicite des quatre versions obsolètes. Aucune migration ou couche de
compatibilité legacy n'a été ajoutée.

La même revue exhaustive a trouvé deux attentes legacy identiques hors de la
gate Python : J08 exigeait Season1 v6 / state v5, et J10 exigeait state v7.
Elles ont été remplacées par restauration current-only et rejet explicite des
versions obsolètes. Le smoke J16 utilisait quant à lui des libellés de fixture
J14 antérieurs au contrat J15 courant; sa fixture démarre désormais directement
depuis un état J15 courant et borné. Ces trois corrections ne modifient aucun
provider ni donnée de jeu.

Commande de preuve UX finale :

```bash
bash tools/test_r8c_a4_final_portrait_ux.sh
bash tools/test_all_canonical_godot_smokes.sh
```

## 7. Empreinte du lot

- 217 fichiers touchés avant commit : 170 supprimés, 43 modifiés, 4 ajoutés;
- verrouillage final : 11 fichiers ajustés (7 existants, 4 nouveaux), soit 225
  fichiers uniques touchés depuis la baseline;
- lot initial : 38 688 lignes historiques retirées pour 837 lignes ajoutées;
- cumul final depuis la baseline : 38 751 suppressions et 1 288 ajouts;
- ajouts : index canonique `docs/architecture/README.md`, présent rapport et
  tests de lint de fixture et de frontière des chemins de données;
- modifications : portails documentaires, autoloads, loaders minimaux,
  politique de snapshots, lanceur A3/validateur et tests canoniques;
- suppressions : 21 documents/plans/décisions contradictoires, 72 conversations
  non référencées, ancien état initial, seconde chaîne runtime smartphone,
  sélecteurs et smokes/tests associés.
