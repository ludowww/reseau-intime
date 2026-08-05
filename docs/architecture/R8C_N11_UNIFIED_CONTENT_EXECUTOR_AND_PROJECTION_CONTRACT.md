# R8C-N11 — Contrat de contenu unifié, exécuteur de séquences et projections player-facing

> **Baseline obligatoire vérifiée :** `6bc026e0ac5a5ad37f2e73c8cc9fa86736d4dbdc`
>
> **Tag stable vérifié :** `r8c-n10-legacy-freeze-new-runtime-cutover-contract`
>
> **Branche de livraison :** `work/r8c-n11-unified-content-executor-projection-contract`
>
> **Nature :** contrat documentaire et architectural ; aucune implémentation
>
> **Statut Codex :** `UNIFIED_CONTENT_EXECUTOR_PROJECTION_CONTRACT_READY_FOR_PRODUCT_REVIEW`
>
> **Statut produit cible, non attribué par N11 :** `UNIFIED_CONTENT_EXECUTOR_PROJECTION_CONTRACT_APPROVED`
>
> **Tranche de référence :** Mathilde M-B3, `FIRST_TARGET_VERTICAL_SLICE_SELECTED`

## 1. Décision et portée

N11 ferme le contrat cible entre une séquence authored, A6–A10, un futur
exécuteur mince, A1–A5 et les surfaces joueur existantes. Il ne crée ni runtime,
ni donnée, ni dialogue, ni test, ni scène, ni asset, ni média, ni composant UI.
Le runtime J01–J21 reste intégralement :

`LEGACY_REFERENCE_ONLY`

La chaîne normative est :

```text
Définition authored immuable
  → projection A6
  → sélection et orchestration A7–A10
  → exécuteur de séquence
  → checkpoints authored
  → résolution A10
  → événements et reducers A1–A5
  → état narratif durable
  → projections player-facing
```

Le contrat technique est fermé. Les trois arbitrages produit de gouvernance
documentaire sont intégrés comme suit :

| Chemin | Classement N11 | Autorité conservée | Éléments supersédés et suite |
|---|---|---|---|
| `docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md` | `À réécrire` | Matière éditoriale canonique, voix, choix existants, limites, conséquences et entrées/sorties utiles à Mathilde M-B3. | J11 comme identité de séquence, la journée comme unité de composition, la continuation exclusive par pivot journalier, le format messagerie-only comme cible et le centre antérieur à `AuthoredSequenceV1` et aux contrats W4/N11 sont supersédés. La matière Mathilde utile sera recomposée dans `mathilde_returns_with_chosen_intent_01`, sans dépendance sémantique à `J11`. |
| `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md` | `Archive` | Provenance historique, anciennes justifications de production et mémoire des identifiants et comptages antérieurs. | L'Acte III défini par J09–J12, les jours comme structure de production, les quatorze beats servis, le manifeste de trente fichiers et la classification de dette média antérieure à N6/N9/N10 sont supersédés. N6 gouverne l'inventaire, N9 les payoffs, aftercares et médias W4, N10 le cutover et N11 le format et les projections cibles. |
| `docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md` | `À réécrire` | Absence de scores relationnels, faits observables, états qualitatifs bornés, séparation entre faits, traces, connaissances, promesses, obligations et conséquences, et principe qu'un état résumé ne remplace jamais l'historique. | L'exécution J01–J21, `current_day` comme axe métier durable, les champs saisonniers monolithiques, `RECONFIGURATION_NEGOTIATING`, le contrat de finale calendaire et le stockage cible implicite antérieur à A1–A10 sont supersédés. A1–A5 gouvernent l'état durable, A6–A10 l'orchestration, N10 le gel du legacy et N11 l'état authored, l'exécution et les projections. |

Le classement `À réécrire` retire au document son rôle de contrat cible sans
invalider la matière éditoriale explicitement conservée comme canonique. Le
classement `Archive` maintient le document comme source de provenance sans lui
conférer d'autorité normative sur la cible.

Ces décisions ferment les trois conflits de gouvernance sans ouvrir d'autre
décision d'architecture. Le contrat est prêt pour revue produit ; seul le produit
peut encore lui attribuer le statut `APPROVED`.

## 2. Autorités et inventaire réel

### 2.1 Autorités appliquées

- N7.1 impose la hiérarchie Saison → mouvement → séquence authored → beat →
  contenu → média → projection temporelle, et interdit de faire du jour une
  identité (`docs/narrative/R8C_N7_1_SEASON_STRUCTURE_RUNTIME_PROJECTION_AND_N8_ENTRY_CONTRACT.md:38-67`).
- N9 ferme le payoff, le retrait, la sortie, l'aftercare, les faits, audiences et
  continuités Mathilde (`docs/narrative/R8C_N9_W4_PAYOFF_AFTERCARE_AND_J21_CONTINUITY_CONTRACT.md:204-283`).
- N10 gèle le legacy, interdit toute double écriture et fixe A1–A10 comme domaine
  cible (`docs/architecture/R8C_N10_LEGACY_FREEZE_AND_NEW_RUNTIME_CUTOVER_CONTRACT.md:17-48,288-349`).
- A1–A10 restent verrouillés. N11 n'ajoute aucune opération publique et ne
  change aucun schéma existant.

### 2.2 A1–A10 inspectés

| Couche | Chemins réels | Contrat public ou invariant observé |
|---|---|---|
| A1 | `game/scripts/narrative_state/EtatNarratif.gd`, `EtatRelation.gd`, `EtatRelationCentrale.gd`, `ReducerRelation.gd` | `traiter_evenement` est atomique et idempotent par `event_id`; mêmes données → `IDEMPOTENT`, contenu différent → rejet (`EtatNarratif.gd:60-80`). Les racines événements, promesses, obligations, traces, connaissances et livraison média existent (`:27-43`). |
| A2 | `docs/architecture/R8C_A2_CONTRAT_SCENE_MODULAIRE_ET_MOTEUR_NARRATIF.md` | Sépare définition et instance (`:32-44`), exige proposition perceptible avant `MANQUEE` (`:179-192`) et réserve les écritures durables à A1 (`:208-237`). |
| A3 | `game/scripts/narrative_scene/SceneDefinition.gd`, `SceneInstance.gd`, `MinimalSceneEngine.gd` | Définition fermée (`SceneDefinition.gd:12-64,111-186`), instance `INELIGIBLE|ELIGIBLE|PROPOSED|RESOLVED|MISSED|CANCELLED`, résolution transactionnelle et identifiant formé par `r8c-a3:` + `instance_id` + `:resolution:` + `resolution_id` (`MinimalSceneEngine.gd:196-293,655-729,873-874`). |
| A4 | `docs/maintenance/R8C_A4_CONSOLIDATION_CANONIQUE_ET_NETTOYAGE_LEGACY.md` | Aucun composant de domaine A4 distinct ; le smoke préfixé A4 est une preuve de présentation, pas un domaine (`docs/architecture/R8C_N10_LEGACY_FREEZE_AND_NEW_RUNTIME_CUTOVER_CONTRACT.md:205-209`). |
| A5 | `game/scripts/narrative_scene/PersistentSceneRegistry.gd`, `A5NarrativeStateCodec.gd`, `MinimalSceneEngine.gd` | Snapshot v1 exact `{version,narrative_state,scene_registry}` (`MinimalSceneEngine.gd:124-151,915-924`). Le codec impose encore vides cinq registres réels (`A5NarrativeStateCodec.gd:10-21,61-76`). |
| A6 | `game/scripts/narrative_scene/NarrativeSceneLibrary.gd`, `game/data/narrative_scenes/r8c_a6_prototype_library.json` | Bundle fermé `R8C_A6_SCENE_LIBRARY` v1, au plus 32 entrées, chacune `{scene_definition_id,variant_id,definition}` ; `scene_definition_id == definition.scene_id` (`NarrativeSceneLibrary.gd:8-20,69-99`). Aucun transcript, beat ou média. |
| A7 | `game/scripts/narrative_scene/CandidateReservationProposalCoordinator.gd` | Intentions `RESERVE|PROPOSE`; revalidation avant matérialisation. Seul `PROPOSE` rend l'instance perceptible et admissible à `MISSED` (`docs/architecture/R8C_A7_RESERVATION_ET_PROPOSITION_CANDIDATS.md:35-57`). |
| A8 | `game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd` | Politiques `CLOSE_SILENTLY`, `MARK_MISSED_IF_PROPOSED`, `DEFER`; fenêtres éphémères, aucun snapshot A8 (`docs/architecture/R8C_A8_FENETRES_OPPORTUNITE_ET_CONFLITS_EXCLUSIFS.md:25-43,93-99`). |
| A9 | `game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd` | Plan éphémère `earliest-fit`, ordre auteur, aucune sélection ni persistance (`docs/architecture/R8C_A9_COMPOSITION_CONTROLEE_CRENEAU_NARRATIF.md:49-87,113-132`). |
| A10 | `game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd` | Sept opérations publiques exactement : `create`, `find_candidates`, `compose_slot`, `activate_option`, `resolve_scene`, `save_state`, `restore_state` (`docs/architecture/R8C_A10_VERTICAL_SLICE_ORCHESTRATION_ET_SIMPLIFICATION_API.md:44-56`; code `:24-213`). |

### 2.3 Présentation, chargement, médias et sauvegarde inspectés

| Surface | Chemins réels | Fait observé utile au contrat cible |
|---|---|---|
| Bootstrap actuel | `game/project.godot:9`, `game/scenes/portrait/PortraitMain.tscn:18`, `game/scripts/ui/PortraitShell.gd:7-22,222-228` | Le démarrage construit directement `Season1RuntimeProvider`; cette dépendance est legacy. |
| Messages | `game/scripts/ui/messages/MessagesScreen.gd`, `PortraitConversationScreen.gd`, `MessageTimeline.gd` | `MessagesScreen.configure_content_source` existe (`:97-100`). La source expose personnages, fils, messages et choix ; la réconciliation exige des IDs uniques et un suffixe ordonné (`:602-667`). |
| Choix | `game/scripts/ui/messages/ChoiceBar.gd`, `MessagesScreen.gd` | La vue accepte 1 à 4 choix (`ChoiceBar.gd:15-20`); le provider actuel reçoit seulement `(thread_id, choice_id)` (`MessagesScreen.gd:710-740`). |
| Notifications/non-lus | `MessagesScreen.gd`, `game/scripts/runtime/season_1/RuntimeUnread.gd`, `NotificationBanner.gd` | Notification active/en attente actuellement UI-only (`MessagesScreen.gd:45-52`); accusés de présentation et lecture sont distincts (`:844-913,1730-1747`). |
| Temps/transitions | `TimePassageOverlay.gd`, `OffPhoneTransition.gd`, `DayTransition.gd`, `NarrativeTime.gd` | Les vues savent présenter `CLOCK|OFF_PHONE|NIGHT|NEW_DAY`; `NarrativeTime` ne fait que parser/formater `HH:MM`. |
| Beat physique | `J11RuntimeProvider.gd:116-128,585-648`, `MessagesScreen.gd:1110-1161`, `PortraitShell.gd:340-348` | Le legacy le présente comme séquence PhotoViewer de trois éléments, pas comme scène Godot métier distincte. |
| Galerie | `game/scripts/ui/gallery/GalleryScreen.gd`, `GalleryTile.gd`, `CharacterTabs.gd` | Source injectable ; parent détecté par `sequence_child_ids`, enfants validés par `children_by_id` (`GalleryScreen.gd:30-55,390-449`). `is_new` est encore local. |
| PhotoViewer | `game/scripts/ui/gallery/PhotoViewer.gd` | Consomme une projection `UNLOCKED` et les sources `messages|gallery|scene`; il ne crée aucun droit d'accès (`:36-87`). |
| Média | `game/scripts/ui/media/VisualMediaResolver.gd`, `game/scripts/core/DataLoader.gd` | Le resolver distingue asset chargé, référence manquante, placeholder de développement et non-livré (`VisualMediaResolver.gd:5-36`). Le catalogue technique ne prouve aucune audience. |
| Conversations legacy | `game/data/conversations/*.json`, `game/scripts/runtime/season_1/J01RuntimeProvider.gd` à `J21RuntimeProvider.gd` | Chaque provider charge ses conversations/maps et fabrique son propre transcript. J11 indexe les segments à `J11RuntimeProvider.gd:51-68`. |
| Sauvegarde legacy | `Season1RuntimeProvider.gd:496-639`, `Season1State.gd:3136-3260`, snapshots des providers | Dictionnaires mémoire couplés à `Season1State` et aux 21 providers ; aucun stockage disque général (`docs/runtime/README.md:34`). Référence interdite pour la cible. |

## 3. Trois catégories d'état, jamais quatre domaines

| Catégorie | Contenu | Autorité | Interdiction |
|---|---|---|---|
| État authored | Définition immuable, version, beats, branches, résolutions attendues, médias et contraintes de projection. | Catalogue authored validé. | Aucun curseur, aucun statut de lecture, aucune mutation de partie. |
| État d'exécution | Instance active, curseur, checkpoints, choix consommés, projections ouvertes/accusées, attente joueur et retours planifiés. Le ledger de présentation est un sous-ensemble opérationnel de cet état, pas un domaine métier. | Exécuteur et snapshot cible. | Aucun fait relationnel interprété, aucun score, aucune copie des registres A1–A5. |
| État narratif durable | Événements, relations, connaissances, traces, promesses, obligations, conséquences, statut de scène et accès média. | A1–A5, résolu via A10. | Aucune mutation directe par l'exécuteur, la Galerie, PhotoViewer ou une scène Godot. |

Les plans A9, fenêtres A8, preuves A6 et quittances d'activation A10 restent
éphémères conformément à leurs contrats. Ils ne constituent pas un quatrième
domaine et ne sont pas recopiés dans la sauvegarde.

## 4. Contrat authored unifié v1

### 4.1 Conventions fermées

- `schema_id` vaut exactement `reseau_intime.authored_sequence`.
- `schema_version` vaut `1` pour N12.
- Tout objet refuse les champs inconnus ; tout tableau refuse les doublons.
- Tout identifiant créé par la cible respecte `^[a-z0-9_]{1,96}$`.
- Aucun nouvel identifiant de séquence, beat, choix, résolution, checkpoint,
  notification, thread, fait, trace, obligation ou conséquence ne contient un
  préfixe ou segment métier `jNN`/`chapter_NN`.
- Les IDs média historiques verrouillés par N9/N10, bien qu'ils contiennent
  `J11`, restent des références authored opaques : ils ne sont jamais parsés
  comme dates et N11 n'en crée aucun nouveau.
- `authored_version` suit `MAJOR.MINOR.PATCH`; une sauvegarde épingle la version
  exacte et aucune migration silencieuse n'est permise.
- Le package runtime n'accepte que `canonical_status = CANON_APPROVED`. Un
  brouillon de contenu ne devient pas exécutable sans approbation humaine. Un
  média peut, séparément, rester `SPECIFIED_NOT_PRODUCED` et suivre le
  comportement de développement de la section 11.

### 4.2 Racine exacte `AuthoredSequenceV1`

| Champ requis | Type fermé | Sens |
|---|---|---|
| `schema_id` | littéral `reseau_intime.authored_sequence` | Identité du format. |
| `schema_version` | entier `1` | Version du schéma, distincte du contenu. |
| `sequence_id` | identifiant stable | Identité métier canonique, indépendante d'un jour. |
| `authored_version` | version sémantique | Version épinglée par instance et sauvegarde. |
| `season_id` | identifiant stable | `season_1` pour la première tranche. |
| `dramatic_movement_id` | `movement_i|movement_ii|movement_iii|movement_iv|movement_v` | Mouvement N7.1. |
| `narrative_function` | `RELATION|OPPORTUNITY|ECHO|RESPIRATION` | Fonction alignée sur A3 ; la projection traduit `OPPORTUNITY` vers `OPPORTUNITE`. |
| `canonical_status` | littéral `CANON_APPROVED` | Gate d'entrée runtime. |
| `author_provenance` | `AuthorProvenance` | Sources et décision humaine. |
| `participants` | `Participants` | Présences, absences concernées, audiences et rôle Player. |
| `orchestration` | `OrchestrationContract` | Projection exacte vers A6 et contraintes A8/A9, sans moteur parallèle. |
| `temporal_projection` | `TemporalProjection` | Ancrage, délai et ordre relatifs non identitaires. |
| `entry_beat_id` | identifiant de beat | Premier beat. |
| `beats` | tableau non vide de `Beat` | Déroulé exécutable fermé. |
| `resolutions` | dictionnaire `resolution_id → Resolution` | Issues terminales et effets authored attendus. |
| `media` | dictionnaire `media_id → MediaDefinition` | Médias référencés par les beats/résolutions. |

`AuthorProvenance` possède exactement :

| Champ | Type |
|---|---|
| `source_document_paths` | tableau non vide de chemins dépôt |
| `source_sequence_ids` | tableau non vide d'identifiants source ou aliases historiques |
| `approval_ref` | chaîne non vide désignant la décision humaine |
| `authoring_tool_ref` | chaîne ou `null`; provenance seulement, jamais autorité runtime |

`Participants` possède exactement :

| Champ | Type et règle |
|---|---|
| `present_character_ids` | tableau non vide d'identifiants uniques |
| `concerned_absent_character_ids` | tableau d'identifiants uniques, disjoint du précédent |
| `initial_audiences` | dictionnaire `audience_id → character_id[]`, sans membre inconnu |
| `player_role` | `PARTICIPANT|OBSERVER|ABSENT` |

### 4.3 Frontière authored / A6

`OrchestrationContract` possède exactement :

| Champ | Contenu |
|---|---|
| `a6_entry` | Entrée A6 exacte `{scene_definition_id,variant_id,definition}` ; `definition` respecte sans extension `SceneDefinition.gd:12-64` et `scene_definition_id == definition.scene_id`. |
| `a8_window` | `{window_id,conflict_policy}` avec politique `CLOSE_SILENTLY|MARK_MISSED_IF_PROPOSED|DEFER`. Les bornes concrètes sont matérialisées depuis `temporal_projection` au moment de composer. |
| `a9_slot` | `{slot_role,duration_minutes,relative_order,not_before_anchor,not_after_anchor}` ; `relative_order` est un entier auteur non négatif, jamais un score ou une préférence calculée. |

Règles de frontière :

1. A6 reçoit uniquement `a6_entry`; les beats, textes, médias et checkpoints ne
   traversent pas son schéma fermé.
2. Les préconditions qualitatives, participants requis, événements requis,
   incompatibilités, politique `UNIQUE|REPETABLE`, choix/résolutions A3 et
   politique de non-résolution sont écrits une seule fois dans
   `a6_entry.definition`.
3. `a8_window` et `a9_slot` ne sélectionnent rien. Ils fournissent les seules
   contraintes authored nécessaires pour construire les requêtes A10 ; A8 et A9
   conservent validation, conflits, `earliest-fit` et revalidation.
4. Une condition locale de beat ne peut jamais recopier une précondition A6.
5. Le catalogue unifié indexe aussi la définition complète par le couple
   `(scene_definition_id, variant_id)`. Après activation, ce couple permet à
   l'exécuteur de retrouver `sequence_id` et `authored_version` sans demander à
   A10 d'exposer une définition.

`a6_entry.definition.choix` reste limité à trois entrées par A3. Pour une
séquence possédant plusieurs points UI, ces trois entrées représentent les trois
branches racines A3. Les choix ultérieurs restent des choix authored de séquence;
la résolution terminale indique à la fois `choice_id` décisif et
`a10_choice_id` racine. Cette distinction respecte le contrat A3 sans réduire le
parcours player-facing à trois choix au total.

### 4.4 Projection temporelle

`TemporalProjection` possède exactement :

| Champ | Type et règle |
|---|---|
| `anchor_id` | identifiant diégétique stable, par exemple un événement ou une fenêtre de mouvement, jamais `J11` comme identité |
| `offset_minutes` | entier signé |
| `relative_order` | entier non négatif, ordre authored entre séquences partageant l'ancrage |
| `delay` | `{mode:NONE|DIEGETIC_MINUTES|AFTER_EVENT,value:int|event_id}` |
| `resolved_window` | `{opens_at,closes_at}` en instants diégétiques normalisés ; projection calculée, non identitaire |

Le validateur impose que `resolved_window` corresponde au `contrat_temporel` de
la projection A3. Il valide une égalité de transport ; il ne crée pas un second
moteur d'éligibilité.

## 5. Beats, branches et conditions locales

### 5.1 Types v1, liste exhaustive

`MESSAGE`, `CHOICE`, `TRANSITION`, `PHYSICAL_BEAT`, `MEDIA_REVEAL`, `AFTERCARE`,
`RETURN` sont les seuls types autorisés pour la première tranche. Un nouveau cas
narratif compose ces types ; il ne crée pas un type supplémentaire.

### 5.2 Enveloppe commune exacte

Chaque `Beat` possède exactement :

| Champ | Type et règle |
|---|---|
| `beat_id` | identifiant stable, unique dans la séquence |
| `type` | un des sept littéraux v1 |
| `content` | payload fermé selon le type ci-dessous |
| `participant_ids` | sous-ensemble des participants déclarés |
| `local_conditions` | tableau de `LocalCondition`, éventuellement vide |
| `projection_target` | `MESSAGES|PHYSICAL|MEDIA|GALLERY|PHOTO_VIEWER|NONE` |
| `checkpoint_before` | checkpoint ou `null` |
| `checkpoint_after` | checkpoint ou `null` |
| `next` | `NextBeat` fermé |

`LocalCondition` possède exactement `{kind,ref_id,expected}`. `kind` est limité à
`CHOICE_CONSUMED`, `CHECKPOINT_REACHED`, `PROJECTION_ACKED` ou
`RESOLUTION_SELECTED`; `expected` est un booléen. Une condition locale ne lit ni
snapshot A1, ni relation, ni score, ni calendrier, ni registre média durable.
Les faits durables conditionnant un futur contenu passent par A6–A10 ; les
conditions locales ne deviennent donc jamais un second moteur d'éligibilité.

`NextBeat` est exactement l'une des trois formes :

- `{mode:DIRECT,beat_id}` ;
- `{mode:BRANCH,branches}`, où `branches` associe chaque `choice_id` fermé à un
  `beat_id` ;
- `{mode:TERMINAL,beat_id:null}`.

### 5.3 Payloads fermés par type

| Type | Champs exacts de `content` | Invariants |
|---|---|---|
| `MESSAGE` | `{thread_id,messages}` ; chaque message = `{message_id,author_id,text,diegetic_at,relative_order}` | IDs uniques, ordre total, auteur participant, aucun `source_day`. |
| `CHOICE` | `{thread_id,choices}` ; chaque choix = `{choice_id,text,resolution_id,next_beat_id}` | 1 à 4 choix pour la vue actuelle ; `resolution_id` peut être `null` avant une issue terminale. |
| `TRANSITION` | `{transition_id,mode,from_anchor,to_anchor,continuation_label}` | `mode = CLOCK|OFF_PHONE|NIGHT|NEW_DAY`; aucun effet durable. |
| `PHYSICAL_BEAT` | `{physical_beat_id,content_ref,withdrawal_choice_ids}` | `content_ref` pointe vers une source authored approuvée ; liste de retrait non vide pour M-B3 ; aucune logique métier dans la scène Godot. |
| `MEDIA_REVEAL` | `{media_id,reveal_context,requires_ack}` | Ne produit aucun accès durable avant la résolution terminale ; l'ack prouve seulement la présentation. |
| `AFTERCARE` | `{aftercare_id,content_ref,obligation_id}` | Phase distincte du payoff ; son résultat est déterminé par un `CHOICE` authored séparé. |
| `RETURN` | `{return_id,content_ref,delay,eligible_resolution_ids}` | Retour post-résolution, une seule fois, dépendant d'une résolution durable fermée ; il ne rouvre pas le payoff. |

## 6. Curseur, checkpoints et cycle d'exécution

### 6.1 État minimal `SequenceExecution`

| Champ | Type |
|---|---|
| `instance_id` | identité A5 reçue après `activate_option` |
| `sequence_id` | identité authored stable |
| `authored_version` | version exacte |
| `execution_status` | `ACTIVE|WAITING_FOR_PLAYER|WAITING_FOR_PROJECTION_ACK|RESOLUTION_READY|RESOLVED_RETURN_PENDING|COMPLETE` |
| `checkpoint_id` | dernier checkpoint validé |
| `current_beat_id` | beat courant ou `null` si complet |
| `consumed_choice_ids` | ensemble ordonné d'IDs |
| `projection_receipts` | dictionnaire `presentation_id → PRESENTED|READ|DISMISSED|VIEWED` |
| `pending_player_input` | `{kind,beat_id,allowed_choice_ids}` ou `null` |
| `selected_resolution_id` | résolution ou `null` |
| `durable_commit_status` | `NOT_REQUESTED|PENDING|APPLIED|IDEMPOTENT` |

Le curseur ne contient aucune relation, audience narrative ou conséquence. Il
avance uniquement sur une arête authored valide et après la condition du
checkpoint : choix accepté, transition confirmée, présentation accusée ou
résolution durable appliquée.

### 6.2 Checkpoints Mathilde obligatoires

Les IDs suivants sont le vocabulaire cible recommandé, cohérent avec l'absence
de convention de checkpoint existante. Ils sont locaux à la séquence et peuvent
être préfixés mécaniquement dans le stockage, sans changer leur sens.

| Ordre | `checkpoint_id` | Preuve requise | Reprise exacte |
|---:|---|---|---|
| 1 | `sequence_entered` | Activation A10 `PROPOSED` liée au catalogue. | Ouvrir l'entrée Messages, sans relancer A10. |
| 2 | `approach_presented` | Tous les messages d'approche accusés présentés. | Afficher le premier point de choix, sans message dupliqué. |
| 3 | `progression_selected` | Un choix look/proximité/distance consommé. | Suivre uniquement sa branche. |
| 4 | `physical_intent_confirmed` | Acceptation M-B3, maintien M-B2 ou arrêt consommé. | Ne jamais redemander le même choix. |
| 5 | `physical_beat_entered` | Transition hors téléphone accusée. | Rouvrir le beat physique au même sous-état. |
| 6a | `payoff_reached` | Centre M-B3 réellement atteint. | Autoriser le média central et interdire toute issue prétendant un arrêt antérieur. |
| 6b | `withdrawal_recorded` | Retrait avant ou pendant le centre. | Ne jamais créer le payoff ni son média central. |
| 7 | `central_media_presented` | Média central accusé, uniquement après `payoff_reached`. | Ne pas le représenter après recharge. |
| 8 | `intensity_exited` | Sortie du beat physique accusée. | Aller à l'aftercare, jamais rejouer le centre. |
| 9 | `aftercare_presented` | Contenu d'aftercare présenté. | Rouvrir son choix, sans confondre aftercare et payoff. |
| 10 | `aftercare_media_presented` | Média d'aftercare accusé s'il est applicable à la sortie réelle. | Ne pas le représenter ; conserver son statut non produit. |
| 11 | `durable_resolution_committed` | `resolve_scene` et tous effets A1–A5 attendus appliqués ou constatés idempotents. | Planifier le retour ou terminer. |
| 12 | `return_presented` | Retour différé éligible présenté et accusé. | Marquer la séquence `COMPLETE`. |

`payoff_reached` et `withdrawal_recorded` sont mutuellement exclusifs. Le choix
d'accepter M-B3 ne suffit pas à atteindre le payoff. Cette règle corrige la
frontière cible sans modifier le legacy qui, lui, crée le fait dès le clic
(`J11RuntimeProvider.gd:463-471`, `Season1State.gd:1290-1324`).

### 6.3 Idempotence et refus

- Un `choice_id` est consommé au plus une fois par instance. Le même rejeu rend
  `IDEMPOTENT`; une autre option du même beat rend `CHOICE_ALREADY_CONSUMED`.
- Un `presentation_id` déterministe concatène `instance_id`, `beat_id` et
  `projection_target` avec le séparateur `__`. Le même ack est idempotent.
- Un checkpoint ne recule jamais et ne saute jamais une arête authored.
- Une résolution ne peut être demandée qu'en `RESOLUTION_READY`, avec version,
  checkpoint, chemin de choix et projection receipts cohérents.
- Le même `(instance_id,resolution_id)` doit retrouver la transaction A3
  déterministe et les mêmes effets ; tout contenu différent est rejeté.
- Un média ou message déjà accusé n'est jamais reproduit après restauration.
- Une version authored absente ou différente rend la sauvegarde invalide ; le
  runtime ne choisit jamais automatiquement une autre version.
- Fermer Messages, Galerie ou PhotoViewer n'est pas un retrait narratif et ne
  crée ni résolution, ni `MISSED`.

## 7. Résolution authored et frontière A10 / A1–A5

### 7.1 `Resolution` et enveloppe minimale

Chaque entrée du dictionnaire `resolutions` possède exactement :

| Champ | Type et sens |
|---|---|
| `resolution_id` | identique à sa clé |
| `choice_id` | dernier choix player-facing déterminant l'issue, ou choix de retrait |
| `a10_choice_id` | l'une des trois branches racines présentes dans `a6_entry.definition.choix` |
| `terminal_checkpoint_id` | checkpoint qui rend l'issue committable |
| `event_refs` | tableau de `{event_type,event_key,reducer_id}` |
| `fact_ids` | tableau d'identifiants authored attendus |
| `knowledge_ids` | tableau d'identifiants attendus |
| `trace_ids` | tableau d'identifiants attendus |
| `promise_effects` | tableau de `{promise_id,effect}` avec `effect = CREATE|PAY|FAIL|NONE` |
| `obligation_effects` | tableau de `{obligation_id,effect}` avec `effect = CREATE_DUE|PAY|FAIL|NONE` |
| `consequence_ids` | tableau d'identifiants attendus |
| `media_effects` | tableau de `{media_id,effect}` avec `effect = CREATE_DIEGETIC|GRANT_ACCESS|REVOKE_ACCESS|NONE` |
| `convergence` | `COMMON_EXIT|POST_RESOLUTION_RETURN|COMPLETE` |
| `next_beat_id` | beat post-résolution, généralement `RETURN`, ou `null` |

L'enveloppe envoyée au commit durable contient seulement
`{instance_id,sequence_id,authored_version,choice_id,a10_choice_id,resolution_id,terminal_checkpoint_id,event_keys}`.
`event_keys` est la liste fermée des clés présentes dans la résolution authored ;
aucun payload libre n'est accepté. Les reducers relisent la définition validée
par `(sequence_id, authored_version, resolution_id)`.

Cette enveloppe n'est pas une transaction universelle. Elle couvre exactement
les registres réels nécessaires à Mathilde M-B3 et refuse tout type d'effet non
déclaré dans v1.

La destination de chaque catégorie est fermée ainsi :

| Catégorie authored | Composant cible A1–A5 | Règle |
|---|---|---|
| Événement | `EtatNarratif.traiter_evenement` et registre `evenements` A1 | Identifiant déterministe ; reducer choisi par `event_type`, jamais par l'UI. |
| Connaissance | reducer A1 ciblé, racine `connaissances` | Acquisition et audience sourcées par la résolution. |
| Trace | reducer A1 ciblé, racine `traces_narratives` | Créateur, audience, contrôle, retrait et accès restent distincts. |
| Promesse | reducer A1 ciblé, racine `promesses` | Création/paiement/échec seulement si déclaré. |
| Obligation | reducer A1 ciblé, racine `obligations` | `DUE|PAID|FAILED` ; l'aftercare utilise cette catégorie. |
| Conséquence | reducer relation/progression A1 | Valeur qualitative ou fait fermé, jamais score libre. |
| Statut de scène | instance et registre A5 via A3/A10 | `RESOLVED` committé dans la même transaction que l'événement. |
| Média accessible | reducer A1 ciblé, racine `livraison_medias` | Accès, audience, Galerie et retrait sourcés ; le fichier technique ne suffit pas. |
| Aftercare payé/échoué | reducer d'obligation A1 + événement source | `PAID|FAILED` est distinct du payoff et du média d'aftercare. |

Les reducers ciblés sont des extensions de la taxonomie A1 existante, pas un
reducer universel. Le codec A5 doit valider ces racines après leur extension ;
il n'en crée aucune nouvelle.

### 7.2 Point unique de résolution durable

Pour la première tranche, une instance A10 possède un unique commit durable,
après la sortie et le choix d'aftercare :

1. les beats et médias sont présentés, leurs reçus restent dans l'état
   d'exécution ;
2. le choix d'aftercare ou le retrait ferme `resolution_id` ;
3. l'exécuteur construit l'enveloppe depuis la définition immuable ;
4. `A10.resolve_scene(instance_id, a10_choice_id, resolution_id, context)` est
   appelé une seule fois ;
5. A3/A1–A5 appliquent atomiquement le statut de scène et les effets fermés ;
6. l'exécuteur vérifie `APPLIQUE|IDEMPOTENT`, écrit
   `durable_resolution_committed`, puis ouvre le `RETURN` éventuel.

Aucun accès Galerie durable n'est accordé avant l'étape 5. Le média peut avoir
été présenté dans le beat physique, mais la Galerie n'est projetée depuis le
registre A1–A5 qu'après le commit. Une interruption avant l'aftercare reprend la
séquence ; elle ne laisse pas un demi-effet durable.

### 7.3 Insuffisance actuelle fermée pour N13

Le `resolve_scene` actuel applique seulement les résolutions A3 synthétiques et
le codec A5 refuse les cinq registres non vides. Il ne peut donc pas, aujourd'hui,
committer atomiquement fait + trace + obligation + média Mathilde. Le besoin
minimal futur est :

- conserver les sept opérations et la signature publique A10 ;
- réserver dans `context` une clé fermée `sequence_resolution` portant
  l'enveloppe ci-dessus ;
- faire valider cette clé par A3 contre le catalogue authored exact ;
- étendre dans un lot approuvé la taxonomie/reducers A1 et le codec/version A5
  pour appliquer tous les effets avant la transition A5 `RESOLVED` ;
- rejeter toute mutation partielle et tout effet non déclaré.

N11 ne réalise ni n'autorise cette évolution. N13 devra la faire approuver et la
tester sans ajouter une huitième opération A10, une façade générale ou une
seconde écriture après `resolve_scene`. Appliquer d'abord A10 puis muter A1 par
une référence externe est explicitement interdit car non atomique.

### 7.4 Flux exact des sept opérations A10

| Opération | Flux cible |
|---|---|
| `create(library,narrative_state)` | Le bootstrap projette les `a6_entry` validées vers une `R8CNarrativeSceneLibrary`, crée/restaure A1, puis construit A10. L'exécuteur reçoit le catalogue complet séparément, en lecture seule. |
| `find_candidates(context)` | Retourne seulement `{scene_definition_id,variant_id}`. Le bootstrap ne déduit aucun beat de ce résultat. |
| `compose_slot(slot_request)` | Le caller matérialise `a8_window`, `a9_slot` et `temporal_projection`; A8/A9 gardent toute décision de fenêtre et placement. |
| `activate_option(plan,option_id,{intention:PROPOSE,context})` | Après succès, A10 transmet déjà `instance_id`, états et résumé de fenêtre (`NarrativeOrchestrationFacade.gd:266-294`). Le couple définition/variante de l'option sélectionnée lie l'instance au catalogue ; l'exécuteur crée `SequenceExecution` au checkpoint `sequence_entered`. |
| `resolve_scene(...)` | Appel unique au checkpoint durable avec `a10_choice_id`, `resolution_id` et contexte fermé. A10 reste le seul chemin vers la terminaison A5. |
| `save_state()` | Fournit exactement la partie domaine A1/A5 du snapshot composite, sans présentation ni curseur. |
| `restore_state(snapshot)` | Restaure seulement A1/A5 et recâble A7–A9. Le bootstrap restaure ensuite l'exécution et vérifie les références croisées avant publication. |

La quittance `_reprises_activation` est éphémère et effacée par
`restore_state` (`NarrativeOrchestrationFacade.gd:206-213`; contrat A10
`:119-125`). Une restauration d'instance active ne rejoue donc jamais
`activate_option`; elle reprend l'instance A5 et le curseur sauvegardé.

### 7.5 Proposition, abandon et `MISSED`

- Une option jamais proposée peut être fermée silencieusement et ne crée aucune
  instance ni absence.
- `MARK_MISSED_IF_PROPOSED` reste exclusivement une politique A8/A5 et ne vise
  qu'une instance réellement `PROPOSED`.
- Quitter une surface UI n'est pas un abandon authored. Une séquence proposée
  reste active et reprenable.
- Mathilde M-B3 n'a aucun timeout d'abandon. Retrait, maintien M-B2 et arrêt sont
  des issues authored résolues, jamais `MISSED`.
- La façade A10 actuelle n'expose aucune expiration d'une séquence déjà remise à
  l'exécuteur. N11 interdit d'en simuler une. Si un futur contenu exige cette
  politique, il nécessitera une décision produit séparée ; elle ne bloque pas
  Mathilde M-B3.

## 8. Exécuteur minimal

### 8.1 Responsabilités autorisées

- charger une définition validée par identité et version ;
- démarrer l'instance liée à une activation A10 ;
- exposer le prochain beat et sa projection ;
- accepter uniquement un choix fermé du beat courant ;
- avancer sur l'arête authored, enregistrer checkpoints et reçus ;
- reprendre avant/après choix, payoff, média et aftercare ;
- demander le commit durable via A10 et vérifier le résultat ;
- refuser tout double effet ;
- conserver un retour post-résolution jusqu'à son accusé.

### 8.2 Responsabilités interdites

Il ne recalcule pas A7, ne compose pas A9, ne remplace pas A10, ne possède pas
de registre de scènes ou bus d'événements, ne stocke aucun score, n'interprète
pas librement une relation, ne connaît aucun jour, ne contient aucune branche
Mathilde en code, ne lit/écrit pas le legacy et n'alimente jamais deux systèmes.

## 9. Port commun de projection player-facing

### 9.1 Interface minimale

Le futur `PlayerProjectionPort` possède trois opérations conceptuelles, quelle
que soit la surface :

| Opération | Entrée | Sortie |
|---|---|---|
| `open(request)` | `ProjectionRequest` | `ProjectionResult` |
| `submit(command)` | `ProjectionCommand` | `ProjectionResult` |
| `acknowledge(receipt)` | `PresentationReceipt` | `ProjectionResult` |

`ProjectionRequest` contient exactement
`{instance_id,sequence_id,authored_version,beat_id,beat_type,projection_target,presentation_state}`.
`presentation_state` est une copie bornée des reçus de ce beat, jamais le
snapshot métier.

`ProjectionCommand` contient exactement
`{command_id,instance_id,beat_id,kind,choice_id}` avec
`kind = CONTINUE|SELECT_CHOICE|WITHDRAW|OPEN_GALLERY|OPEN_MEDIA|CLOSE` ;
`choice_id` est requis seulement pour `SELECT_CHOICE|WITHDRAW`.

`PresentationReceipt` contient exactement
`{presentation_id,instance_id,beat_id,kind,subject_id}` avec
`kind = PRESENTED|READ|DISMISSED|VIEWED`.

`ProjectionResult` contient exactement
`{accepted,idempotent,projection_target,presentation_id,payload,next_command_kinds,error_code}`.
`payload` est validé par l'adaptateur de surface ; il ne transporte aucun état
durable mutable.

### 9.2 Messages et choix

L'adaptateur Messages produit les DTO existants :

- fil : `thread_id`, titre, participants, disponibilité, preview et compte
  non-lu ;
- message : `message_id`, `author_id`, texte, instant diégétique,
  `content_type`, `media_ref`, `is_player`, état lu projeté ;
- choix : `choice_id`, texte, `enabled`, `confirmation_required` ;
- typing éventuel comme état de présentation, jamais fait narratif.

Il remplace `source_day` par l'instant/ancrage diégétique et la provenance
`sequence_id/beat_id`. Il conserve l'injection déjà offerte par
`MessagesScreen.configure_content_source`, mais traduit `select_choice` vers
l'exécuteur. Une bulle Player est dérivée une seule fois du choix consommé.

### 9.3 Beat physique

L'adaptateur physique :

- quitte le téléphone après ack de transition ;
- reçoit exclusivement `content_ref` et les commandes authored autorisées ;
- expose `WITHDRAW` à tout checkpoint de retrait déclaré ;
- renvoie un reçu de sortie et la commande suivante ;
- ne contient aucune éligibilité, conséquence ou branche Mathilde dans une
  scène Godot.

La séquence PhotoViewer legacy prouve une surface réutilisable, pas le contrat
métier cible. N14 peut la conserver si elle accepte le port et le retrait ;
sinon il peut adapter une autre surface existante sans modifier le domaine.

### 9.4 Média, Galerie et PhotoViewer

- `MEDIA_REVEAL` reçoit un média autorisé par le beat et rend soit le fichier
  validé, soit l'état de développement explicitement non canonique.
- Galerie interroge une projection du registre `livraison_medias` A1–A5, jamais
  `Season1State`, et ne mute plus localement l'autorité `is_new`.
- PhotoViewer reçoit seulement des items dont l'accès joueur est projeté
  `ACCESSIBLE`; il envoie `VIEWED` mais ne crée pas l'accès.
- `VisualMediaResolver` reste un resolver technique : fichier présent,
  placeholder de développement ou non-livré. Il ne déduit ni audience, ni
  accès, ni Galerie.
- Un média non diégétique peut être visible du joueur sans exister dans la
  fiction. Galerie n'implique ni propriété, ni détention, ni audience.

Pour une ouverture autonome de Galerie/PhotoViewer, `instance_id` et `beat_id`
proviennent de la provenance durable du média. Ils ne rouvrent pas l'exécution
et aucune commande de choix n'est alors autorisée.

## 10. Notifications, disponibilité et non-lus

Les six états suivants sont distincts :

| État | Propriétaire | Création / fin |
|---|---|---|
| Événement narratif durable | A1–A5 | Par résolution A10 uniquement. |
| Beat disponible | Exécuteur | Quand le curseur atteint le beat et ses conditions locales. |
| Notification affichée | Ledger de présentation | Créée par l'adaptateur Messages si un nouveau beat message est disponible hors fil actif ; terminée par `PRESENTED|DISMISSED`. |
| Contenu non lu | Ledger de présentation | Créé à la disponibilité d'un message entrant ; terminé par `READ`. |
| Message présenté | Ledger de présentation | Reçu `PRESENTED` après rendu effectif. |
| Message lu | Ledger de présentation | Reçu `READ` après visibilité effective dans le fil, jamais au simple enqueue. |

Règles fermées :

- `notification_id` concatène `instance_id`, `beat_id` et le suffixe
  `notification` avec le séparateur `__`, puis pointe vers
  `thread_id`, `instance_id`, `beat_id` ; l'ouverture renvoie à la séquence
  active sans la réactiver.
- Le ledger enregistre notifications en attente/affichées/écartées, non-lus,
  messages présentés et lus. Il appartient au snapshot d'exécution.
- Un ack identique est idempotent ; une notification déjà présentée ou écartée
  n'est pas recréée après reprise.
- Une notification n'est pas créée depuis un événement durable seul : elle
  provient de la disponibilité d'un beat player-facing.
- Un message peut être présenté sans être lu ; un événement peut être durable
  sans message ; un beat peut être disponible sans notification si le fil est
  déjà actif.
- La règle legacy « latest pending wins » (`MessagesScreen.gd:1487-1510`) n'est
  pas autoritative. La cible persiste une file ordonnée par `presentation_id`.

## 11. Cycle de vie média v1

### 11.1 Définition authored

`MediaDefinition` possède exactement :

| Champ | Type et valeurs |
|---|---|
| `media_id` | identifiant authored stable ; identique à la clé |
| `visual_level` | `V0|V1|V2|V3|V4|V5` |
| `analytic_level` | `NV0|NV1|NV2|NV3|NV4` ou `null` |
| `production_status` | `SPECIFIED_NOT_PRODUCED|DERIVED_OR_REUSED_NOT_SEPARATELY_PRODUCED|PRODUCED|VALIDATED` |
| `diegesis` | `DIEGETIC|NON_DIEGETIC` |
| `audience_ids` | tableau non vide d'audiences authored |
| `gallery_policy` | `NEVER|ON_ACCESS` |
| `parent_media_id` | média parent ou `null` |
| `thumbnail_policy` | `SELF|DERIVE_FIRST_ACCESSIBLE_CHILD|REUSE_MEDIA` |
| `thumbnail_media_id` | ID requis seulement pour `REUSE_MEDIA`, sinon `null` |
| `removal_policy` | `NEVER|AUTHORED_RESOLUTION_ONLY` |

### 11.2 États distincts et transitions

Le registre durable sépare :

- production : spécifié → produit → validé ;
- disponibilité technique du fichier ;
- création diégétique ou nature non diégétique ;
- audience ;
- accès joueur `UNKNOWN|KNOWN|ACCESSIBLE|REVOKED` ;
- admission Galerie ;
- consultation PhotoViewer ;
- retrait ou perte d'accès.

Un fichier présent ne donne aucun accès. `SPECIFIED_NOT_PRODUCED` ne devient
jamais `PRODUCED` parce qu'un placeholder est rendu. `REVOKED` n'est ni
`NOT_PRODUCED`, ni « jamais atteint ». Toute évolution d'audience ou d'accès est
sourcée par `resolution_id`.

En développement uniquement, `VisualMediaResolver` peut rendre un cadre portant
explicitement « Visuel canonique non produit ». Ce rendu a le statut technique
`DEVELOPMENT_PLACEHOLDER`, n'est jamais exporté comme asset canonique et permet
de tester métadonnées, ordre, accès et reprise. Une livraison player-facing
prête refuse ce mode.

## 12. Sauvegarde et reprise cible

### 12.1 Namespace et enveloppe

Le namespace stable choisi, faute de namespace disque existant dans le dépôt,
est :

`reseau_intime.unified_runtime`

La version reste un champ de l'enveloppe et ne change pas le namespace. Le
snapshot `UnifiedRuntimeSaveV1` possède exactement :

| Champ | Contenu |
|---|---|
| `save_namespace` | littéral `reseau_intime.unified_runtime` |
| `snapshot_version` | entier `1` |
| `domain` | retour exact de `A10.save_state()`, donc snapshot reconstructible A1/A5 |
| `execution` | dictionnaire `instance_id → SequenceExecution` |
| `presentation` | `{threads,messages,notifications,unread_ids,active_projection,ui_return}` |
| `media` | `{known_media_ids,accessible_media_ids,audiences,gallery_parent_ids,viewed_media_ids,production_statuses}` |
| `integrity` | `{catalog_fingerprint,snapshot_fingerprint}` |

`presentation` contient les projections nécessaires à une reprise exacte, pas
une seconde copie des faits. `media` est une projection validable du registre
durable : à la restauration, toute divergence avec A1–A5 invalide le snapshot.

Les sous-structures de `presentation` sont fermées ainsi :

- `threads` est l'ensemble ordonné des `thread_id` disponibles ;
- `messages` est un dictionnaire
  `message_id → {thread_id,presented,read}` ; le texte est relu depuis la version
  authored épinglée ;
- `notifications` est un dictionnaire
  `notification_id → {thread_id,instance_id,beat_id,state}` avec
  `state = PENDING|PRESENTED|DISMISSED` ;
- `unread_ids` est l'ensemble des `message_id` non lus et doit correspondre aux
  entrées `messages.read = false` ;
- `active_projection` vaut
  `{projection_target,instance_id,beat_id,presentation_id}` ou `null` ;
- `ui_return` vaut `{surface,thread_id,reading_position}` ou `null`, avec
  `surface = MESSAGES|GALLERY|PHOTO_VIEWER|PHYSICAL`.

### 12.2 Restauration atomique

1. Valider namespace, version, formes fermées et empreinte.
2. Charger le catalogue exact et vérifier chaque `(sequence_id,authored_version)`.
3. Valider que chaque `instance_id` existe dans `domain.scene_registry` avec la
   même définition/version et un statut compatible.
4. Appeler `A10.restore_state(domain)` dans un graphe non publié.
5. Restaurer exécution, présentation et médias ; vérifier checkpoints, choix,
   receipts, accès et résolution contre le catalogue et le domaine restauré.
6. Publier l'ensemble seulement si toutes les vérifications réussissent.
7. Rouvrir `active_projection` ou appliquer `ui_return` sans rejouer le beat.

L'écriture disque future est atomique par fichier temporaire + remplacement,
mais N11 ne crée aucun fichier ni manager. Le snapshot ne contient jamais
`Season1State`, provider/map JNN, snapshot hybride, fallback legacy ou référence
obligatoire à une sauvegarde antérieure. Aucun import legacy n'est garanti.

## 13. Bootstrap du nouveau runtime

Le futur bootstrap minimal exécute cet ordre :

1. charger et valider le catalogue authored cible ;
2. en extraire les seules entrées A6 et construire la bibliothèque ;
3. créer un état A1 neuf ou préparer le snapshot `domain` ;
4. appeler `A10.create`, puis `restore_state` si une sauvegarde cible existe ;
5. restaurer le curseur/ledger ou créer une partie cible neuve ;
6. appeler `find_candidates`, construire la requête authored, puis
   `compose_slot` ;
7. faire choisir/proposer l'option et appeler `activate_option(PROPOSE)` ;
8. lier l'instance au catalogue, créer `SequenceExecution` et ouvrir la
   projection du premier beat ;
9. en mode développement, limiter le catalogue à la tranche Mathilde sans menu
   complet de Saison.

Le bootstrap ne précharge aucun `JNNRuntimeProvider`, ne construit pas
`Season1RuntimeProvider`, ne lit pas `Season1State`, ne charge aucune map JNN et
n'offre aucun fallback. `PortraitShell` devra recevoir une source injectée ; sa
surface peut rester réutilisée.

## 14. Contrat précis Mathilde M-B3

### 14.1 Identité cible proposée

Une seule identité est proposée car le dépôt possède déjà une identité authored
stable, sans jour, dans le script canonique
(`docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md:712-724`) :

| Champ | Valeur cible |
|---|---|
| `sequence_id` | `mathilde_returns_with_chosen_intent_01` |
| `season_id` | `season_1` |
| `dramatic_movement_id` | `movement_iii` |
| `source_sequence_ids` | `S20`, `C11-03`, payoff `#045`, alias legacy `MATHILDE_J11_SECRET_INTIMACY` |
| `narrative_function` | `RELATION` — rendre la proximité volontaire, avec plafond M-B3 conditionnel |
| `a6.scene_definition_id` | `mathilde_returns_with_chosen_intent_01` |
| `a6.variant_id` | `mathilde_returns_with_chosen_intent_canonical` |
| `politique_unicite` | `UNIQUE` |

`S20` reste l'identité de bibliothèque historique, `C11-03` le parent authored
de production et `MATHILDE_J11_SECRET_INTIMACY` un alias de projection. Aucun ne
devient une dépendance au jour. N11 ne crée pas le futur fichier authored et ne
lui attribue pas `CANON_APPROVED`.

### 14.2 Inventaire réel à migrer, pas à recopier aveuglément

| Élément | Source réelle | Cible N16 |
|---|---|---|
| Fil | `chapter_11_mathilde_return.json:2-8`, `thread_mathilde_private` | Même surface Messages, ID de fil stable. |
| Approche | segment `j11_mathilde_opening`, lignes `11-21` | Beats `MESSAGE`, IDs cible sans jour ; IDs legacy conservés seulement dans provenance. |
| Choix 1 | look/proximity/distance, lignes `23-43` | Trois choix racines A3 et player-facing. |
| Entrée physique | lignes `61-65` | Messages puis `CHOICE`; le script canonique `:939-957` demeure l'autorité de réécriture. |
| Choix 2 | accept M-B3 / maintien M-B2 / stop, lignes `67-79` | Branche exécuteur, retrait avant payoff. |
| Beat physique | `docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md:984-1030`, `docs/narrative/R8C_N9_W4_PAYOFF_AFTERCARE_AND_J21_CONTINUITY_CONTRACT.md:234-246` | `TRANSITION` + `PHYSICAL_BEAT` avec retrait à chaque étape ; aucun code Mathilde dans la vue. |
| Payoff/arrêt | N9 `:239-263,584-596` | `payoff_reached` seulement si centre atteint ; sinon `withdrawal_recorded`, aucun #045. |
| Aftercare | JSON `:82-100`, N9 `:248-263` | `AFTERCARE` + troisième `CHOICE`, distinct du payoff. |
| Retour | J12/J13/J17 sources et N9 `:265-283` | `RETURN` post-résolution, une fois, variant selon `PAID|FAILED`, sans replay. |

Les neuf choix legacy sont mappés vers des IDs cible stables :

| Legacy | Cible |
|---|---|
| `choice_j11_mathilde_look` | `mathilde_return_look_only` |
| `choice_j11_mathilde_proximity` | `mathilde_return_invite_proximity` |
| `choice_j11_mathilde_distance` | `mathilde_return_keep_distance` |
| `choice_j11_mathilde_m_b3_accept` | `mathilde_intimacy_accept_m_b3` |
| `choice_j11_mathilde_m_b2_hold` | `mathilde_intimacy_hold_m_b2` |
| `choice_j11_mathilde_physical_stop` | `mathilde_intimacy_stop` |
| `choice_j11_mathilde_after_no_definition` | `mathilde_aftercare_no_definition` |
| `choice_j11_mathilde_after_marie` | `mathilde_aftercare_acknowledge_marie` |
| `choice_j11_mathilde_after_repeat` | `mathilde_aftercare_request_repeat` |

Le JSON réel diffère du script canonique sur l'entrée physique et le centre
legacy reste sous la cible W4. N16 migre depuis les autorités N7/N9, avec revue
produit, sans traiter le JSON servi comme vérité supérieure et sans modifier le
payoff dans N11.

### 14.3 Résolutions M-B3 minimales

| `resolution_id` | Condition terminale | Durable attendu | Média |
|---|---|---|---|
| `mathilde_m_b3_aftercare_paid_no_definition` | payoff atteint + `mathilde_aftercare_no_definition` | fait `fact_mathilde_physical_event_occurred` niveau M-B3 ; trace privée ; obligation aftercare `PAID`; état `PHYSICAL_SECRET` | accès aux enfants réellement présentés ; centre requis |
| `mathilde_m_b3_aftercare_paid_marie_acknowledged` | payoff atteint + reconnaissance de la conséquence Marie | mêmes fait/trace/état ; obligation `PAID`; conséquence Marie distincte, sans révélation automatique | mêmes règles |
| `mathilde_m_b3_aftercare_failed_repeat_pressure` | payoff atteint + demande de répétition | scène consentie conservée ; obligation `FAILED`; priorité/fermeture ultérieure selon N9 | mêmes enfants atteints ; l'échec ne retire pas rétroactivement le payoff |
| `mathilde_m_b3_withdrawn_before_payoff` | retrait avant/pendant centre | aucune prétention M-B3, aucun fait `physical_level=MATHILDE_M_B3`; sortie/aftercare fidèle au vécu | aucun média central ; aftercare seulement s'il est réellement présenté |
| `mathilde_m_b2_held` | maintien M-B2 | issue distincte, aucun fait M-B3 | aucun média central M-B3 |
| `mathilde_physical_stopped` | arrêt au choix 2 | arrêt non punitif, aucune absence | aucun triplet M-B3 déverrouillé |

Les identifiants N9 existants `aftercare_mathilde_j11` et
`j11_mathilde_physical_aftercare_01` restent des références canon-source
opaques dans `event_refs`. Le lot d'implémentation doit soit les conserver comme
IDs verrouillés sans les parser, soit faire approuver leur alias stable ; N11 ne
les renomme pas silencieusement.

### 14.4 Trois enfants et parent dérivé

| Ordre | `media_id` | Fonction | Niveau | Diégèse | Production | Déblocage cible |
|---:|---|---|---|---|---|---|
| 1 | `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY` | entrée/proximité #043 | `NV2`, `V3` | non diégétique | `SPECIFIED_NOT_PRODUCED` | seulement si l'entrée physique correspondante a été réellement présentée |
| 2 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` | payoff central #045 | `NV4`, `V5` | non diégétique | `SPECIFIED_NOT_PRODUCED` | uniquement après `payoff_reached` |
| 3 | `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` | sortie/aftercare #046 | `NV2`, `V4` | non diégétique | `SPECIFIED_NOT_PRODUCED` | uniquement si la sortie/aftercare correspondante est présentée |

Les niveaux proviennent de
`docs/narrative/R8C_N6_VISUAL_REWARD_AND_PHOTO_COVERAGE_AUDIT.md:149-152`;
les statuts et l'ordre sont verrouillés par N10 `:568-582`.

Le parent Galerie est exactement
`S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01` avec :

- `gallery_policy = ON_ACCESS` ;
- aucun quatrième fichier ;
- `thumbnail_policy = DERIVE_FIRST_ACCESSIBLE_CHILD`, équivalent au statut
  produit `DERIVED_OR_REUSED_NOT_SEPARATELY_PRODUCED` ;
- enfants projetés = seulement les enfants durablement accessibles, dans
  l'ordre 1→3 ; un enfant non atteint n'est ni révélé par son label ni compté
  comme disponible ;
- partage interdit, audience joueur, nature non diégétique ;
- Galerie et PhotoViewer alimentés par le nouveau registre média seulement.

### 14.5 Critères de réussite de N16

- démarrage depuis le nouveau bootstrap ;
- sélection/proposition par A6–A10 ;
- entrée et reprise dans Messages ;
- trois points de choix fonctionnels sans double consommation ;
- beat physique présenté avec retrait avant et pendant le centre ;
- payoff durable seulement s'il est réellement atteint ;
- conséquence qualitative A1–A5, sans score ;
- aftercare distinct, `PAID|FAILED` selon les actes ;
- retour ultérieur dépendant de la résolution et présenté une seule fois ;
- cycle exact des trois médias, sans quatrième asset ;
- Galerie/PhotoViewer depuis le registre cible ;
- reprise avant/après choix, entrée physique, payoff, aftercare et commit ;
- aucune lecture/écriture legacy, aucun provider/map JNN ;
- une scène jamais proposée ne devient pas une absence.

## 15. Interfaces nouvelles : justification anti-usine à gaz

| Élément futur | Problème M-B3 résolu | Duplication évitée | Invariant protégé | Pourquoi l'existant ne suffit pas |
|---|---|---|---|---|
| Catalogue unifié + projection A6 | Retrouver beats/médias après activation A10. | Un fichier A6 et un fichier de transcript divergents. | Même identité/version pour orchestration et exécution. | A6 est fermé et ne porte aucun contenu player-facing. |
| Exécuteur de séquence | Reprise aux checkpoints et retrait au milieu du beat. | Phases codées dans chaque provider JNN. | Curseur monotone, choix/effets idempotents. | A10 refuse explicitement séquences et curseurs. |
| `PlayerProjectionPort` | Brancher Messages, physique, média, Galerie et Viewer. | Callbacks spécifiques par provider/surface. | Reçus stables, UI sans décision métier. | Les vues sont injectables mais attendent encore un provider legacy implicite. |
| Extension fermée de résolution dans `context` A10 | Commit fait + trace + obligation + média au même checkpoint. | Double écriture A10 puis A1. | Atomicité A1/A5 et terminaison A5. | A3 est synthétique et A5 exige cinq registres vides. |
| Store du snapshot cible | Reprendre choix, projection et média avec le domaine. | Snapshot par jour/provider. | Namespace, version, validation croisée, écriture atomique. | A10 sauvegarde uniquement A1/A5 en mémoire. |

Aucun bus supplémentaire, DSL, moteur de règles, graphe arbitraire, ECS, plugin,
éditeur, API multi-Saisons, migration universelle, compatibilité legacy ou
troisième registre de scènes n'est autorisé.

## 16. Lots techniques suivants

### N12 — Contrats de données et ports

- implémenter `AuthoredSequenceV1`, les sept payloads de beat, résolutions,
  médias, curseur et DTO de projection ;
- valider fermeture, références, arêtes, versions et projection A6 ;
- fournir faux ports/harness de données uniquement ;
- ne connecter aucune UI player-facing et ne modifier aucun contenu canonique.

### N13 — Exécuteur et sauvegarde minimale

- implémenter curseur, checkpoints, receipts et reprise ;
- obtenir l'approbation spécifique de l'enveloppe `sequence_resolution`, puis
  étendre atomiquement reducers/codec A1–A5 sans nouvelle opération A10 ;
- implémenter snapshot composite dans `reseau_intime.unified_runtime` et faux
  adaptateurs ;
- prouver absence de legacy et de double écriture.

### N14 — Projections Messages et beat physique

- adapter Messages, choix, typing, transitions, notifications et non-lus au port ;
- adapter le beat physique avec retrait et reprise ;
- conserver les vues réutilisables lorsque leur source peut être remplacée.

### N15 — Cycle média, Galerie et PhotoViewer

- activer le registre média A1–A5 et ses projections ;
- recâbler Galerie/PhotoViewer, parent dérivé et reçus `VIEWED` ;
- tester `SPECIFIED_NOT_PRODUCED` avec placeholder strictement développement.

### N16 — Tranche Mathilde M-B3

- produire le package authored réel après revue produit W4 ;
- intégrer l'entrée Messages, les branches/retraits, le beat physique,
  l'aftercare, les retours et le triplet média ;
- ne migrer ni toute J11, ni Marie, ni Sandra, ni J17/J21, ni les assets finaux.

N14 et N15 peuvent être regroupés uniquement si un même adaptateur de projection
et le même harness de reprise couvrent effectivement Messages, scène et média
sans rendre le cycle média dépendant de l'UI. N12, N13 et N16 restent séparés :
schéma, mécanisme durable et contenu sensible exigent des revues distinctes.

## 17. Gouvernance documentaire après N11

N11 ne modifie aucun autre document de cette table. Il fixe ici le classement
des trois sources arbitrées par le produit.

| Classement | Chemins pertinents | Effet de N11 |
|---|---|---|
| Canon | `docs/narrative/R8C_N7_1_SEASON_STRUCTURE_RUNTIME_PROJECTION_AND_N8_ENTRY_CONTRACT.md`; `docs/narrative/R8C_N9_W4_PAYOFF_AFTERCARE_AND_J21_CONTINUITY_CONTRACT.md`; `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md`; `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md`; `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md`; `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md`; `docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md` | Autorité narrative, temporelle, aftercare, audience et média ; aucune destination provider/JSON. |
| Target Runtime | `docs/architecture/R8C_A1_FONDATION_ETAT_NARRATIF.md`; `docs/architecture/R8C_A2_CONTRAT_SCENE_MODULAIRE_ET_MOTEUR_NARRATIF.md`; `docs/architecture/R8C_A3_PROTOTYPE_MINIMAL_SCENE_NARRATIVE.md`; `docs/architecture/R8C_A5_PERSISTANCE_MINIMALE_SCENES_ET_OPPORTUNITES.md`; `docs/architecture/R8C_A6_BIBLIOTHEQUE_NARRATIVE_MINIMALE_IMPLEMENTATION.md`; `docs/architecture/R8C_A7_RESERVATION_ET_PROPOSITION_CANDIDATS.md`; `docs/architecture/R8C_A8_FENETRES_OPPORTUNITE_ET_CONFLITS_EXCLUSIFS.md`; `docs/architecture/R8C_A9_COMPOSITION_CONTROLEE_CRENEAU_NARRATIF.md`; `docs/architecture/R8C_A10_VERTICAL_SLICE_ORCHESTRATION_ET_SIMPLIFICATION_API.md`; `docs/architecture/R8C_N10_LEGACY_FREEZE_AND_NEW_RUNTIME_CUTOVER_CONTRACT.md`; présent N11 après décision produit | A1–A10 restent verrouillés ; N11 fixe les liaisons et les besoins N12–N16 sans les implémenter. |
| Reusable Presentation | `docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md`, `UI_02_SCREEN_ARCHITECTURE_AND_STATES.md`, `UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md`, `docs/runtime/T_UI_01_PORTRAIT_SHELL_PLAN.md`, `V0_86A_TEMPORAL_UX_NOTIFICATION_POLISH_PLAN.md` | Conserver UX et surfaces ; remplacer les sources provider/jour par les ports cible. |
| Legacy Reference | `docs/runtime/README.md`, `SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md`, plans `V0_81` à `V0_94` classés ainsi par N10 ; `game/data/conversations/*.json`, providers/maps J01–J21 comme références techniques non documentaires | Aucune autorité sur le nouveau format, la sauvegarde ou le bootstrap ; sources de parité/migration seulement. |
| Migration Support | A11/A11.2/A11.3/A11.4/A11.5 ; `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md`; documents N1–N5 de migration Sandra | Outils/provenance hors runtime ; aucun export A6 n'est un contenu player-facing complet. |
| Archive | `docs/architecture/R8C_A6_BRIEF_BIBLIOTHEQUE_NARRATIVE_MINIMALE.md`; `docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md`; `docs/runtime/V0_86_PR_REVIEW_NOTES.md`; `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md` | Aucune autorité normative cible. Un document archivé peut rester une source de provenance historique, notamment pour les anciennes justifications, identifiants et comptages. |
| À réécrire | `docs/narrative/R8C_N6_CONTENT_PRODUCTION_FORECAST_AND_ROADMAP.md`; anciens plans/distributions obligatoires par jour ; `docs/CURRENT_NARRATIVE_SOURCE_OF_TRUTH.md`; scripts J17/J18/J19/J21 déjà classés ainsi par N10 ; `docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md`; `docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md` | Réécrire par séquence/mouvement et vers la cible, jamais en ajoutant des providers. Un document à réécrire peut conserver une matière éditoriale canonique explicitement identifiée sans constituer le contrat cible. |

Effets thématiques :

- conversations JSON : `Legacy Reference`, texte de migration seulement ;
- providers/maps/journées : `Legacy Reference`, gelés, aucune extension ;
- médias : IDs/fonctions/audiences canon, destination technique remplacée par le
  registre cible ;
- sauvegarde : les documents legacy restent références ; le namespace cible est
  défini ici ;
- A1–A10 : `Target Runtime`, opérations publiques inchangées ; seuls les besoins
  minimaux des lots futurs sont consignés.

## 18. Gates de revue et verdict

### 18.1 Gate documentaire N11

- [x] Baseline et tag exacts vérifiés.
- [x] Diff borné au document N11.
- [x] Chemins réels A1–A10, UI, legacy, médias et Mathilde inspectés.
- [x] Format authored v1 fermé et frontière A6 explicitée.
- [x] Sept types de beats seulement.
- [x] Curseur, douze checkpoints et idempotence couverts.
- [x] Frontières A10/exécuteur/A1–A5 fermées.
- [x] Insuffisance A10/A1/A5 bornée sans nouvelle façade.
- [x] Ports Messages, choix, physique, média, Galerie et PhotoViewer couverts.
- [x] Notifications, présentation et lecture distinguées.
- [x] Snapshot cible et namespace indépendants du legacy.
- [x] Cycle média, trois enfants et parent dérivé couverts.
- [x] Bootstrap sans provider JNN défini.
- [x] Identité Mathilde indépendante du jour proposée.
- [x] Critères N16 et découpage N12–N16 définis.
- [x] Aucune double écriture, dépendance legacy ou quatrième asset autorisé.
- [x] Trois classements documentaires arbitrés par le produit.
- [x] Statut `UNIFIED_CONTENT_EXECUTOR_PROJECTION_CONTRACT_READY_FOR_PRODUCT_REVIEW` attribué.
- [ ] Statut `UNIFIED_CONTENT_EXECUTOR_PROJECTION_CONTRACT_APPROVED` attribué par le produit.

### 18.2 Non-objectifs confirmés

N11 n'implémente pas l'exécuteur, ne commence pas Mathilde, ne migre aucune
journée, ne produit aucun média, n'ajoute aucun placeholder canonique, ne modifie
aucun dialogue/JSON/test/scène/asset/UI, ne touche pas A1–A10 et ne promet aucun
import de sauvegarde legacy.

### 18.3 Verdict

Le contrat authored, l'exécuteur mince, les projections, le snapshot, le cycle
média, le bootstrap et la cible Mathilde M-B3 sont suffisamment définis pour une
revue produit. Les trois conflits de gouvernance documentaire sont résolus. Le
statut `APPROVED` reste réservé à une décision produit ultérieure.

Le statut de livraison N11 est donc :

`UNIFIED_CONTENT_EXECUTOR_PROJECTION_CONTRACT_READY_FOR_PRODUCT_REVIEW`
