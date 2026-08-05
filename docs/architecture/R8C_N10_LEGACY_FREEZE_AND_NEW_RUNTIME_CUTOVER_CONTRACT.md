# R8C-N10 — Gel du runtime journées et contrat de cutover vers le nouveau moteur narratif

> **Baseline obligatoire vérifiée :** `ab058f87e6f1343927068dd0fc2d73c305b44265`
>
> **Tag stable vérifié :** `r8c-n9-w4-payoff-aftercare-j21-continuity-contract`
>
> **Branche de livraison :** `work/r8c-n10-legacy-freeze-new-runtime-cutover-contract`
>
> **Nature :** contrat documentaire et architectural ; aucune implémentation de cutover
>
> **Statut produit :** `LEGACY_FREEZE_AND_NEW_RUNTIME_CUTOVER_CONTRACT_APPROVED`
>
> **Approbation de référence :** commit produit revu `e75a13d16a30bac8f3617459540510e55310c923` ; approuvé sans réserve ; août 2026
>
> **Décision de tranche verticale :** `FIRST_TARGET_VERTICAL_SLICE_SELECTED`

## 1. Décision, portée et autorité

Le runtime historique fondé sur `Season1State`, les providers J01–J21, les
runtime maps par journée, les identifiants métier `jNN_*` et l'enchaînement
séquentiel des jours est désormais classé :

`LEGACY_REFERENCE_ONLY`

Il reste temporairement une version jouable de référence, un corpus narratif
historique, un oracle de comparaison fonctionnelle et une source possible pour
une migration authored hors runtime. Il n'est plus la cible de développement
du produit final.

Le nouveau runtime est la seule cible active. Il prolonge les fondations déjà
présentes : A1–A5 pour le domaine durable et A6–A10 pour l'éligibilité et
l'orchestration. N10 n'autorise ni troisième moteur, ni bridge, ni exécuteur,
ni reducer, ni migration, ni modification d'A1–A10.

Ce document fait autorité sur :

- le statut futur des composants techniques inspectés ;
- le gel du runtime journées ;
- la frontière entre domaine, orchestration et présentation ;
- l'interdiction de double écriture ;
- la direction de migration du contenu ;
- les conditions d'entrée et de sortie du cutover ;
- la feuille de route de remplacement.

Il ne remplace pas les textes canoniques, les voix, les faits narratifs validés,
les contrats N7.1/N8/N9 ni les règles d'audience et de consentement. Il remplace
leur ancienne destination technique : toute implémentation future vise le
contrat authored cible, jamais le runtime journées.

La revue produit a attribué le statut
`LEGACY_FREEZE_AND_NEW_RUNTIME_CUTOVER_CONTRACT_APPROVED` sans réserve.

## 2. Diagnostic conservé

### 2.1 Ce que le runtime journées sait déjà présenter

La chaîne démarrée par `game/project.godot` utilise `PortraitMain.tscn`, puis le
mode `runtime_s1` de `PortraitShell.gd`. Elle sait présenter :

- le shell smartphone portrait et sa navigation ;
- Messages, les fils privés, les choix et les réponses ;
- les notifications, les non-lus et les indicateurs de frappe ;
- les séparateurs et transitions temporelles ou hors téléphone ;
- les messages-images et leur ouverture ;
- Galerie, ses états, ses séquences parentes/enfants et PhotoViewer ;
- une progression cumulative J01–J21 avec snapshots mémoire ;
- une Saison 1 jouable, déterministe et couverte par des smokes historiques.

### 2.2 Pourquoi ce domaine ne doit plus évoluer

`game/scripts/runtime/season_1/Season1State.gd` porte un état central de plus de
4 500 lignes, 108 variables de premier niveau et des milliers d'occurrences
`jNN_*`. `Season1RuntimeProvider.gd` précharge les 21 providers, code les 20
handoffs un par un et sérialise un snapshot contenant l'état central et les
snapshots des 21 journées. Les providers chargent chacun leur map et transportent
les transcripts, choix, médias et phases de la journée précédente.

Cette architecture a fourni une référence jouable utile, mais les jours sont à
la fois calendrier, unité de composition, frontière d'état et identité métier.
Les dépendances croisées rendent une extension fonctionnelle risquée. Aucun
stockage disque général n'existe : les snapshots restent des `Dictionary` en
mémoire.

### 2.3 Ce qu'A1–A10 fournit réellement

- A1 fournit un état transactionnel synthétique, des événements idempotents et
  des relations qualitatives sans score numérique.
- A2 fixe la sémantique produit des scènes, séquences, choix, connaissances,
  traces, promesses, obligations et conséquences.
- A3 fournit définition, instance, éligibilité, résolution et effets bornés.
- A5 fournit registre d'instances et snapshot reconstructible current-only.
- A6 charge des bundles stricts et requête les candidats.
- A7 réserve ou propose explicitement après revalidation.
- A8 gère fenêtres, conflits, fermeture silencieuse et occasion manquée
  uniquement après proposition.
- A9 compose un créneau éphémère et déterministe suivant l'ordre auteur.
- A10 expose une façade mince pour trouver, composer, activer, résoudre,
  sauvegarder en mémoire et restaurer A1/A5.

### 2.4 Ce qui manque réellement

La sémantique produit existe dans A2 et certaines racines existent dans A1,
mais A1 ne traite que deux types d'événements synthétiques. Le codec A5 exige
encore vides les registres `promesses`, `obligations`, `traces_narratives`,
`connaissances` et `livraison_medias`. A1–A10 ne possède actuellement :

- ni contrat unifié de contenu réel consommable au runtime ;
- ni exécuteur de séquences ou curseur de beat/message ;
- ni taxonomie et reducers complets du corpus ;
- ni projection vers Messages ou vers les scènes physiques ;
- ni projection média vers Galerie et PhotoViewer ;
- ni cycle de vie complet des médias et audiences ;
- ni sauvegarde disque, namespace ou reprise player-facing ;
- ni corpus Saison 1 migré ;
- ni bootstrap permettant au jeu de démarrer sans le legacy.

Le besoin n'est donc pas un troisième moteur. Il est la liaison, sans double
écriture, entre A1–A10, un contenu authored unifié et les surfaces joueur déjà
validées.

## 3. Taxonomie obligatoire

Chaque composant pertinent inspecté reçoit exactement une catégorie principale :

| Catégorie | Définition normative |
| --- | --- |
| `LEGACY_REFERENCE_ONLY` | Logique ou contenu exécutable dont l'autorité métier dépend des journées ; référence figée, non extensible. |
| `REUSABLE_PRESENTATION` | Surface joueur ou utilitaire de présentation conservable après inversion de sa source de données. |
| `TARGET_DOMAIN` | Domaine, persistance reconstructible en mémoire et orchestration A1–A10 déjà valides, même encore synthétiques. |
| `TARGET_MISSING` | Brique indispensable au produit final absente ou incomplète. |
| `MIGRATION_SUPPORT_ONLY` | Outil hors runtime autorisé à lire, exporter, comparer ou vérifier ; jamais une dépendance du jeu final. |

La catégorie décrit le rôle futur, pas seulement le répertoire actuel. Un écran
alimenté aujourd'hui par un provider JNN n'est pas legacy par nature. À
l'inverse, un helper UI qui encode `source_day` comme règle métier reste legacy
même s'il est appelé par un écran réutilisable.

## 4. Inventaire autoritatif des composants

### 4.1 `LEGACY_REFERENCE_ONLY`

| Chemin réel ou famille fermée | Fonction actuelle | Fonction future | Sort | Dépendances | Risque de dette |
| --- | --- | --- | --- | --- | --- |
| `game/scripts/runtime/season_1/Season1State.gd` | État métier central, progression, registres, choix, validations et snapshot J01–J21. | Oracle de comportement et source d'analyse hors runtime. | Conserver figé, puis supprimer en phase 6. | Tous les providers ; sélecteurs ; tests JNN. | Très élevé : état massif et identités `jNN_*`. |
| `game/scripts/runtime/season_1/Season1RuntimeProvider.gd` | Façade active, enchaînement des 21 jours, transport des transcripts et snapshots. | Lanceur de la référence jouable uniquement. | Conserver figé, remplacer au cutover, supprimer en phase 6. | `Season1State`, J01–J21, Shell/Messages. | Très élevé : 21 handoffs et protocole UI implicite. |
| `game/scripts/runtime/season_1/J01RuntimeProvider.gd` à `J21RuntimeProvider.gd` | Providers de journée ; chargement des maps, phases, choix, transitions, Galerie et snapshots. | Oracle de service par séquence historique. | Conserver figés, puis supprimer. | Maps, conversations, état central, UI. | Très élevé : règles spécifiques par jour et héritage J14–J21. |
| `game/scripts/runtime/season_1/J10PivotSelector.gd` et `J11ContinuationSelector.gd` | Sélection depuis champs, promesses et traces historiques `jNN_*`. | Cas de comparaison pour les futurs reducers/compositeurs. | Conserver figés, remplacer par règles authored, puis supprimer. | Snapshot `Season1State`. | Élevé : logique transversale indexée par jour. |
| `game/scripts/runtime/season_1/EtatNarratifLecture.gd` | Vue de lecture typée `Season1State`, projection des actes depuis le numéro de jour. | Oracle de debug legacy, sans autorité cible. | Conserver figé, remplacer par vues du nouveau domaine. | `Season1State`. | Élevé : peut masquer une dépendance métier legacy. |
| `game/scripts/runtime/season_1/RuntimeUnread.gd` | Calcul de non-lus à partir de `source_day`. | Référence de comportement seulement. | Remplacer par projection de lecture stable, puis supprimer. | Transcripts legacy et jour source. | Moyen : règle UI simple mais identité temporelle legacy. |
| `game/data/runtime/season_1/j01_runtime_map.json` à `j21_runtime_map.json` | Ordre, fenêtres, chemins de conversations, transitions et présentations Galerie par jour. | Source éditoriale et oracle de parité hors runtime. | Archiver après migration ; ne jamais charger dans le build cible. | Providers JNN, conversations, visual content. | Très élevé : topologie de journée devenue non normative. |
| `game/data/conversations/*.json` | 46 conversations jouées, messages, choix et branches du corpus historique. | Corpus source à trier `MIGRATE_AS_IS`, `REWRITE_FOR_AUTHORED_SEQUENCE` ou `DROP_OR_ARCHIVE`. | Conserver comme référence jusqu'à décision contenu par contenu ; aucun chargement cible direct. | Maps et providers. | Élevé : structure `chapter_*`, jours et effets hors fichier. |
| `game/data/visual_content/*.json` et `game/assets/visual_content/**` | Manifestes, placeholders et prototypes visuels servis ou inspectés par le legacy. | Sources de migration média ; un fichier n'entre dans la cible qu'après contrat média explicite. | Auditer, réenregistrer dans le contrat cible ou archiver. | Maps, `DataLoader`, `VisualMediaResolver`. | Élevé : présence physique ne prouve ni audience ni disponibilité. |
| `game/tests/RUNTIME_S1_*`, `tests/test_runtime_s1_*`, `tools/test_runtime_s1_*` | Smokes, scènes et gardes statiques du comportement historique. | Suite de compatibilité/oracle de parité. | Conserver/reclasser ; supprimer cas par cas après remplacement couvert. | Tous les composants legacy. | Moyen à élevé si les gardes bloquent des fichiers UI partagés. |
| `game/tests/R8BNarrativeStateSummarySmoke*` et tests de lecture dépendant de `Season1State` | Résumés/debug de l'état legacy. | Référence de lecture historique. | Reclasser en compatibilité, remplacer, puis supprimer. | `EtatNarratifLecture`, `Season1State`. | Moyen. |

`game/scripts/runtime/season_1/NarrativeTime.gd` n'est pas classé legacy : il
parse et formate seulement `HH:MM`, sans lire l'état ni un jour. Il appartient à
la présentation réutilisable, malgré son emplacement actuel.

### 4.2 `REUSABLE_PRESENTATION`

| Chemin réel ou famille fermée | Fonction actuelle | Fonction future | Sort | Dépendances | Risque de dette |
| --- | --- | --- | --- | --- | --- |
| `game/scenes/portrait/PortraitMain.tscn`, `game/scripts/ui/PortraitMain.gd` | Entrée du jeu portrait en mode `runtime_s1`. | Entrée player-facing du nouveau runtime. | Adapter la composition et le mode de démarrage ; conserver la scène si le couplage reste borné. | `PortraitShell`. | Moyen : mode actif explicitement legacy. |
| `game/scenes/portrait/PortraitShell.tscn`, `game/scenes/portrait/PortraitShellDemo.tscn`, `game/scripts/ui/PortraitShell.gd`, `PortraitShellDemo.gd`, `PortraitShellTheme.gd`, `SafeAreaContainer.gd` | Shell, thème, safe area, onglets, navigation, ouverture/retour PhotoViewer ; le mode production instancie le provider legacy. | Shell neutre alimenté par ports de projection cible. | Conserver ; extraire le preload et les callbacks legacy. | Messages, Galerie, PhotoViewer, provider. | Élevé mais localisé dans l'assemblage. |
| `game/scenes/portrait/messages/MessagesScreen.tscn`, `game/scripts/ui/messages/MessagesScreen.gd` | Orchestration des fils, livraisons, choix, temps et appels directs au provider. | Consommateur d'un contrat Messages et émetteur d'intentions joueur. | Adapter le protocole injecté ; préserver le rendu et les comportements. | `presentation_source`, `apply_choice`, transitions, Galerie legacy. | Élevé : provider non typé à plusieurs méthodes. |
| `game/scenes/portrait/messages/PortraitConversationScreen.tscn`, `game/scripts/ui/messages/ConversationList.gd`, `PortraitConversationScreen.gd`, `MessageTimeline.gd`, `ChoiceBar.gd` | Liste, fil, timeline et choix à partir de dictionnaires. | Rendus purs des projections cible. | Conserver avec adaptation minimale de forme si nécessaire. | Source Messages injectée. | Faible à moyen. |
| `game/scripts/ui/messages/NotificationBanner.gd`, `UnreadDivider.gd`, `TypingIndicator.gd` | Notifications et états de présentation. | Rendu des notifications/non-lus persistés par le nouveau runtime. | Conserver ; déplacer l'autorité de l'état vers la projection cible. | État local actuel de `MessagesScreen`. | Moyen : notification actuellement presentation-only. |
| `game/scenes/portrait/messages/TimePassageOverlay.tscn`, `game/scripts/ui/messages/OffPhoneTransition.gd`, `DayTransition.gd`, `TimePassageOverlay.gd`, `DayDivider.gd` | Transitions et séparateurs temporels. | Projection diégétique du temps, sans identité métier par jour. | Conserver ; fournir des DTO temporels stables. | Dictionnaires de transition legacy. | Moyen : noms `Day*` acceptables comme projection, pas comme domaine. |
| `game/scripts/runtime/season_1/NarrativeTime.gd` | Parsing/formatage pur du temps narratif. | Utilitaire de projection temporelle. | Conserver ou déplacer sans conserver une dépendance au dossier legacy. | `MessagesScreen` et providers. | Faible. |
| `game/scripts/ui/messages/ImageMessage.gd` | Rendu et ouverture d'un média dans un message. | Vue d'une projection média accessible. | Conserver. | `media_ref`, Shell, resolver. | Faible si l'accès est décidé en amont. |
| `game/scenes/portrait/gallery/GalleryScreen.tscn`, `game/scripts/ui/gallery/GalleryScreen.gd`, `GalleryTile.gd`, `CharacterTabs.gd` | Galerie, groupes, états, focus et marquage local `is_new`. | Journal des médias accessibles projeté par le nouveau domaine. | Conserver ; l'autorité `is_new`/accès sort de la copie UI. | `gallery_source` legacy. | Moyen. |
| `game/scenes/portrait/gallery/PhotoViewer.tscn`, `game/scripts/ui/gallery/PhotoViewer.gd` | Viewer générique pour sources `messages`, `gallery`, `scene`. | Viewer du contrat média cible. | Conserver ; valider l'accès fourni par la projection cible. | Shell, Galerie, Messages. | Faible à moyen. |
| `game/scripts/ui/media/VisualMediaResolver.gd` | Résolution de livré/placeholder/non livré et chargement de texture. | Résolution technique après autorisation métier d'accès. | Conserver ; interdire qu'il déduise audience ou disponibilité narrative. | `DataLoader`, manifestes visuels. | Moyen. |
| `game/scripts/ui/messages/MessagesDemoData.gd`, `game/scripts/ui/gallery/GalleryDemoData.gd` | Fixtures de démonstration UI. | Fixtures de non-régression présentation. | Conserver hors production. | Écrans UI. | Faible. |
| `game/tests/T_UI_*`, `tests/test_t_ui_*`, `game/tests/VisualDeliveryPipelineSmoke*`, `tests/test_visual_delivery_pipeline_static.py` | Preuves autonomes du shell, Messages, transitions, Galerie et PhotoViewer. | Suite de non-régression des surfaces réutilisées. | Conserver ; compléter plus tard avec une source cible. | UI et fixtures demo. | Faible. |
| `game/tests/UI_MSG_04*`, `tests/test_ui_msg_04*`, `tools/test_ui_msg_04*` | Tests UI montant aujourd'hui `PortraitMain`/runtime_s1. | Tests de présentation après recâblage. | Adapter lors du cutover, sans figer le provider historique. | Entrée production legacy. | Moyen. |
| `game/tests/R8CA4FinalPortraitUXSmokeDriver.gd`, `game/tests/R8CA4FinalPortraitUXSmokeTest.tscn`, `tools/test_r8c_a4_final_portrait_ux.sh` | Smoke A4 principalement player-facing : `PortraitMain`, Shell, Messages, Galerie, PhotoViewer et navigation, avec dépendances legacy de montage. | Non-régression des surfaces de présentation lors du recâblage cible. | Conserver dans la suite présentation ; ne pas le classer comme preuve du domaine A1–A10. | UI portrait et runtime legacy actuel. | Moyen : son préfixe A4 ne décrit pas une preuve de domaine. |

### 4.3 `TARGET_DOMAIN`

| Chemin réel ou famille fermée | Fonction actuelle | Fonction future | Sort | Dépendances | Risque de dette |
| --- | --- | --- | --- | --- | --- |
| `game/scripts/narrative_state/EtatNarratif.gd` | État A1, enveloppe d'événements, idempotence, racines réservées. | Source de vérité du domaine durable. | Conserver et étendre seulement dans les futurs lots autorisés. | États relationnels, reducer. | Moyen : types encore synthétiques. |
| `game/scripts/narrative_state/EtatRelation.gd` et `EtatRelationCentrale.gd` | Relations qualitatives et invariants sans score. | Sous-états relationnels cible. | Conserver. | A1 et reducers. | Faible si les champs restent qualitatifs. |
| `game/scripts/narrative_state/ReducerRelation.gd` | Reducer des deux événements synthétiques A1. | Une famille de reducers cible, non un reducer universel. | Conserver ; compléter par reducers dédiés futurs. | `EtatNarratif`. | Moyen : couverture métier incomplète. |
| `game/scripts/narrative_scene/SceneDefinition.gd`, `SceneInstance.gd`, `MinimalSceneEngine.gd` | Contrat fermé A3, cycle d'instance, résolution transactionnelle. | Noyau de scène sous l'exécuteur de séquence. | Conserver et intégrer, sans lui faire porter transcripts ou Saison 1 entière. | A1, A5. | Moyen : contrat de scène plus étroit que le contenu authored unifié. |
| `game/scripts/narrative_scene/PersistentSceneRegistry.gd`, `A5NarrativeStateCodec.gd` | Registre et snapshot reconstructible current-only. | Partie domaine du nouveau snapshot. | Conserver ; faire évoluer par version dans un lot séparé. | A1/A3. | Élevé tant que cinq registres doivent rester vides. |
| `game/scripts/narrative_scene/NarrativeSceneLibrary.gd` | Loader et requête A6 stricts par chemin explicite. | Bibliothèque validée des définitions/projections A6. | Conserver ; ne pas en faire le contrat authored complet. | `DataLoader`, A3. | Moyen : pas de catalogue Saison 1 actif. |
| `game/scripts/narrative_scene/CandidateReservationProposalCoordinator.gd` | A7, revalidation et intention explicite. | Frontière proposition du nouveau runtime. | Conserver. | A6/A3/A5. | Faible à moyen. |
| `game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd` | A8, fenêtres/conflits et non-sélection correcte. | Orchestration des opportunités. | Conserver ; persistance/reconstruction à cadrer. | A7/A6/A5. | Moyen : fenêtres seulement en mémoire. |
| `game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd` | A9, plan éphémère `earliest-fit`. | Composition contrôlée issue de l'ordre auteur. | Conserver comme calcul, pas comme calendrier Saison. | A8. | Faible à moyen. |
| `game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd` | A10, façade A1–A9 et snapshot A5 mémoire. | Façade d'orchestration sous l'exécuteur. | Conserver ; ne pas y ajouter contenu, UI ou second domaine. | A1–A9. | Moyen : reprise d'activation éphémère. |
| `game/data/narrative_scenes/r8c_a6_prototype_library.json` | Trois définitions synthétiques A6. | Fixture de contrat, pas corpus produit. | Conserver comme fixture ou déplacer plus tard vers les tests. | A6. | Faible si non indexé en production. |
| `game/tests/R8CANarrativeStateSmokeTest.gd` et `.tscn`, `tests/test_r8c_a1_narrative_state_static.py` | Preuves automatisées A1. | Régression du domaine durable. | Conserver. | A1. | Faible. |
| `game/tests/R8CAMinimalScenePrototypeSmokeTest.gd` et `.tscn`, `tests/test_r8c_a3_minimal_scene_prototype_static.py` | Preuves automatisées A3. | Régression du noyau de scène cible. | Conserver. | A1–A3. | Faible. |
| `game/tests/R8CAPersistentSceneRegistrySmokeTest.gd` et `.tscn`, `tests/test_r8c_a5_persistent_scene_registry_static.py` | Preuves automatisées A5. | Régression du registre et du codec cible. | Conserver. | A1, A3, A5. | Faible. |
| `game/tests/R8CAMinimalNarrativeLibrarySmokeTest.gd` et `.tscn`, `tests/test_r8c_a6_minimal_narrative_library_static.py` | Preuves automatisées A6. | Régression de la bibliothèque cible. | Conserver. | A1, A3, A6. | Faible. |
| `game/tests/R8CACandidateReservationProposalSmokeTest.gd` et `.tscn`, `tests/test_r8c_a7_candidate_reservation_proposal_static.py` | Preuves automatisées A7. | Régression de la proposition/réservation cible. | Conserver. | A1, A3, A6, A7. | Faible. |
| `game/tests/R8CAOpportunityWindowsExclusiveConflictsSmokeTest.gd` et `.tscn`, `tests/test_r8c_a8_opportunity_windows_exclusive_conflicts_static.py` | Preuves automatisées A8. | Régression des fenêtres et conflits cible. | Conserver. | A1, A3, A6–A8. | Faible. |
| `game/tests/R8CAControlledNarrativeSlotCompositionSmokeTest.gd` et `.tscn`, `tests/test_r8c_a9_controlled_narrative_slot_composition_static.py` | Preuves automatisées A9. | Régression de la composition cible. | Conserver. | A1, A3, A6–A9. | Faible. |
| `game/tests/R8CAVerticalSliceOrchestrationSmokeTest.gd` et `.tscn`, `tests/test_r8c_a10_vertical_slice_orchestration_static.py` | Preuves automatisées A10. | Régression de la façade d'orchestration cible. | Conserver. | A1, A3, A5–A10. | Faible. |
| `game/scripts/core/DataLoader.gd` | Lecture JSON partagée par runtime et A6. | Infrastructure technique de chargement validé. | Conserver si les callers cibles bornent leurs chemins et formats. | Données JSON. | Faible à moyen. |

A2 est un contrat sans test automatisé dédié. A4 ne possède pas de famille de
test de domaine distincte dans le dépôt : le smoke préfixé A4 inventorié en
`REUSABLE_PRESENTATION` vérifie l'UX portrait et ses projections, pas le domaine.
Cette absence n'autorise ni à classer l'UI comme `TARGET_DOMAIN`, ni à élargir
les familles ci-dessus par des motifs englobant A4 UI ou A11.

### 4.4 `TARGET_MISSING`

| Brique absente ou incomplète | Fonction cible | Dépendances | Risque de dette si mal bornée |
| --- | --- | --- | --- |
| Contrat de contenu unifié versionné | Réunir identité, mouvement, beats, dialogues, choix, médias, effets et non-déclenchement. | Canon, A2, A6, outils auteur. | Très élevé si un second schéma métier concurrence A1–A10. |
| Registre/catalogue de séquences authored réelles | Charger un corpus cible validé sans scanner le legacy. | Contrat unifié, validation auteur. | Élevé si le catalogue devient un calendrier JNN. |
| Exécuteur de séquences | Avancer, reprendre, projeter et appliquer les effets exactement une fois. | Contrat unifié, A10, projections. | Très élevé si règles Saison ou reducers sont recodés dedans. |
| Taxonomie d'événements et reducers réels | Traiter connaissances, traces, promesses, obligations, conséquences et médias. | A1/A2, registres canoniques N8/N9. | Très élevé si un reducer monolithique remplace `Season1State`. |
| Projection Messages et port d'intentions | Alimenter fils/transcripts/choix et recevoir lecture/choix sans provider JNN. | Exécuteur, état de projection, UI Messages. | Élevé si la projection devient une seconde vérité. |
| Projection scènes/beats physiques | Présenter transitions et beats hors téléphone, puis reprendre l'exécution. | Exécuteur, Shell/overlays/PhotoViewer. | Élevé si elle réimplémente l'état de séquence. |
| Projection notifications et non-lus | Persister livraison, lecture et notifications en attente. | Messages, sauvegarde cible. | Moyen. |
| Projection temporelle | Convertir contraintes authored en jours/heures diégétiques sans en faire l'identité. | Contrat authored, A8/A9, UI transitions. | Élevé si `jNN_*` réapparaît comme domaine. |
| Registre et lifecycle média | Définition, production, détention, audience, accès, retrait, diffusion et conséquences. | Reducers, Messages, Galerie, PhotoViewer. | Très élevé si Galerie est prise pour l'audience. |
| Sauvegarde disque du nouveau runtime | Namespace, écriture atomique, version, reprise exacte et validation. | A1/A5, exécuteur, projections, médias. | Très élevé : corruption ou snapshots hybrides. |
| Bootstrap/cutover du jeu | Démarrer le nouveau runtime sans charger le legacy. | Toutes les briques player-facing de phase 1–2. | Très élevé si fallback silencieux. |
| Corpus Saison 1 migré mouvement par mouvement | Rendre la saison cible jouable sans providers/maps JNN. | Contrat authored, outils migration, validation produit. | Très élevé si migration mécanique 1:1. |
| Suite de parité et critères de dépréciation | Comparer comportements utiles, puis retirer les gardes legacy devenues nuisibles. | Tests legacy et nouveaux tests player-facing. | Moyen. |

### 4.5 `MIGRATION_SUPPORT_ONLY`

| Chemin réel ou famille fermée | Fonction actuelle | Fonction future | Sort | Dépendances | Risque de dette |
| --- | --- | --- | --- | --- | --- |
| `narrative_tool/a11/**` | Planification, brouillons, calibration, exports A6 et rapports Sandra. | Atelier authored et support de migration hors runtime. | Conserver hors build ; exports soumis au contrat cible et à revue humaine. | Canon, profils, A6. | Élevé s'il devient une source runtime implicite. |
| `tests/test_r8c_a11_authoring_workshop.py`, `tests/test_r8c_a11_2_voice_relationship_calibration.py`, `tests/test_r8c_a11_3_assisted_scene_planning.py`, `tests/test_r8c_a11_4_plan_draft_a6_export.py`, `tests/test_r8c_a11_5_first_editorial_scene_pilot.py` | Gardes de l'atelier, des rapports, des comparaisons et des exports A11. | Validation hors ligne du support de migration authored. | Conserver hors suite du runtime cible. | `narrative_tool/a11`, `tools/a11_*.py`. | Faible si leur portée hors runtime reste explicite. |
| `game/tests/R8CA11AuthoringExportSmokeTest.gd` et `.tscn`, `game/tests/R8CA114PlanDraftA6ExportSmokeTest.gd` et `.tscn`, `game/data/narrative_scenes/r8c_a11_4_sandra_recontact_after_silence_export.json`, `game/data/narrative_scenes/r8c_a11_sandra_last_lunch_export.json` | Smokes et fixtures d'exports A11 ; ils prouvent la lisibilité technique d'un export, pas son activation produit. | Validation hors ligne du pipeline auteur/migration. | Conserver hors catalogue et bootstrap produit. | A6/A11. | Moyen si un export est pris pour du contenu canonique activé. |
| `tests/test_r8c_n2_sandra_blue_chairs_revision.py`, `tests/test_r8c_n5_sandra_blue_chairs_staged_projection.py`, `game/tests/R8CN5SandraBlueChairsStagedProjectionSmokeTest.gd` et `.tscn`, `game/data/narrative_scenes/r8c_n5_sandra_blue_chairs_staged.json` | Comparaison, projection et harness staged « Chaises bleues », avec lecture de sources legacy et activation explicite de fixture. | Pilote technique et oracle de migration hors runtime produit. | Conserver staged ; ne pas le classer comme preuve player-facing ni l'activer par bridge legacy. | N2/N5, A1/A6–A10, corpus legacy. | Moyen : le harness traverse le domaine cible sans constituer une tranche produit. |
| `narrative_tool/routes/**`, `memory/**`, `scene_contracts/**`, `benchmarks/**`, `drafts/**`, `reviews/**`, `reports/**` | Analyse éditoriale, mémoire, QA et provenance historiques. | Sources de comparaison et de réécriture. | Conserver/archiver selon autorité ; jamais charger au runtime final. | Corpus et outils Python. | Moyen : statuts hétérogènes et doublons. |
| `tools/a11_*.py` | CLI d'atelier et d'export. | Génération/validation hors ligne du contenu authored. | Conserver comme tooling. | `narrative_tool/a11`. | Faible si aucune dépendance production. |
| `tools/*check*.py`, `tools/*report*.py`, `tools/simulate_route_paths.py`, `tools/scenario_pivot_check.py`, `tools/run_dialogue_qa.py` | QA, simulations et rapports sur corpus. | Comparaison, parité et rapports de migration. | Conserver hors runtime ; adapter aux sources cibles dans des lots dédiés. | Documents et JSON historiques. | Moyen : une règle historique peut être prise pour le canon cible. |
| `narrative_tool/templates/**` | Gabarits d'auteur et contrats de mémoire. | Aide à la conversion vers le contrat authored unifié. | Réviser hors N10 lorsque le contrat cible sera implémenté. | Outils auteur. | Faible à moyen. |

## 5. Politique normative de gel du legacy

### 5.1 Modifications interdites par défaut

Dans `LEGACY_REFERENCE_ONLY`, il est interdit d'ajouter :

- une scène, un dialogue final, un payoff ou un aftercare ;
- un provider, une journée ou une runtime map ;
- un champ narratif de `Season1State` ;
- une règle relationnelle ou une identité métier `jNN_*` ;
- un média final ou une nouvelle règle Galerie ;
- une sauvegarde générale ;
- une intégration A1–A10, un bridge ou une abstraction métier.

Les payoffs W4, l'aftercare Sandra re-projeté, J21 enrichi et
`s1_m5_marie_player_final_conversation` seront implémentés dans le nouveau
système uniquement.

### 5.2 Exceptions correctives

Une modification legacy n'est admissible que dans un lot explicitement
autorisé et strictement correctif, pour :

- un crash ;
- une corruption d'état ;
- une régression empêchant d'utiliser la référence jouable ;
- une faille critique de persistance ;
- une erreur bloquant la comparaison avec le nouveau runtime.

Le lot doit nommer la baseline, le défaut, les fichiers exacts, la preuve de
non-extension fonctionnelle et la date de retrait prévue. Une correction ne
peut créer ni contenu, ni champ métier, ni bridge, ni dépendance cible vers le
legacy.

### 5.3 Tests legacy

Les tests legacy restent exécutables comme oracle. Ils peuvent être conservés,
reclassés dans une suite de compatibilité ou déplacés ultérieurement. Un test
peut être supprimé seulement lorsque le comportement correspondant est remplacé,
couvert depuis le nouveau runtime et explicitement déprécié.

Les gardes historiques ne doivent pas interdire une évolution légitime d'un
composant `REUSABLE_PRESENTATION`. Lorsqu'un test mélange contrat UI et provider
JNN, la partie UI doit être re-projetée vers une fixture cible avant retrait de
la garde legacy.

## 6. Interdiction de double écriture

> Une action joueur ne doit jamais écrire simultanément dans `Season1State` et
> dans le nouveau domaine A1–A10.

Sont interdits :

- la synchronisation bidirectionnelle ;
- un shadow state permanent ;
- la réplication d'un événement ou choix dans les deux systèmes ;
- un adaptateur général maintenant deux vérités ;
- un fallback silencieux vers le legacy ;
- la lecture de `Season1State` comme autorité métier après activation cible ;
- une sauvegarde contenant à la fois un snapshot legacy et un snapshot cible ;
- une projection UI qui arbitre entre les deux sources pendant une même partie.

La seule direction autorisée est :

```text
contenu legacy lu hors runtime
  → décision éditoriale
  → contenu authored cible validé
  → nouveau runtime
```

Elle n'est jamais :

```text
runtime legacy ↔ runtime cible
```

Un outil `MIGRATION_SUPPORT_ONLY` peut lire le legacy et produire un export ou
un rapport. Il ne peut être appelé par le build final. Après cutover, le nouveau
jeu fonctionne lorsque tous les fichiers legacy sont absents du paquet.

## 7. Architecture cible

La chaîne normative est :

```text
Saison
  → mouvement dramatique
  → séquence authored
  → contrat de contenu unifié
  → bibliothèque A6
  → éligibilité A7
  → fenêtres A8
  → composition A9
  → façade A10
  → exécuteur de séquence
  → événements et reducers A1–A5
  → projections joueur
```

Les couches ont des responsabilités non interchangeables :

- le contrat authored décrit le contenu et ses effets déclarés ;
- A6–A10 sélectionne, propose, compose et résout sans porter le transcript ;
- l'exécuteur avance une séquence et orchestre les projections ;
- A1–A5 reste l'autorité durable ;
- les projections rendent un état joueur dérivé et reçoivent des intentions ;
- les composants UI ne décident ni éligibilité, ni audience, ni conséquence.

### 7.1 Contrat de contenu unifié

Une séquence authored réelle doit pouvoir représenter, dans un format versionné
et strictement validé :

| Domaine | Contenu obligatoire ou autorisé |
| --- | --- |
| Identité | Identité canonique stable, version, mouvement dramatique, fonction narrative. |
| Participants | Participants, rôles, présences, locuteurs et accès aux faits. |
| Déclenchement | Préconditions, exclusions, fenêtre et contraintes temporelles. |
| Déroulé | Beats, dialogues, messages, choix, réceptions, résolutions, convergence, beats physiques et sorties. |
| Domaine durable | Événements produits, connaissances, traces, promesses, obligations et conséquences. |
| Média | Définitions, statut de production, diégèse, propriétaire/détenteur, audience, accès, retrait, diffusion et liens de scène/aftercare. |
| Continuité | Création/évolution des audiences, aftercares, retours ultérieurs et reprise. |
| Non-déclenchement | Conditions, fermeture silencieuse, annulation et conséquence seulement si une proposition réelle l'autorise. |

Le contrat authored ne remplace pas `SceneDefinition` A3. Il contient la matière
player-facing et projette la partie pertinente vers A6/A3. Les jours et heures
sont des propriétés de projection ; ils ne composent jamais l'identité stable.

### 7.2 Exécuteur de séquences

Le futur exécuteur doit :

- charger une séquence authored validée et sa version exacte ;
- ouvrir la projection appropriée : Messages, beat physique ou média ;
- conserver un curseur exact et reprendre au même point ;
- appliquer une intention joueur une seule fois ;
- produire les événements déclarés et appeler les reducers concernés ;
- enregistrer résolution, sortie et projections en attente ;
- préserver l'idempotence après sauvegarde/reprise ;
- distinguer contenu, orchestration, projection et état durable.

Il ne doit pas :

- réimplémenter A1–A10 ;
- créer un second domaine ou un reducer universel ;
- stocker des scores relationnels ;
- connaître les 21 jours ou la totalité de la Saison 1 ;
- contenir de règles spéciales par séquence sous forme de code ;
- lire `Season1State`, une map JNN ou un provider JNN.

### 7.3 Projections joueur

Les projections cible couvrent Messages, choix, notifications, non-lus,
transitions temporelles, beats hors téléphone, médias de conversation, Galerie
et PhotoViewer. Elles sont reconstructibles depuis le domaine, le curseur de
séquence et les événements de présentation persistés. Elles ne sont jamais une
seconde autorité métier.

## 8. Réutilisation des surfaces joueur

| Surface | Composant réutilisable | Dépendance legacy actuelle | Contrat cible nécessaire | Adaptation minimale | Risque | Test de non-régression futur |
| --- | --- | --- | --- | --- | --- | --- |
| Shell/navigation | `PortraitMain`, `PortraitShell` | Mode `runtime_s1`, preload `Season1RuntimeProvider`. | Bootstrap cible + ports Messages/Galerie/Viewer/transitions. | Injecter une source cible et retirer les callbacks JNN. | Moyen. | Démarrage sans legacy, navigation/focus identiques. |
| Liste Messages | `MessagesScreen`, `ConversationList` | `presentation_source()` du provider. | Projection `characters`, `threads`, previews, non-lus. | Remplacer le provider par une interface d'intentions/projections. | Élevé. | Ordre, preview, badges, lecture et retour. |
| Fil privé | `PortraitConversationScreen`, `MessageTimeline` | Transcript et `source_day`; marquage provider. | Messages ordonnés, instant diégétique, état de livraison/lecture. | Remplacer `source_day` comme identité par une projection temporelle. | Moyen. | Bulles, rafales, séparateurs, position de lecture. |
| Choix | `ChoiceBar` | `apply_choice(thread_id, choice_id)`. | Intent `select_choice(sequence_instance_id, choice_id, action_id)`. | Émettre l'intention, rendre la projection résultante. | Moyen. | Un clic, une bulle Player, aucun double effet. |
| Notifications/non-lus | `NotificationBanner`, `UnreadDivider` | État partiellement local, `RuntimeUnread`, IDs présentés. | Livraisons et accusés persistés, notifications en attente. | Rendre l'état cible et accuser par ID stable. | Moyen. | Reprise avec badge/notification exacts, aucun doublon. |
| Temps/transitions | `TimePassageOverlay`, `OffPhoneTransition`, `DayTransition`, `DayDivider`, `NarrativeTime` | `commit_narrative_time`, `confirm_*`, jours du provider. | Projection temporelle et intention de confirmation. | Conserver les vues, remplacer les commandes du provider. | Moyen. | Ordre des phases, focus, lisibilité, temps repris. |
| Beat physique | Overlays et séquences Viewer existantes | `pending_scene_sequence`, `confirm_scene_sequence`, cas J11. | Projection de beat physique avec cursor/ack. | Généraliser le port sans généraliser le domaine. | Élevé. | Entrée/sortie, interruption, reprise exacte. |
| Image-message | `ImageMessage`, `VisualMediaResolver` | `media_ref` issu des conversations/maps. | Projection média autorisée avec statut et provenance. | Garder le rendu, vérifier accès en amont. | Moyen. | Fallback technique sans déblocage indu. |
| Galerie | `GalleryScreen`, `GalleryTile`, `CharacterTabs` | `gallery_source()` et IDs cumulés du provider. | Projection des médias accessibles, groupes et nouveauté persistée. | Remplacer source et mutation locale de `is_new`. | Élevé. | Locked/unlocked/removed, groupes, tri, badge. |
| PhotoViewer | `PhotoViewer` | Callback `mark_photo_opened`, provenance provider. | Projection de consultation autorisée + intention `media_viewed`. | Conserver navigation et focus ; déplacer l'effet dans le domaine. | Moyen. | Message/Galerie/scène, séquence, retour et accès refusé. |

La préférence produit est de conserver ces surfaces et de remplacer leur source.
Une réécriture n'est justifiée que si un test démontre un couplage impossible à
extraire sans reproduire le legacy.

## 9. Cycle de vie média cible

Chaque média possède une identité stable distincte du fichier physique. Son
cycle de vie doit représenter explicitement :

1. la définition authored et la fonction narrative ;
2. le statut de production (`SPECIFIED`, `PRODUCED`, `VALIDATED`, par exemple,
   selon une taxonomie future approuvée) ;
3. la disponibilité technique du fichier ;
4. la création diégétique ou la nature non diégétique ;
5. le propriétaire, le détenteur et la source ;
6. l'audience autorisée et ses évolutions sourcées ;
7. l'accès du joueur ;
8. l'apparition dans Messages ;
9. l'admissibilité séparée dans Galerie ;
10. la consultation dans PhotoViewer ;
11. le retrait, la perte d'accès ou la suppression diégétique ;
12. la diffusion et son audience exacte ;
13. les conséquences et obligations associées ;
14. le lien avec une scène, une résolution ou un aftercare.

Règles normatives :

- un média non diégétique peut récompenser le joueur sans exister dans la
  fiction ;
- la présence en Galerie ne prouve ni propriété, ni détention, ni audience ;
- Galerie est un journal d'accès joueur, pas un distributeur ;
- PhotoViewer vérifie une projection d'accès, il ne la crée pas ;
- un fichier présent sur disque n'est jamais une permission narrative ;
- retrait, absence et non-production sont trois états distincts ;
- un média jamais atteint ne peut être révélé par miniature, reprise ou J21.

## 10. Sauvegarde et reprise cible

Le nouveau runtime possède son propre namespace de sauvegarde. Son snapshot
versionné et validé contient au minimum :

- le domaine A1–A5 reconstructible ;
- les instances de séquences et leurs versions authored ;
- la position exacte dans chaque séquence active ;
- les intentions appliquées et quittances nécessaires à l'idempotence ;
- les projections en attente et accusés de présentation ;
- les médias accessibles, retirés et leurs audiences ;
- les notifications et non-lus ;
- les informations temporelles de projection nécessaires à la reprise.

L'écriture disque devra être atomique et refuser un snapshot incohérent ou d'une
version non supportée. Elle ne contient aucun snapshot `Season1State` et ne lit
aucun namespace legacy. Les anciennes sauvegardes ne sont pas promises comme
compatibles. Un éventuel import legacy est un lot séparé, optionnel et non
bloquant pour le nouveau runtime.

## 11. Stratégie de migration du contenu

Le corpus J01–J21 est une source éditoriale, pas un format cible. Chaque unité
candidate reçoit une décision humaine explicite :

| Décision | Usage |
| --- | --- |
| `MIGRATE_AS_IS` | Voix, faits, fonction et structure sont compatibles ; seule la projection technique change. |
| `REWRITE_FOR_AUTHORED_SEQUENCE` | Le contenu reste valable mais son ordre, ses effets ou son identité dépendent trop des jours/providers. |
| `DROP_OR_ARCHIVE` | Contenu redondant, obsolète, cosmétique sans fonction ou incompatible avec le canon actuel. |

La migration ne copie pas automatiquement tous les messages, branches,
identifiants, jours ou traces techniques. Elle conserve prioritairement :

- voix et dynamiques relationnelles validées ;
- fonctions dramatiques ;
- faits canoniques et conséquences ;
- scènes fortes et choix réellement significatifs ;
- médias utiles, leur diégèse et leurs audiences ;
- promesses, obligations et aftercares qui ont une fonction future.

Les séquences peuvent être fusionnées, déplacées, subdivisées ou réécrites. Les
outils hors runtime peuvent extraire et comparer, mais toute sortie doit être
relue et validée. Les identifiants canoniques cible ne reprennent `jNN_*` que
comme alias de provenance, jamais comme identité métier.

## 12. Première tranche verticale : analyse et décision

La tranche doit prouver une chaîne joueur complète, pas un smoke data-only.

### 12.1 Sandra — « Les chaises bleues »

| Exigence | Couverture existante | Verdict |
| --- | --- | --- |
| Séquence authored réelle | Source N2/A11 verrouillée, 89/90 bulles selon parcours. | Partiel : source séparée du bundle runtime. |
| Entrée A6 | `sandra_blue_chairs_definition` staged. | Oui. |
| Éligibilité A7 | Exercée par le smoke avec prérequis synthétiques. | Oui en harness, pas depuis le domaine réel. |
| Fenêtre A8 | 16:30–18:05, fermeture silencieuse avant proposition. | Oui en harness. |
| Composition A9 | Implantation 16:30–18:00. | Oui en harness. |
| Activation A10 | Chargement explicite tests/smoke seulement. | Oui en harness, non joueur. |
| Projection Messages | Les bulles ne sont pas représentables dans le schéma A6. | Non. |
| Choix | Deux choix et deux réceptions locales. | Oui dans A6, non player-facing. |
| Résolution | A5/A10 `RESOLVED`. | Oui en harness. |
| Événement durable | Fait commun ajouté par un helper après résolution. | Partiel : hors résolution et sans bridge runtime. |
| Retour ultérieur | Incompatibilité J05 décrite et simulée. | Non player-facing ; bridge explicitement absent. |
| Média | `photo_sandra_cafe_blue_chairs`, causal au premier message. | Non : `ASSET_REQUIRED_NOT_READY`. |
| Audience/lifecycle | Aucun propriétaire, audience, retrait ou diffusion structuré. | Non. |
| Galerie | N5 interdit toute entrée automatique. | Non ; changer ce choix exige une décision produit. |
| PhotoViewer | Aucun média accessible ni projection. | Non. |
| Sauvegarde/reprise | Snapshot A10 utilisé, aucun `restore_state` spécifique ni curseur de bulles. | Non. |
| Aucune lecture/écriture legacy | Le staged n'en fait aucune. | Oui aujourd'hui, précisément parce qu'il n'est pas activé. |

Conclusion : « Les chaises bleues » est le meilleur révélateur de l'écart entre
contenu authored, A6–A10 et surfaces joueur. Elle ne peut toutefois pas couvrir
la tranche complète avec les données et décisions existantes. Lui donner une
entrée Galerie contredirait son contrat actuel de média conversation-only et
constituerait une décision narrative/produit nouvelle, interdite en N10.

Son statut est donc `TECHNICAL_ORCHESTRATION_PILOT` : le staged demeure une
fixture technique de comparaison et d'orchestration, pas la première tranche
player-facing.

### 12.2 Statuts des candidats réels

La tranche sélectionnée et le candidat de suivi sont classés ainsi :

| Candidat | Statut | Couverture déjà prouvée dans le legacy | Manques pour la cible | Coût relatif | Couverture attendue |
| --- | --- | --- | --- | --- | --- |
| Sandra J01 — `chapter_01_sandra_trace` / photo du déjeuner | `FOLLOW_UP_MESSAGES_SLICE_CANDIDATE` | Messages, vrai choix, image-message, PhotoViewer, observation idempotente, trace/connaissance, snapshot/reprise et retour J05/J10. | Aucun A6–A10 ; Galerie J01 vide ; asset final absent ; tout effet est dans `Season1State`. | Moyen pour authored/domain, élevé si Galerie doit être ajoutée car elle n'existe pas dans le comportement actuel. | Bonne candidate de suivi simplifiée pour Messages, choix, viewer, reprise et retour ; insuffisante pour Galerie sans nouvelle décision. |
| Mathilde J11 M-B3 — projection temporelle legacy `MATHILDE_J11_SECRET_INTIMACY` | `FIRST_TARGET_VERTICAL_SLICE_SELECTED` | Messages/choix, séquence physique, triplet média, Galerie parent/enfants, PhotoViewer, trace/fait, obligation/aftercare, retours J12/J13 et checkpoints exacts. | Aucun A6–A10 ; trois visuels enfants finaux absents ; logique et reprise entièrement legacy ; migration d'une séquence sensible plus complexe. | Élevé, mais la couverture fonctionnelle existe déjà et est testée. | La plus complète pour prouver Messages + physique + média + Galerie + Viewer + conséquence + reprise. |

### 12.3 Sélection produit et couverture normative

Le produit sélectionne **Mathilde J11 M-B3** comme première tranche verticale :

`FIRST_TARGET_VERTICAL_SLICE_SELECTED`

Cette sélection est normative. La tranche doit couvrir ensemble :

- Messages alimenté par la source cible ;
- des choix authored ;
- un beat physique ;
- une résolution qualitative, sans score relationnel ;
- une conséquence durable A1–A5 ;
- une obligation d'aftercare ;
- un retour joueur ultérieur influencé par cette conséquence ;
- le triplet média réel de la séquence ;
- Galerie et PhotoViewer alimentés par la source cible ;
- sauvegarde et reprise à l'intérieur de la séquence ;
- aucune lecture ni écriture métier du legacy.

La référence J11 reste une projection temporelle et un alias de provenance. La
séquence cible doit recevoir une identité canonique indépendante, à inventorier
et proposer dans un lot ultérieur ; N10 ne crée pas d'identité cible fondée sur
J11.

### 12.4 Dette média Mathilde M-B3

La dette de production finale comprend exactement trois visuels enfants, dans
l'ordre canonique :

1. `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY` — `SPECIFIED_NOT_PRODUCED` ;
2. `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01` — `SPECIFIED_NOT_PRODUCED` ;
3. `S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01` — `SPECIFIED_NOT_PRODUCED`.

Le parent Galerie `S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01` est une tuile
logique ouvrant ce triplet, pas un quatrième payoff ni un quatrième fichier
physique présumé. Son thumbnail/full asset est actuellement vide et rendu en
placeholder. Le statut de planification initial du parent/thumbnail cible est
`DERIVED_OR_REUSED_NOT_SEPARATELY_PRODUCED` : il doit dériver ou réutiliser l'un
des trois enfants si possible, avec zéro asset parent supplémentaire présumé.
Si un fichier distinct devient réellement nécessaire, ce besoin devra être
prouvé et décidé explicitement dans un lot ultérieur ; N10 n'invente aucun asset.

### 12.5 Critères de réussite non négociables

La tranche choisie est réussie seulement si :

- le joueur la vit depuis le nouveau runtime ;
- aucun provider JNN ni champ `Season1State` n'est lu ou écrit ;
- sauvegarde et reprise fonctionnent au point exact ;
- choix, résolution et effets sont idempotents ;
- un événement durable influence un retour joueur ultérieur ;
- un média suit sa diégèse, son audience et son accès réels ;
- Messages, Galerie et PhotoViewer utilisent la nouvelle source ;
- une séquence jamais proposée ne devient pas une absence ;
- aucun score relationnel n'est introduit ;
- aucun fallback legacy n'est possible.

Une démonstration data-only, un smoke A6–A10 ou un viewer alimenté par fixture ne
constitue pas le cutover.

## 13. Feuille de route d'exécution

### Phase 0 — Gel et contrat

N10 : approbation du présent contrat, classement des composants et ouverture du
registre de décisions produit. Aucun code.

### Phase 1 — Fondations player-facing de la tranche Mathilde

- contrat de contenu unifié versionné ;
- exécuteur de séquence minimal sans logique de Saison ;
- projection Messages et port d'intentions ;
- projection du beat physique et reprise de l'exécution ;
- taxonomie et reducers réels pour la conséquence durable et l'obligation d'aftercare ;
- lifecycle du triplet média, avec audiences et accès explicites ;
- projections Galerie et PhotoViewer ;
- sauvegarde/reprise intra-séquence dans un nouveau namespace ;
- bootstrap cible sans chargement du legacy.

### Phase 2 — Mathilde M-B3, première tranche verticale

- implémenter la couverture normative de Mathilde M-B3 définie en 12.3 ;
- produire et intégrer le triplet média défini en 12.4, sans présumer un quatrième asset parent ;
- prouver choix, beat physique, résolution qualitative, conséquence A1–A5, aftercare et retour ultérieur ;
- prouver Galerie, PhotoViewer, sauvegarde/reprise intra-séquence et idempotence ;
- livrer une preuve player-facing sans provider JNN ni lecture/écriture métier legacy.

J11 ne sert que de projection temporelle et d'alias de provenance. L'identité
canonique cible de la séquence reste indépendante ; son inventaire et sa
proposition appartiennent à un lot ultérieur.

### Phase 3 — Suivi Messages et début du Mouvement I

- réaliser Sandra J01 comme `FOLLOW_UP_MESSAGES_SLICE_CANDIDATE` simplifiée ;
- conserver « Les chaises bleues » comme fixture `TECHNICAL_ORCHESTRATION_PILOT` ;
- commencer la migration du Mouvement I unité par unité après validation des voix ;
- établir les alias de provenance sans reprendre les identités JNN ;
- refuser toute migration massive automatique.

### Phase 4 — Progression de Saison 1

Migrer mouvement par mouvement :

1. Réouverture ;
2. Attirances ;
3. Explorations ;
4. Limites et conséquences ;
5. Clarification.

Chaque mouvement possède un gate player-facing, une couverture de sauvegarde,
une vérification des audiences et une décision de dépréciation des tests legacy
correspondants.

### Phase 5 — Payoffs W4 et finale

Implémenter uniquement dans le nouveau système :

- Marie `#051/#052` ;
- Mathilde `#045/#046` ;
- Sandra `#079/#080` ;
- l'aftercare J19 re-projeté comme séquence ;
- `s1_m5_marie_player_final_conversation` ;
- décision/logistique ;
- épilogues.

N7.1, N8 et N9 restent les spécifications métier/narratives de référence ; ils
n'autorisent aucune extension de `Season1State`.

### Phase 6 — Suppression du legacy

Un lot distinct, avec revue adversariale approfondie, retire le runtime journées,
ses données actives et ses tests devenus inutiles seulement après satisfaction
de tous les critères de sortie ci-dessous.

## 14. Critères de suppression du legacy

Le legacy peut être supprimé uniquement lorsque :

- le nouveau runtime démarre et joue sans aucun fichier legacy ;
- Messages, choix et résolutions sont connectés ;
- notifications et non-lus sont connectés ;
- transitions temporelles et beats physiques sont connectés ;
- Galerie et PhotoViewer sont connectés ;
- médias, audiences, retrait et diffusion sont connectés ;
- sauvegarde et reprise disque fonctionnent ;
- toute la Saison 1 cible est jouable ;
- les payoffs W4 et aftercares fonctionnent ;
- la conversation finale, la décision/logistique et les épilogues fonctionnent ;
- les tests de parité utiles sont passés ou explicitement dépréciés ;
- aucun code actif ne lit ou écrit `Season1State` ;
- aucun provider ou map JNN n'est requis ;
- aucun identifiant `jNN_*` n'est une identité métier cible ;
- le build de production ne charge aucun code, JSON ou asset legacy ;
- une exécution sans les répertoires legacy fait partie de la gate de build.

La suppression est interdite sur la seule base d'une couverture data ou d'une
parité partielle de messages.

## 15. Gouvernance de transition

Pendant toute la transition :

- le nouveau runtime est la seule cible active ;
- le legacy reste une référence figée ;
- aucun contenu ne peut être implémenté dans les deux systèmes ;
- toute nouvelle décision narrative vise le contrat authored cible ;
- tout document utilisant les jours comme architecture est classé `Legacy
  Reference` ou `À réécrire` ;
- les jours restent autorisés comme projection diégétique ;
- N7.1, N8 et N9 restent valides comme spécifications métier/narratives ;
- toute exception au gel exige un lot correctif nommé ;
- tout outil lisant le legacy reste hors runtime et hors build final.

N8 est traité comme définition métier validée de J17, référence de tests et
source des futurs reducers : six états, huit règles ordonnées, deux micro-retours
et invariants de reprise. Son implémentation actuelle dans `Season1State` et
`J17RuntimeProvider` est une preuve legacy, pas une obligation architecturale.

## 16. Gouvernance documentaire

Les statuts ci-dessous sont prospectifs après approbation de N10. Ils ne
modifient aucun fichier existant dans ce lot.

### 16.1 Portails et architecture

| Chemin exact | Statut futur | Autorité restante | Éléments encore valides | Éléments supersédés | Action future |
| --- | --- | --- | --- | --- | --- |
| `docs/architecture/R8C_N10_LEGACY_FREEZE_AND_NEW_RUNTIME_CUTOVER_CONTRACT.md` | Target Runtime | Autorité de transition et cutover. | Toutes les décisions après approbation produit. | Aucun à N10. | Faire approuver, puis indexer dans un lot ultérieur. |
| `docs/architecture/README.md` | Target Runtime | Ordre de lecture A1–A10. | Invariants sans scores, scènes, orchestration. | Frontière disant le runtime J01–J21 temporairement actif comme cible de reprise. | Ajouter N10 après approbation, hors N10. |
| `docs/architecture/R8A_D1_CONTRAT_PRODUIT_MOTEUR_NARRATIF.md` | Canon | Direction produit du moteur. | Domaine qualitatif, migration unidirectionnelle, jours non identitaires. | Étapes ou formulations antérieures à A1–A10/N10. | Conserver comme fondation. |
| `docs/architecture/R8A_ROUTE_STATE_SIMPLIFICATION_BLUEPRINT.md` | Canon | Simplification relationnelle. | États qualitatifs, absence de scores. | Toute projection technique devenue A1. | Conserver comme rationale. |
| `docs/architecture/R8B_VUE_ETAT_NARRATIF_LECTURE_SEULE.md` | Target Runtime | Contrat de lecture qualitative. | Vues et inspectabilité. | Dépendances éventuelles à l'oracle legacy. | Reprojeter depuis A1 lors d'un lot cible. |
| `docs/architecture/R8C_A1_FONDATION_ETAT_NARRATIF.md` | Target Runtime | Fondation A1. | Transaction, idempotence, racines et limites. | État synthétique comme couverture suffisante. | Étendre par lots de reducers réels. |
| `docs/architecture/R8C_A2_CONTRAT_SCENE_MODULAIRE_ET_MOTEUR_NARRATIF.md` | Canon | Sémantique produit scène/séquence. | Cycle, non-sélection, choix, effets et garde-fous. | Absence de format concret, désormais un manque N10 identifié. | Source du contrat authored unifié. |
| `docs/architecture/R8C_A3_PROTOTYPE_MINIMAL_SCENE_NARRATIVE.md` | Target Runtime | Contrat du noyau A3. | Définition/instance/résolution. | Suffisance comme tranche produit. | Conserver sous l'exécuteur. |
| `docs/maintenance/R8C_A4_CONSOLIDATION_CANONIQUE_ET_NETTOYAGE_LEGACY.md` | Legacy Reference | Audit historique des frontières. | Inventaire et absence de sauvegarde disque. | `ENCORE_UTILISE_TEMPORAIREMENT` comme permission d'évolution. | Archiver après suppression legacy. |
| `docs/architecture/R8C_A5_PERSISTANCE_MINIMALE_SCENES_ET_OPPORTUNITES.md` | Target Runtime | Snapshot A1/A5 reconstructible en mémoire. | Registre, version et atomicité. | Assimilation à une sauvegarde produit complète. | Étendre sans snapshot hybride. |
| `docs/architecture/R8C_A6_DECISIONS_PRODUIT_ET_AUDIT_PREPARATOIRE.md` | Target Runtime | Décisions du loader/bundle A6. | Source data-first stricte et maps comme audit seulement. | Inventaire daté si le corpus évolue. | Conserver. |
| `docs/architecture/R8C_A6_BRIEF_BIBLIOTHEQUE_NARRATIVE_MINIMALE.md` | Archive | Brief d'implémentation accompli. | Rationale et critères historiques. | Travail futur annoncé, livré par l'implémentation A6. | Archiver après lien depuis le doc A6 final. |
| `docs/architecture/R8C_A6_BIBLIOTHEQUE_NARRATIVE_MINIMALE_IMPLEMENTATION.md` | Target Runtime | Contrat A6 implémenté. | Bundle fermé, loader, query et limites. | Contenu synthétique comme bibliothèque canonique. | Conserver et alimenter via contrat authored. |
| `docs/architecture/R8C_A7_RESERVATION_ET_PROPOSITION_CANDIDATS.md` | Target Runtime | Frontière A7. | Revalidation, réservation/proposition, idempotence. | Statut prototype comme interdiction permanente d'intégration. | Conserver. |
| `docs/architecture/R8C_A8_FENETRES_OPPORTUNITE_ET_CONFLITS_EXCLUSIFS.md` | Target Runtime | Frontière A8. | Non-sélection, MISSED après proposition, conflits. | Fenêtres mémoire comme reprise complète. | Ajouter persistance/reconstruction dans lot séparé. |
| `docs/architecture/R8C_A9_COMPOSITION_CONTROLEE_CRENEAU_NARRATIF.md` | Target Runtime | Frontière A9. | Ordre auteur, plan éphémère, revalidation. | Toute lecture comme constructeur de journée. | Conserver. |
| `docs/architecture/R8C_A10_VERTICAL_SLICE_ORCHESTRATION_ET_SIMPLIFICATION_API.md` | Target Runtime | Façade A1–A9. | API mince et délégations. | Smoke synthétique comme cutover. | Placer sous l'exécuteur. |
| `docs/architecture/R8C_A11_ATELIER_AUTEUR_ASSISTE_VERTICAL_SLICE.md` | Migration Support | Contrats de l'atelier auteur prototype. | Intention humaine, brouillon, choix et projection A6. | Toute lecture comme source runtime ou canon automatique. | Conserver hors build et aligner plus tard sur le contrat authored unifié. |
| `docs/architecture/R8C_A11_2_BIBLIOTHEQUE_VOIX_CALIBRATION_RELATIONNELLE.md` | Migration Support | Calibration de voix hors runtime. | Corpus et distinctions relationnelles. | Toute mutation du domaine joueur. | Conserver comme QA auteur. |
| `docs/architecture/R8C_A11_3_PLANIFICATION_ASSISTEE_SCENE.md` | Migration Support | Planification de scène prototype. | Beats, états locaux, choix et média descriptif. | Plan A11 comme séquence jouable. | Adapter le futur export seulement après contrat cible. |
| `docs/architecture/R8C_A11_4_PLAN_BROUILLON_EXPORT_A6_TEST.md` | Migration Support | Pipeline plan/brouillon/export de test. | Provenance, approbation humaine et pertes de projection explicites. | Export A6 comme contenu player-facing complet. | Conserver comme preuve de tooling. |
| `docs/architecture/R8C_A11_5_PREMIERE_SCENE_PILOTE_EDITORIALE.md` | Migration Support | Provenance du pilote « Chaises bleues ». | Revue, voix et non-persistance. | Statut de revue comme activation/canon automatique. | Conserver avec N1–N5. |

### 16.2 Auteur, narration et médias

| Chemin exact | Statut futur | Autorité restante | Éléments encore valides | Éléments supersédés | Action future |
| --- | --- | --- | --- | --- | --- |
| `docs/narrative/R8C_N1_CANON_REVIEW_SANDRA_BLUE_CHAIRS.md` | Canon | Revue canonique de la scène. | Intention, voix et limites. | Hypothèses techniques antérieures. | Conserver comme provenance. |
| `docs/narrative/R8C_N2_SANDRA_BLUE_CHAIRS_MINOR_NARRATIVE_REVISION.md` | Canon | Texte verrouillé de « Chaises bleues ». | Bulles, choix et convergence. | Destination runtime journées. | Migrer seulement après décision de tranche. |
| `docs/narrative/R8C_N3_SANDRA_BLUE_CHAIRS_CANONICAL_PLACEMENT.md` | Canon | Placement relatif authored. | Ordre et préconditions relationnelles. | Jour comme identité. | Traduire en contraintes authored. |
| `docs/narrative/R8C_N4_SANDRA_BLUE_CHAIRS_EXACT_SEASON_PLACEMENT_AUDIT.md` | Legacy Reference | Audit de compatibilité avec J04/J05. | Collision et règle de non-proposition J05. | Placement J04 comme architecture cible. | Utiliser pour parité/migration. |
| `docs/narrative/R8C_N4_1_CANON_RELATIVE_RUNTIME_PROJECTION_CLARIFICATION.md` | Canon | Distinction identité/projection. | Jours non identitaires. | Activation dans le legacy. | Conserver. |
| `docs/narrative/R8C_N5_SANDRA_BLUE_CHAIRS_STAGED_SEASON_PROJECTION.md` | Migration Support | Preuve staged A6–A10. | Identité, mapping, manques et interdiction de bridge. | Futur bridge `Season1State` envisagé alors, désormais interdit. | Source de tranche après décision produit. |
| `docs/narrative/R8C_N6_CANONICAL_SCENE_PORTFOLIO_INVENTORY.md` | Canon | Inventaire scènes/fonctions. | Mouvements, séquences, scènes fortes et gaps. | J01–J21 comme topologie cible. | Base du tri migration. |
| `docs/narrative/R8C_N6_CONTENT_PRODUCTION_FORECAST_AND_ROADMAP.md` | À réécrire | Prévision éditoriale/média. | Volumes, dépendances et QA. | Roadmap d'intégration dans providers/maps. | Replanifier par mouvements et séquences. |
| `docs/narrative/R8C_N6_EROTIC_AND_PORNOGRAPHIC_PROGRESSION_MAP.md` | Canon | Progression et fonctions W. | Niveaux, conséquences et limites. | Projection par jour comme identité. | Conserver comme règle de contenu. |
| `docs/narrative/R8C_N6_VISUAL_REWARD_AND_PHOTO_COVERAGE_AUDIT.md` | Canon | Inventaire média et fonctions. | IDs, diégèse, niveaux, Galerie/replay. | Hooks runtime JNN comme destination. | Alimenter le registre média cible. |
| `docs/narrative/R8C_N7_1_SEASON_STRUCTURE_RUNTIME_PROJECTION_AND_N8_ENTRY_CONTRACT.md` | Canon | Structure authored, six états et entrée N8. | Cinq mouvements, jours-projection, finale autonome. | N8 comme permission de poursuivre le legacy. | Source des futurs reducers J17. |
| `docs/narrative/R8C_N7_J17_J21_CONTINUITY_AND_AFTERCARE_PLAN.md` | Canon | Continuité et transport. | Micro-retours, aftercares, ordre final. | Implémentation J17/J21 dans providers. | Reprojeter en séquences cible. |
| `docs/narrative/R8C_N7_REVISION_PACKETS_AND_ACCEPTANCE_GATES.md` | Canon | Gates éditoriales. | Préconditions, choix, beats et interdits. | Fichiers legacy proposés comme destination. | Appliquer aux séquences authored cible. |
| `docs/narrative/R8C_N7_W4_PAYOFF_WRITTEN_RECONCILIATION.md` | Canon | Réconciliation écrite W4. | Fonctions, limites et aftercare. | Plan de livraison legacy. | Source phase 5. |
| `docs/narrative/R8C_N9_W4_PAYOFF_AFTERCARE_AND_J21_CONTINUITY_CONTRACT.md` | Canon | Contrat W4/J21 approuvé. | Six médias, aftercares, ordre J21, identité finale. | Toute future écriture dans `Season1State`/JNN. | Autorité phase 5. |
| `docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md` | Canon | Trame et actes. | Fonctions dramatiques. | Calendrier rigide éventuel. | Lire via les cinq mouvements N7.1. |
| `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` | Canon | Bibliothèque narrative historique. | Séquences, fonctions et participants. | Projection jour comme identité technique. | Trier/migrer séquence par séquence. |
| `docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md` | Canon | Règles visuelles. | Fonctions, niveaux et diégèse. | Mappage direct vers Galerie. | Source du lifecycle média. |
| `docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md` | Canon | Sémantique des dettes et conséquences. | Relations et transport narratif. | Identifiants techniques JNN comme cible. | Source des reducers réels. |
| `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md` | À réécrire | Grille historique de couverture. | Densité et fonctions. | Jours comme architecture. | Reprojeter par mouvement. |
| `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md` | Legacy Reference | Audit historique J01–J08. | Matière de migration et écarts. | Constats runtime obsolètes. | Utiliser hors runtime. |
| `docs/canon/bible/12B_PLANS_SCENES_J09_J12.md` | À réécrire | Matière authored J09–J12. | Beats, choix, conséquences. | Découpage obligatoire par jour. | Recomposer en séquences. |
| `docs/canon/bible/12C_PLANS_SCENES_J13_J16.md` | À réécrire | Matière authored J13–J16. | Limites, obligations, conséquences. | Découpage obligatoire par jour. | Recomposer en séquences. |
| `docs/canon/bible/12D_PLANS_SCENES_J17_J21.md` | À réécrire | Matière des résolutions. | Départ, traces, logistique, épilogues. | J17 finale et J21 trace suffisante. | Subordonner à N7.1/N9. |
| `docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md` | Archive | Provenance historique. | Risques et décisions passées. | Autorité courante. | Archiver. |
| `docs/canon/bible/13_BIBLE_VOIX_MESSAGERIE_ET_TESTS_DISTINCTION.md` | Canon | Voix de messagerie. | Voix et tests de distinction. | Format JSON/provider précis. | Valider les migrations. |
| `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` | Canon | Contrat narratif Saison 1. | Cinq mouvements, finale et jours souples. | Anciennes finales par trace/jour. | Autorité du corpus cible. |

### 16.3 Dialogues, registres, UI et runtime documentaire

| Chemin exact | Statut futur | Autorité restante | Éléments encore valides | Éléments supersédés | Action future |
| --- | --- | --- | --- | --- | --- |
| `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` | Canon | Corpus historique signé. | Voix, faits et scènes fortes. | Format runtime directement réutilisable. | Source éditoriale de migration. |
| `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md` | Canon | Connaissances et acquisitions. | Faits sourcés et audiences. | Identifiants JNN comme modèle de stockage. | Source des reducers/contenus cible. |
| `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md` | Canon | Traces, contrôle, audience, retrait. | Sémantique de trace. | Stockage `Season1State.traces`. | Source du registre cible. |
| `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md` | Canon | Promesses explicites. | Création par proposition et statuts. | Stockage legacy. | Source du reducer promesse. |
| `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md` | Migration Support | Parité d'atteignabilité historique. | Chemins utiles et contenus inatteignables. | Autorité sur l'éligibilité cible. | Comparer puis déprécier. |
| `docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md` | Canon | Texte source ouverture. | Dialogues et fonctions. | Chapitres comme unités cible. | Migrer dans Mouvement I. |
| `docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J07. | Voix, beats, choix, conséquences. | Jour/provider comme destination. | Trier/migrer. |
| `docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J08. | Voix, beats, choix, conséquences. | Jour/provider comme destination. | Trier/migrer. |
| `docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J09. | Marie/La Verrière, choix et médias. | Jour/provider comme destination. | Candidat de migration ultérieur. |
| `docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J10. | Pivots et conséquences. | Sélecteur J10 comme cible. | Recomposer. |
| `docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J11. | Alternatives, médias, choix et aftercare. | Provider J11 comme cible. | Source candidate Mathilde M-B3. |
| `docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J12. | Retours et conséquences J11. | Jour/provider comme cible. | Reprojeter en retours de séquences. |
| `docs/canon/dialogues/J13_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J13. | Retours conditionnels. | Jour/provider comme cible. | Recomposer. |
| `docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J14. | Découverte, audience et obligations. | Implémentation monolithique legacy. | Source des reducers. |
| `docs/canon/dialogues/J15_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J15. | Conflits d'obligations. | Jour/provider comme cible. | Recomposer. |
| `docs/canon/dialogues/J16_SCRIPT_NARRATIF_COMPLET.md` | Canon | Texte source J16. | Paiement, départ, handoff couple. | Handoff J17 technique. | Recomposer. |
| `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | Matière historique J17. | Départ, foyer et familles de sortie. | J17 comme finale ; règles avant N8. | Réécrire selon N7.1/N8. |
| `docs/canon/dialogues/J18_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | Matière Sandra résolution. | Branches et conséquences. | Payoff W4 absent et provider cible. | Réécrire selon N9 dans phase 5. |
| `docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | Matière aftercare/versions privées. | Priorité Sandra et postures. | Absence runtime/ordre par jour. | Reprojeter en séquence aftercare. |
| `docs/canon/dialogues/J20_SCRIPT_NARRATIF_COMPLET.md` | Canon | Matière des positions actives. | Conséquences et préparation finale. | Jour/provider comme cible. | Recomposer. |
| `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | Matière historique de finale. | Matin, trace, logistique et épilogues utilisables. | Ordre ancien et conversation finale autonome absente. | Réécrire selon N7.1/N9. |
| `docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md` | Reusable Presentation | Autorité shell portrait. | Forme, navigation et accessibilité. | Source provider legacy. | Conserver et recâbler. |
| `docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md` | Reusable Presentation | Autorité écrans/états. | Messages, Galerie, Viewer et transitions. | États dérivés des jours/providers. | Traduire vers projections cible. |
| `docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md` | Reusable Presentation | Handoff UI historique. | Composants et critères visuels. | Plan d'intégration legacy. | Mettre à jour après tranche cible. |
| `docs/canon/DOCUMENTATION_READING_ORDER.md` | Canon | Portail documentaire. | Hiérarchie canon/architecture. | Runtime J01–J21 comme oracle actif de développement. | Ajouter N10 après approbation. |
| `docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md` | Canon | Règles d'autorité documentaire. | Sources uniques et statuts. | `ACTIVE_RUNTIME` legacy comme cible produit. | Réconcilier les statuts avec N10. |
| `docs/CURRENT_NARRATIVE_SOURCE_OF_TRUTH.md` | À réécrire | Portail narratif historique. | Primauté du texte validé sur adaptation runtime. | Runtime JSON verrouillé comme vérité jouable cible. | Réécrire après approbation N10. |
| `docs/runtime/README.md` | Legacy Reference | Description de la chaîne exécutable historique. | Démarrage, dépendances, snapshots mémoire. | Autorité sur le nouveau runtime. | Figer, puis archiver phase 6. |
| `docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md` | Legacy Reference | Baseline historique ouverture. | Oracle J01–J04. | Forward contract pour nouveaux jours. | Conserver pour parité. |
| `docs/runtime/T_UI_01_PORTRAIT_SHELL_PLAN.md` | Reusable Presentation | Provenance du shell. | Contraintes portrait et navigation. | Couplage runtime_s1. | Conserver comme référence UI. |
| `docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md` | Legacy Reference | Audit historique du runtime. | Inventaire et écarts de référence. | Autorité sur la cible. | Figer, puis archiver. |
| `docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md` | Legacy Reference | Plan historique J02. | Comportements de parité utiles. | Plan d'extension du runtime journées. | Figer, puis archiver. |
| `docs/runtime/V0_82_THURSDAY_TOPOLOGY_IMPLEMENTATION_PLAN.md` | Legacy Reference | Plan historique J03. | Topologie et comportements joués. | Topologie par jour comme cible. | Figer, puis archiver. |
| `docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md` | Legacy Reference | Plan historique temps/journées. | UX temporelle observable. | Jour comme unité moteur. | Source de parité UI seulement. |
| `docs/runtime/V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md` | Legacy Reference | Réconciliation J01 historique. | Écarts texte/runtime. | Destination provider J01. | Source de migration. |
| `docs/runtime/V0_86_FRIDAY_PUBLIC_TRACES_IMPLEMENTATION_PLAN.md` | Legacy Reference | Plan historique J04. | Traces et audiences utiles. | Destination provider/map. | Source de migration. |
| `docs/runtime/V0_86_PR_REVIEW_NOTES.md` | Archive | Revue technique historique. | Provenance des corrections. | Autorité active. | Archiver. |
| `docs/runtime/V0_86_VALIDATION_CHECKLIST.md` | Legacy Reference | Checklist de parité J04. | Cas de test utiles. | Gate du runtime cible. | Reclasser en compatibilité. |
| `docs/runtime/V0_86A_TEMPORAL_UX_NOTIFICATION_POLISH_PLAN.md` | Reusable Presentation | Plan UX temps/notifications. | Lisibilité et comportements UI. | Couplage provider/jour. | Reprendre les critères dans les projections cible. |
| `docs/runtime/V0_87_NEXT_ACT_I_WINDOWS_PREPARATION_NOTE.md` | Legacy Reference | Note de préparation historique. | Fonctions et fenêtres à comparer. | Autorisation d'ajouter des jours/providers. | Figer. |
| `docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_INTEGRATION_PLAN.md` | Legacy Reference | Plan d'intégration historique. | Parité des répétitions. | Intégration dans le runtime journées. | Source de migration. |
| `docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_PREPARATION_NOTE.md` | Legacy Reference | Préparation historique. | Décisions de contenu encore sourcées. | Plan technique cible. | Figer. |
| `docs/runtime/V0_91_FIRST_REPETITION_WAVE_CLOSURE_BLUEPRINT.md` | Legacy Reference | Blueprint de fermeture de vague. | Fonctions et continuité. | Projection JNN comme architecture. | Recomposer par mouvement. |
| `docs/runtime/V0_94_VISUAL_FIRST_NAMED_BOUNDARIES_RUNTIME_INTEGRATION_PLAN.md` | Legacy Reference | Plan d'intégration visuelle historique. | Garde-fous médias/limites. | Maps/providers comme destination. | Source média et parité seulement. |

Les autres documents racine `V0_*`, plans journaliers, story states et drafts
non reliés par une autorité active restent `Archive` ou `Migration Support`
selon la gouvernance existante. Leur présence ne leur donne aucune autorité sur
le runtime cible.

## 17. Non-objectifs de N10

N10 ne :

- met pas en œuvre le cutover ;
- modifie pas A1–A10 ;
- supprime pas le legacy ;
- migre aucune scène ;
- crée ni exécuteur, ni reducer, ni sauvegarde, ni projection ;
- produit aucun média ;
- écrit aucun payoff W4 ni finale ;
- crée aucun troisième moteur ;
- propose aucune double écriture ;
- garantit aucune compatibilité d'ancienne sauvegarde ;
- modifie aucun index ou document existant.

## 18. Gates d'approbation et de livraison

### 18.1 Gate produit du contrat

Pour attribuer
`LEGACY_FREEZE_AND_NEW_RUNTIME_CUTOVER_CONTRACT_APPROVED`, la revue produit doit
confirmer explicitement :

- le gel et les exceptions correctives ;
- les cinq catégories et les inventaires ;
- l'architecture cible et les responsabilités ;
- l'interdiction de double écriture ;
- la stratégie média, sauvegarde et migration ;
- la feuille de route et les critères de suppression ;
- le traitement N7.1/N8/N9 ;
- Mathilde M-B3 comme tranche `FIRST_TARGET_VERTICAL_SLICE_SELECTED`, sa
  couverture normative et sa dette exacte de trois visuels enfants.

La revue ne transforme pas cette sélection en implémentation autorisée : la
phase 2 ne commence qu'après livraison et validation des fondations de phase 1.

### 18.2 Gate documentaire N10

- [x] Baseline et tag exacts inspectés.
- [x] Diff conçu pour le seul document N10.
- [x] Classification legacy/présentation/cible/manques/migration couverte.
- [x] Politique de gel et exceptions explicites.
- [x] Interdiction de double écriture explicite.
- [x] Architecture cible et contrat authored couverts.
- [x] Cycle média et sauvegarde/reprise couverts.
- [x] Stratégie de migration couverte.
- [x] Sandra « Chaises bleues » analysée sans invention.
- [x] Mathilde M-B3 sélectionnée et deux candidats de suivi/pilote classés.
- [x] Dette Mathilde bornée à trois enfants ; parent sans quatrième asset présumé.
- [x] Preuves de domaine, A4 UI et A11/N5 migration classées par chemins étroits.
- [x] Feuille de route et critères de suppression couverts.
- [x] Gouvernance documentaire couverte sans modifier les sources.
- [x] Aucun placeholder dans le contrat.
- [x] Aucune implémentation technique autorisée par N10.

## 19. Verdict

Le runtime journées est gelé comme `LEGACY_REFERENCE_ONLY`. Les surfaces joueur
sont conservées comme `REUSABLE_PRESENTATION` lorsque leur couplage peut être
extrait. A1–A10 reste le `TARGET_DOMAIN`; les liaisons player-facing, le contrat
authored complet, les reducers réels, le lifecycle média, la sauvegarde disque
et le corpus migré sont `TARGET_MISSING`. Les outils auteur et de comparaison
restent `MIGRATION_SUPPORT_ONLY` et hors runtime.

Mathilde M-B3 est la première tranche verticale sélectionnée ; Sandra J01 reste
le candidat de suivi Messages et « Les chaises bleues » le pilote technique
d'orchestration.

Le statut de livraison du présent document est :

`LEGACY_FREEZE_AND_NEW_RUNTIME_CUTOVER_CONTRACT_APPROVED`

Ce statut résulte de la revue produit du commit
`e75a13d16a30bac8f3617459540510e55310c923`, approuvé sans réserve en août 2026.
