# R8A — Blueprint de simplification de `RouteState`

## 1. Objet, périmètre et verdict d’architecture

Ce document audite l’architecture de routes de la saison 1 et définit un blueprint de simplification **documentation-only**. Il ne prescrit aucune modification immédiate du runtime et ne modifie ni scripts, ni snapshots, ni tests, ni données, ni dialogues, ni registres.

Le verdict d’architecture est **READY_FOR_PRODUCT_REVIEW** : un moteur `RouteState` commun est faisable sans perdre les distinctions narratives existantes, à condition de migrer par événements, de garder les registres spécialisés comme sources de vérité et de ne jamais transformer le consentement en permission persistante.

Le résultat attendu n’est pas un « score relationnel » universel. Le modèle proposé sépare :

- l’état courant et borné de chaque arc ;
- les axes sémantiques communs, non ordonnés et non interchangeables ;
- l’historique immuable des décisions et événements ;
- les registres spécialisés `promises`, `obligations`, `traces` et `knowledge` ;
- le contexte temporaire d’une scène et l’état de présentation/reprise des providers ;
- les vues dérivées utilisées par les sélecteurs, l’UI et les contrôles de cohérence.

Hors périmètre : implémentation, modification de sauvegarde, migration réelle, réécriture des scènes, modification d’assets ou de dialogues, PR, merge, tag et changement de `main`.

## 2. Baseline auditée, sources et ordre de précédence

L’audit est ancré sur les preuves suivantes :

| Élément | Valeur vérifiée |
|---|---|
| Commit `HEAD` | `dc335b74e258cde50ea3773ed9d630389042a7f3` |
| `main` | même commit |
| `origin/main` après fetch | même commit |
| Tag canonique | `runtime-r7a-c1-j14-canonical-presence-ledgers`, résolu sur le même commit |
| État initial du worktree | propre, `HEAD` détachée avant création de la branche de documentation |
| Branche de travail | `work/r8a-route-state-simplification-blueprint` |
| `Season1State.SNAPSHOT_VERSION` | `25` |
| `J14RuntimeProvider.J14_SNAPSHOT_VERSION` | `4` |
| `J15RuntimeProvider.J15_SNAPSHOT_VERSION` | `5` |
| `Season1RuntimeProvider.SNAPSHOT_VERSION` | `21` |

Sources inspectées :

1. runtime effectif : `Season1State.gd`, `Season1RuntimeProvider.gd`, providers J01–J21, sélecteurs J10/J11 et cartes runtime J01–J21 ;
2. canon d’état : `docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md` ;
3. canon de continuité : matrice d’atteignabilité J01–J21 et registres de promesses, connaissances et traces ;
4. scripts narratifs signés J09–J15, amendement J10–J12 et spécifications adultes ;
5. tests statiques J09–J21, tests de migration/restauration, tests de continuité et smoke drivers Godot existants.

Ordre de précédence retenu en cas d’écart : état réellement exécutable et testé à la baseline, amendement canonique le plus récent présent à cette même baseline, contrat narratif courant, puis scripts signés antérieurs. Cela explique notamment J15 : le script signé ancien décrit une collision à deux obligations, mais le contrat amendé, le runtime et les tests R7A-C1 imposent désormais `NO_COLLISION` lorsqu’aucune seconde obligation signée incompatible n’est prouvée. Il ne s’agit pas d’une source postérieure à la baseline, donc pas d’un motif de blocage.

Aucun commit ou document plus récent que la baseline n’a été trouvé dans le périmètre qui imposerait une autre architecture.

## 3. Diagnostic exécutif de l’architecture actuelle

`Season1State` persiste 108 champs de premier niveau et les restitue tous dans `snapshot()`. Le fichier joue simultanément six rôles : horloge de saison, état courant des routes, journal historique, registres spécialisés, état de sélection des journées et cache de conclusions dérivées.

Les principaux constats sont :

1. **Croissance append-only par journée.** Les champs `jNN_*` s’accumulent et augmentent le coût des migrations et de la validation globale, même lorsqu’ils ne sont plus lus après leur journée.
2. **Deux états courants pour une même route.** `sandra_state`, `pauline_state`, `raphaelle_state` et `nico_state` restent souvent sur une valeur ancienne, tandis que les conclusions J18–J20 vivent dans `j18_sandra_outcome`, `j19_*_outcome` ou `j20_nico_position`.
3. **Duplication scalaire des registres.** J14 recopie témoin, source, mode, champs visibles, valeurs, réaction, explication et notification alors que T20, F26/F28/F29 et P14/P15 portent déjà ces informations.
4. **Historique et état courant confondus.** Un pivot choisi, un niveau physique vécu, un refus ou une posture finale sont des événements ; les conserver comme propriétés courantes rend leur durée de vie ambiguë.
5. **Conclusions dérivées persistées.** Les contextes, priorités, options finales, audience/contrôleur d’une trace et marqueurs de conséquence peuvent être recalculés depuis les sources autoritatives.
6. **Enums sémantiquement hétérogènes.** `j11_pivot_outcome` et `j11_physical_level` mélangent plusieurs personnages et plusieurs notions ; une même « intensité » ne signifie pas la même chose pour Marie, Mathilde ou Raphaëlle.
7. **État de reprise correctement distinct, mais volumineux.** Les providers possèdent leur propre machine de phases, transcripts, messages produits, fils et médias servis. Cette couche ne doit pas entrer dans `RouteState`. Les snapshots quotidiens transportent toutefois des collections cumulatives, ce qui crée une duplication potentiellement quadratique dans le snapshot agrégateur.
8. **Dérive entre vocabulaire canonique et runtime.** Le runtime produit `PROTECTIVE_DISTANCE`, `CREATIVE_CONFIDENCE`, `FUTURE_INVITATION` et `DISTANCE` là où le canon définit respectivement `PROTECTIVE_WITHDRAWAL`, `CREATIVE_TRUST`, `BOUNDED_FUTURE_INVITATION` et `TAKING_DISTANCE`. Il accepte aussi `RECONFIGURATION_NEGOTIATION`, tandis que le canon définit `RECONFIGURATION_NEGOTIATING`.
9. **Atteignabilité canonique partielle.** Plusieurs états canoniques existent dans les contrats mais ne sont pas produits par les transitions courantes. Le blueprint ne doit ni les inventer dans les anciennes sauvegardes, ni les déclarer morts sans une décision produit.
10. **Absence d’une API de lecture unifiée.** Les scènes et sélecteurs lisent directement les champs historiques, les registres et les états de journée ; il n’existe pas de résumé `RouteState` commun dont les limites soient explicites.

La simplification doit donc réduire le nombre de sources autoritatives, pas simplement déplacer les 108 champs dans six dictionnaires.

## 4. Flux actuel et frontières de responsabilité

Le flux effectif peut être résumé ainsi :

```text
choix présenté par un provider
  → méthode apply_* de Season1State
  → mutation d'un ou plusieurs champs jNN_* / *_state
  → création ou transition éventuelle d'une promise, obligation, trace ou knowledge fact
  → contrôle de cohérence global
  → snapshot Season1State + snapshot du provider
  → initialisation du provider suivant avec transcripts/messages/threads/médias cumulés
```

Les frontières actuelles à préserver sont :

| Couche | Responsabilité légitime | Ce qui ne doit pas y entrer |
|---|---|---|
| `Season1State` | faits narratifs persistants, registres et progression de saison | phases UI, messages temporairement en attente |
| Provider JNN | phase de journée, présentation, reprise exacte, transitions et lots de messages | vérité durable d’une relation |
| Conversations / runtime maps | contenu et branchement déclaratif d’une journée | mutation arbitraire non auditée de l’état global |
| Registres | cycle de vie et métadonnées de leur objet spécialisé | copie d’un état relationnel générique |
| Canon narratif | invariants, vocabulaire et atteignabilité | détails techniques de reprise UI |

Le blueprint introduit une frontière supplémentaire : `RouteState` devient une projection narrative bornée par personnage ; `events` devient la mémoire des décisions ; les règles de scènes calculent les accès sans les persister.

## 5. Méthode de classification

Chaque champ persistant actuel reçoit une classe principale :

| Classe | Sens | Traitement cible |
|---|---|---|
| A | fait ou registre fondamental | conserver comme source de vérité, éventuellement hors `RouteState` |
| B | état de route | normaliser dans un `RouteState` commun |
| C | conclusion dérivable | recalculer à partir des sources de vérité |
| D | état temporaire de provider ou de scène | sortir de l’état narratif global |
| E | historique narratif | convertir en événement immuable |
| F | duplication explicite | supprimer après double écriture et preuve d’équivalence |
| G | legacy probablement inutilisé | instrumenter puis retirer si aucune lecture réelle |
| H | sens ou ownership indéterminé | décision produit/écriture requise avant migration |

`Dérivable` signifie « reconstructible sans décision narrative nouvelle » depuis les sources actuelles ou, lorsque la valeur représente un choix, depuis l’événement canonique proposé. `Dupliquée` signifie que la même conclusion ou le même payload existe déjà dans un autre champ ou registre. `Partiel` impose une phase de double lecture et un contrôle de parité avant suppression.

## 6. Inventaire exhaustif des 108 champs persistés

Tous les champs ci-dessous sont inclus dans le snapshot v25. Les mentions de lecture excluent les simples opérations de snapshot, migration et validation : elles visent les consommateurs narratifs ou de sélection.

| Variable actuelle | Type | Jour/personnage | Écrite par | Lue par | Persistante | Dérivable | Dupliquée | Cible proposée | Risque |
|---|---|---|---|---|---|---|---|---|---|
| `current_day` | String | saison | transitions `begin/complete` J01–J21 | tous les guards de journée | Oui | Non | Non | **A** `SeasonProgress.current_day`, hors route | Faible |
| `day_status` | String | saison | ouverture/fermeture de journée | orchestration et validation | Oui | Oui | Partiel | **C** calculé depuis provider actif + progression | Moyen : reprise |
| `couple_state` | String | Marie/couple | init, J09, J17 | J10–J21, sélecteurs et finales | Oui | Non | Partiel | **B** `routes["marie"].arc_state` | Élevé : état cross-personnes |
| `sandra_state` | String | Sandra | init, J01 | J05–J14, J18–J21 | Oui | Non | Oui | **B** `routes["sandra"].arc_state`, absorbant J18 | Élevé : valeur tardive divergente |
| `promises` | Dictionary | global | J01–J21 | gates, échéances, restore | Oui | Non | Non | **A** `PromiseRegistry` autoritatif | Élevé |
| `obligations` | Dictionary | global | J01–J21 | priorité, conséquence, restore | Oui | Non | Partiel | **A** `ObligationRegistry` autoritatif ; aligner avec promises sans les confondre | Élevé |
| `traces` | Dictionary | global | J01–J21 | audiences, accès, finales | Oui | Non | Non | **A** `TraceRegistry` autoritatif | Élevé |
| `knowledge` | Dictionary | global | J01–J21 | éligibilité, cohérence épistémique | Oui | Non | Non | **A** `KnowledgeRegistry` autoritatif | Élevé |
| `completed_conversation_ids` | Array[String] | global | providers / clôtures | anti-rejeu, restore | Oui | Oui | Partiel | **E** événements `conversation_completed`; vue dérivée | Moyen |
| `selected_choice_ids` | Array[String] | global | tous les `apply_*` | anti-rejeu, migrations, tests | Oui | Oui | Partiel | **E** événements `choice_selected`; index dérivé | Élevé : ordre à préserver |
| `foreground_history` | Array[Dictionary] | global | sélection/presentation | priorités et audit | Oui | Oui | Partiel | **E** journal d’événements de foreground | Moyen |
| `marie_make_room_outcome` | String | J01/Marie | J01 | aucune lecture narrative ultérieure trouvée | Oui | Oui | Oui | **G** événement J01 si valeur historique requise | Faible |
| `mathilde_welcome_outcome` | String | J02/Mathilde | J02 | aucune lecture narrative ultérieure trouvée | Oui | Oui | Oui | **G** événement d’accueil J02 | Faible |
| `raphaelle_state` | String | Raphaëlle | J02–J03 | J07–J14, J19–J21 | Oui | Non | Oui | **B** `routes["raphaelle"].arc_state`, absorbant J19 | Élevé |
| `raphaelle_work_outcome` | String | J03/Raphaëlle | J03 | J07 | Oui | Partiel | Partiel | **E** événement de travail ; `facts` pour accès réel | Moyen |
| `sandra_j03_echo_outcome` | String | J03/Sandra | J03 | J03 seulement | Oui | Oui | Oui | **G** événement d’écho si nécessaire | Faible |
| `marie_j03_return_outcome` | String | J03/Marie | J03 | J03 seulement | Oui | Oui | Oui | **G** événement de retour | Faible |
| `mathilde_state` | String | Mathilde | J02–J17 | J06–J21 | Oui | Non | Oui | **B** `routes["mathilde"].arc_state` | Élevé : sécurité/consentement |
| `pauline_state` | String | Pauline | J02 | J10–J21, mais reste souvent `PUBLIC_ONLY` | Oui | Non | Oui | **B** `routes["pauline"].arc_state`, absorbant J19 | Élevé : état courant obsolète |
| `nico_state` | String | Nico | J02–J07 | J08–J21 | Oui | Non | Oui | **B** `routes["nico"].arc_state`, absorbant J20 | Élevé |
| `pauline_public_selection_outcome` | String | J04/Pauline | J04 | aucune lecture ultérieure trouvée | Oui | Oui | Oui | **G** événement de sélection publique | Faible |
| `pauline_retained_frame` | String | J04/Pauline | J04 | aucune lecture ultérieure trouvée | Oui | Partiel | Partiel | **G** vérifier ownership média avant retrait | Moyen |
| `nico_friendship_outcome` | String | J04/Nico | J04 | aucune lecture ultérieure trouvée | Oui | Oui | Oui | **G** événement de position amicale | Faible |
| `opening_band_complete` | bool | J01–J04 | clôture du band initial | progression de journée | Oui | Oui | Oui | **C** dérivé des conversations/jours terminés | Faible |
| `household_rhythm_confirmed` | bool | J04/foyer | J04 | quelques gates historiques ; explicitement exclu comme preuve J14 | Oui | Partiel | Partiel | **H** fait de foyer à redéfinir ou événement J04 | Moyen |
| `marie_j05_shared_hour_outcome` | String | J05/Marie | J05 | J05 seulement | Oui | Oui | Oui | **G** événement de scène | Faible |
| `marie_j05_shared_hour_resolution` | String | J05/Marie | résolution J05 | J06 | Oui | Oui | Oui | **F** état de promise/événement de paiement | Moyen |
| `sandra_j05_outcome` | String | J05/Sandra | J05 | J05 seulement | Oui | Oui | Oui | **G** événement J05 | Faible |
| `mathilde_j06_outcome` | String | J06/Mathilde | J06 | J06 seulement | Oui | Oui | Oui | **F** événement + `mathilde_state` | Faible |
| `j06_external_continuity_resolution` | String | J06/multi-route | J06 | J06 seulement | Oui | Partiel | Partiel | **H** expliciter l’invariant avant migration | Moyen |
| `marie_j06_return_outcome` | String | J06/Marie | J06 | J07 | Oui | Partiel | Partiel | **E** événement de retour/absence | Moyen |
| `marie_j06_return_due_at` | String | J06/Marie | création échéance | J06–J07 | Oui | Oui | Oui | **F** échéance du registre de promesses | Moyen |
| `marie_j06_return_resolution` | String | J06–J07/Marie | paiement/échec | J07 | Oui | Oui | Oui | **F** statut de promise + événement terminal | Moyen |
| `raphaelle_j07_mobile_review_outcome` | String | J07/Raphaëlle | J07 | J07 seulement | Oui | Oui | Partiel | **G** événement de revue | Faible |
| `nico_j07_confidence_outcome` | String | J07/Nico | J07 | J07/J08 via `nico_state` | Oui | Oui | Oui | **F** événement + transition d’arc | Moyen |
| `nico_j07_continuation_outcome` | String | J07/Nico | J07 | J07 seulement | Oui | Oui | Oui | **G** événement J07 | Faible |
| `marie_j07_household_outcome` | String | J07/Marie | J07 | J07 seulement | Oui | Oui | Oui | **G** événement de foyer | Faible |
| `marie_j08_entry_outcome` | String | J08/Marie | J08 | J08 seulement | Oui | Oui | Oui | **G** événement d’entrée | Faible |
| `raphaelle_j08_preparation_outcome` | String | J08/Raphaëlle | J08 | J08 seulement | Oui | Oui | Partiel | **G** événement de préparation | Faible |
| `j08_priority_outcome` | String | J08/multi-route | sélection J08 | J08 seulement | Oui | Oui | Oui | **C** résultat de règle, journalisé comme événement si présenté | Moyen |
| `raphaelle_j08_work_resolution` | String | J08/Raphaëlle | J08 | J08 seulement | Oui | Oui | Oui | **F** trace/fait de travail + événement | Moyen |
| `nico_j08_meeting_resolution` | String | J08/Nico | J08 | J08 seulement | Oui | Oui | Oui | **F** promise/événement de rendez-vous | Moyen |
| `marie_j08_household_resolution` | String | J08/Marie | J08 | J08 seulement | Oui | Oui | Partiel | **E** événement de foyer | Moyen |
| `mathilde_j08_household_resolution` | String | J08/Mathilde | J08 | J08 seulement | Oui | Oui | Partiel | **E** événement de foyer | Moyen |
| `marie_j08_echo_outcome` | String | J08/Marie | J08 | J09 | Oui | Partiel | Partiel | **E** événement d’écho utilisé par J09 | Moyen |
| `marie_j09_presence_choice` | String | J09/Marie | choix J09 | J09–J11 | Oui | Oui | Partiel | **E** `choice_selected` + événement de présence | Élevé |
| `marie_j09_presence_outcome` | String | J09/Marie | J09 | J10–J11 | Oui | Partiel | Partiel | **E** événement sémantique de présence | Élevé |
| `marie_j09_dinner_outcome` | String | J09/Marie | J09 | J09/J10 | Oui | Oui | Partiel | **E** événement de dîner | Moyen |
| `j10_pivot` | String | J10/multi-route | sélecteur J10 | J10–J11 | Oui | Partiel | Oui | **E** événement `route_selected` ; ne pas recalculer rétroactivement | Élevé |
| `j10_pivot_reason` | String | J10/multi-route | sélecteur J10 | audit/snapshot | Oui | Partiel | Oui | **E** payload explicatif du même événement | Moyen |
| `j10_pivot_outcome` | String | J10/multi-route | choix J10 | J11 | Oui | Partiel | Partiel | **E** événement de route + transition `RouteState` | Élevé |
| `marie_j10_dinner_resolution` | String | J10/Marie | J10 | J10/J11 | Oui | Oui | Oui | **F** promise/événement terminal | Moyen |
| `nico_j10_morning_confirmation` | String | J10/Nico | J10 | aucune lecture ultérieure trouvée | Oui | Oui | Oui | **G** événement de confirmation | Faible |
| `j11_pivot` | String | J11/multi-route | sélecteur J11 | J11–J13 | Oui | Partiel | Oui | **E** événement `route_selected` J11 | Élevé |
| `j11_pivot_reason` | String | J11/multi-route | sélecteur J11 | audit/snapshot | Oui | Partiel | Oui | **E** payload explicatif | Moyen |
| `j11_pivot_outcome` | String | J11/multi-route | choix J11 | J12–J13 et gates | Oui | Partiel | Partiel | **E** événements typés par personnage | Élevé |
| `j11_physical_level` | String | J11/Marie, Mathilde, Raphaëlle | branche physique J11 | J12, J19, cohérence | Oui | Partiel | Partiel | **E** détail d’événement ; `intimacy` n’en est que le résumé | Critique |
| `mathilde_j11_state` | String | J11/Mathilde | branche Mathilde J11 | J11–J12 | Oui | Oui | Oui | **F** `mathilde_state` + événement J11 | Élevé |
| `mathilde_has_independent_sleep_option` | bool | J11/Mathilde | preuve matérielle J11 | gate physique J11, restore | Oui | Non | Non | **A** `routes.mathilde.facts` avec provenance | Critique |
| `mathilde_can_leave_safely` | bool | J11/Mathilde | preuve matérielle J11 | gate physique J11, restore | Oui | Non | Non | **A** `routes.mathilde.facts` avec provenance | Critique |
| `marie_absence_not_engineered` | bool | J11/Marie/Mathilde | preuve matérielle J11 | gate physique J11, restore | Oui | Non | Non | **A** fait borné avec événement source | Critique |
| `j12_presence_choice` | String | J12/Marie | choix présence | J12–J13 | Oui | Oui | Partiel | **E** événement de présence | Élevé |
| `j12_private_outcome` | String | J12/Sandra ou autre pivot | choix privé | J12–J13 | Oui | Partiel | Partiel | **E** événement typé par route | Élevé |
| `j12_annexe_choice` | String | J12/Marie | choix annexe | J12–J13 | Oui | Oui | Partiel | **E** événement de continuation | Moyen |
| `j12_priority_route` | String | J12/multi-route | règle de priorité | J13 | Oui | Partiel | Oui | **E** sélection réellement présentée ; calcul candidat dérivé | Élevé |
| `j12_failed_aftercare_processed` | bool | J12/Mathilde | traitement d’échec | garde d’idempotence | Oui | Oui | Oui | **F** transition terminale d’obligation + événement | Élevé |
| `j13_pivot` | String | J13/multi-route | sélection d’obligation | J13/J14 | Oui | Partiel | Oui | **E** événement de priorité délivrée | Élevé |
| `j13_outcome` | String | J13/multi-route | choix J13 | J13/J14 | Oui | Partiel | Partiel | **E** événement de résolution | Élevé |
| `j13_j14_trace_id` | String | J13→J14 | fermeture J13 | sélection J14 | Oui | Oui | Oui | **C** rechercher la trace `eligible_for_j14` issue de l’événement J13 | Élevé |
| `j14_variant` | String | J14/multi-route | sélection trace + présence | provider J14, J15, J18–J19 | Oui | Oui | Partiel | **C** `SceneCandidate`; journaliser la variante présentée | Élevé |
| `j14_outcome` | String | J14/Player | choix vérité/mensonge/protection | J15 et cohérence | Oui | Partiel | Oui | **E** réaction/explication dans l’événement T20 | Élevé |
| `j14_witness` | String | J14 | contrat de variante | J14–J16 | Oui | Oui | Oui | **F** `T20.subjects/payload.witness_id` | Élevé |
| `j14_witness_presence_evidence` | Dictionary | J14 | contexte de présence présenté | sélection J14/restore | Oui | Partiel | Partiel | **D** `scene_context`; persister l’événement de présence si présenté | Critique |
| `j14_discovery_mode` | String | J14 | contrat de variante | J14 | Oui | Oui | Oui | **F** `T20.payload.discovery_mode` | Moyen |
| `j14_visible_fields` | Array | J14 | contrat de variante | J14 | Oui | Oui | Oui | **F** T20/F26 `visible_fields` | Élevé |
| `j14_visible_values` | Dictionary | J14 | observation réelle | J14/restore | Oui | Oui | Oui | **F** F26 `visible_values` autoritatif | Critique : épistémique |
| `j14_source_trace_id` | String | J14 | sélection J14 | J14/J21 indirect | Oui | Oui | Oui | **F** `T20.discovered_trace_id` / dérivation | Élevé |
| `j14_secondary_trace_id` | String | J14 | reset/snapshot | aucune lecture opérationnelle trouvée | Oui | Non | Non | **G** instrumenter ; valeur actuellement vide | Faible |
| `j14_player_initial_reaction` | String | J14/Player | création T20 | J14 | Oui | Oui | Oui | **F** T20/F26 `player_reaction` | Moyen |
| `j14_player_explanation` | String | J14/Player | choix J14 | aucune lecture hors registre | Oui | Oui | Oui | **F** F28/F29 + événement de choix | Élevé |
| `j14_j15_obligation_id` | String | J14→J15 | création P14 | snapshot/validation | Oui | Oui | Oui | **F** identifiant du registre de promesses | Moyen |
| `j14_controller_notified` | bool | J14 | paiement/échec P15 | J14/validation | Oui | Oui | Oui | **F** statut P15 + knowledge fact | Élevé |
| `j15_mode` | String | J15 | sélecteur d’obligation | provider J15 | Oui | Oui | Oui | **C** règle sur P14 ; journaliser le mode présenté | Élevé |
| `j15_outcome` | String | J15 | choix/résolution | J15/J16 | Oui | Oui | Oui | **F** événement + statuts P14/T21/P17 | Élevé |
| `j15_urgent_consequence_remaining` | bool | J15 | résolution J15 | sélection J16 | Oui | Oui | Oui | **C** présence/statut P17 ou T21 | Élevé |
| `j16_priority` | String | J16/multi-route | sélecteur de conséquence | J16 | Oui | Oui | Oui | **C** règle sur obligations/promises dues | Moyen |
| `j16_consequence_outcome` | String | J16 | choix de conséquence | J16 | Oui | Oui | Oui | **F** T22 + événement terminal | Élevé |
| `j16_departure_state` | String | J16/Mathilde | plan de départ | J17 | Oui | Partiel | Oui | **E** événement `departure_planned` + fact de connaissance | Élevé |
| `j16_j17_outcome` | String | J16→J17/Marie | choix de handoff | J17 | Oui | Partiel | Partiel | **E** événement de préparation couple | Moyen |
| `j17_departure_outcome` | String | J17/Mathilde | choix de départ | J17/J21 indirect | Oui | Partiel | Oui | **E** événement ; transition `routes.mathilde.arc_state` | Élevé |
| `j17_couple_outcome` | String | J17/Marie | définition couple | J17/J21 | Oui | Oui | Oui | **F** `routes.marie.arc_state` + record/fact J17 | Critique |
| `j18_sandra_outcome` | String | J18/Sandra | choix J18 | J21 | Oui | Non | Oui | **B** normaliser puis écrire `routes.sandra.arc_state` | Élevé |
| `j19_pivot` | String | J19/Pauline ou Raphaëlle | sélecteur J19 | provider J19 | Oui | Oui | Oui | **C** règle de scène ; événement si présenté | Moyen |
| `j19_pauline_outcome` | String | J19/Pauline | choix J19 | J21 | Oui | Non | Oui | **B** normaliser dans `routes.pauline.arc_state` | Élevé |
| `j19_raphaelle_outcome` | String | J19/Raphaëlle | choix J19 | J19/J21 | Oui | Non | Oui | **B** normaliser dans `routes.raphaelle.arc_state` | Élevé |
| `j19_raphaelle_invitation_pending` | bool | J19/Raphaëlle | offre/réponse | J19/validation | Oui | Oui | Oui | **C** statut de promise d’invitation | Élevé |
| `j20_context` | String | J20/Nico | sélecteur J20 | provider J20 | Oui | Oui | Oui | **C** règle depuis traces, facts et arc Nico | Moyen |
| `j20_nico_position` | String | J20/Nico | choix J20 | J20/J21 | Oui | Non | Oui | **B** normaliser dans `routes.nico.arc_state` | Élevé |
| `j20_meeting_outcome` | String | J20/Nico | réponse au rendez-vous | J20 | Oui | Oui | Oui | **F** statut de promise + événement | Moyen |
| `final_trace_id` | String | J20→J21/global | sélection ordonnée de trace | finale J21 | Oui | Partiel | Partiel | **E** événement `final_trace_selected` référant `TraceRegistry` | Élevé |
| `final_trace_state` | String | J20→J21/global | copie de la trace choisie | validation | Oui | Oui | Oui | **C** `TraceRegistry[final_trace_id].current_state` | Élevé |
| `final_trace_controller` | String | J20→J21/global | copie de la trace choisie | options/validation | Oui | Oui | Oui | **C** contrôleur de la trace | Élevé |
| `final_trace_audience` | Array | J20→J21/global | copie de la trace choisie | validation | Oui | Oui | Oui | **C** audience courante de la trace | Critique : confidentialité |
| `existing_contradiction_id` | String | J21/global | calcul de finale | options J21 | Oui | Oui | Partiel | **C** contradiction active issue d’événements/facts | Élevé |
| `final_posture_options` | Array | J21/global | `begin_j21` | provider/choix J21 | Oui | Oui | Oui | **C** règle déclarative de finale | Élevé |
| `final_posture` | String | J21/Player | choix final | knowledge/finale | Oui | Non | Oui | **E** événement final + knowledge fact | Élevé |
| `j21_morning_outcome` | String | J21/Marie | choix du matin | clôture J21 | Oui | Partiel | Partiel | **E** événement de conséquence finale | Élevé |
| `resolved_visual_variant_by_asset` | Dictionary | global/média | résolution de variante | delivery/restore | Oui | Non | Non | **A** `MediaDeliveryState`, hors `RouteState` | Élevé : reproductibilité visuelle |

Synthèse de cette table :

- **108** variables de saison inventoriées ;
- **15** sources actuelles à conserver comme autoritatives, mais à reloger ou normaliser : `current_day`, six états de route, quatre registres, trois preuves matérielles Mathilde et la résolution de variante média ;
- les quatre résultats tardifs J18–J20 ne sont pas des sources supplémentaires à conserver : leurs valeurs doivent être absorbées dans les six états de route pendant la migration ;
- **87** variables sont marquées `Oui` ou `Partiel` comme dérivables/reconstructibles, dont 62 certaines et 25 partielles ;
- **99** variables présentent une duplication certaine ou partielle, dont 67 certaines et 32 partielles ; ce total inclut les anciennes conclusions reconstructibles depuis un événement de choix et les copies de payload de registre ;
- **16** champs sont classés G parce qu’ils n’ont aucune lecture narrative ultérieure trouvée ou seulement une valeur historique sans consommateur opérationnel ; ils doivent être instrumentés ou convertis en événements, jamais supprimés immédiatement à l’aveugle.

Les totaux « dérivable » et « dupliquée » se recouvrent volontairement : une copie de registre est à la fois dupliquée et dérivable.

## 7. État des providers et de la reprise

Les providers J01–J21 ne contiennent pas un second moteur relationnel. Ils conservent une machine de présentation et de reprise exacte. Les 24 noms de champs de provider observés se répartissent ainsi :

| Famille | Champs observés | Cible |
|---|---|---|
| Références | `state`, `runtime_map`, `conversations`, `segments_by_id` | références runtime non persistantes ou rechargées |
| Livraison cumulée | `transcripts_by_thread`, `produced_message_ids`, `unlocked_thread_ids`, `gallery_asset_ids`, `served_visual_beat_ids`, `presented_time_message_ids` | `PresentationState`, hors `RouteState` |
| Reprise de phase | `initialized`, `phase`, `pending_transition`, `pending_choice_ids_by_thread`, `current_time_minutes`, `day_end_visible` | snapshot du provider actif |
| Curseurs | `segment_index_by_thread`, `selected_pivot`, `selection_audit` | provider ; le pivot présenté devient un événement narratif distinct |
| Scène/média temporaire | `pending_scene_asset_ids`, `pending_scene_character_id` | `scene_context` / présentation |
| Contrôle de reprise | `resume_after_evening`, `resume_after_transition`, `collision_pending_threads` | provider uniquement |

`Season1RuntimeProvider` ajoute les références `j01_provider` à `j21_provider`, `active_provider`, `active_day`, des copies dédiées `j01_snapshot` à `j17_snapshot` et un compteur de restauration. Son `snapshot()` agrège les snapshots des 21 providers. Comme chaque provider reçoit les transcripts, messages, fils et médias cumulés de son prédécesseur, plusieurs snapshots historiques peuvent recopier le même préfixe de livraison. Cette duplication de présentation est réelle mais **orthogonale** à `RouteState`.

Décision de frontière :

- un snapshot narratif ne doit pas stocker la phase UI ;
- un snapshot de provider ne doit pas devenir source de vérité d’un arc ;
- seul le provider actif a besoin de toute la précision de reprise ;
- les journées closes peuvent, dans une phase future séparée, être compactées en checkpoints de livraison, sous réserve de tests de reprise bit-à-bit ;
- cette optimisation n’est ni un prérequis ni une composante de la migration `RouteState`.

## 8. Couplages, duplications et dettes identifiées

### Duplications structurantes

| Groupe actuel | Duplication | Source cible |
|---|---|---|
| `*_state` + `j18/j19/j20_*_outcome` | ancien état et conclusion tardive coexistent | un seul `RouteState.arc_state` + événement de transition |
| `j14_witness`, `j14_discovery_mode`, `j14_visible_*`, `j14_source_trace_id`, réaction | copie du contenu T20/F26 | T20 pour l’événement, F26 pour ce que le témoin sait |
| `j14_player_explanation`, `j14_controller_notified` | copie de F28/F29 et de P15 | `KnowledgeRegistry` et `PromiseRegistry` |
| `j14_j15_obligation_id`, `j15_mode`, `j15_urgent_consequence_remaining` | copies d’identifiant/statut de P14/P17/T21 | registres + règle dérivée |
| échéances/résolutions Marie J05–J10 | statut de promesse répété dans un scalaire | promise + événement terminal |
| `final_trace_state/controller/audience` | copie de la trace choisie | `TraceRegistry[final_trace_id]` |
| `final_posture_options`, `existing_contradiction_id` | vues d’éligibilité persistées | règles de finale sur états et événements |

### Champs G sans consommateur narratif ultérieur trouvé

`marie_make_room_outcome`, `mathilde_welcome_outcome`, `sandra_j03_echo_outcome`, `marie_j03_return_outcome`, `pauline_public_selection_outcome`, `pauline_retained_frame`, `nico_friendship_outcome`, `marie_j05_shared_hour_outcome`, `sandra_j05_outcome`, `nico_j07_continuation_outcome`, `marie_j07_household_outcome`, `marie_j08_entry_outcome`, `raphaelle_j08_preparation_outcome`, `nico_j10_morning_confirmation`, `j14_secondary_trace_id` et, après normalisation de sa transition, le scalaire `raphaelle_j07_mobile_review_outcome`.

Cette liste ne vaut pas autorisation de suppression. Une lecture dynamique depuis des chaînes, un outil d’auteur ou une future saison peut ne pas apparaître dans une recherche statique. La phase 1 doit journaliser les lectures avant toute suppression.

### Écarts de vocabulaire à résoudre explicitement

| Runtime actuel | Canon courant | Politique de migration proposée |
|---|---|---|
| `PROTECTIVE_DISTANCE` | `PROTECTIVE_WITHDRAWAL` | alias d’entrée, écriture canonique uniquement après cutover |
| `CREATIVE_CONFIDENCE` | `CREATIVE_TRUST` | alias d’entrée ; vérifier que le processus créatif est réellement actif |
| `FUTURE_INVITATION` | `BOUNDED_FUTURE_INVITATION` | alias d’entrée ; conserver créneau, Maud et statut de promise |
| Nico `DISTANCE` | `TAKING_DISTANCE` | alias d’entrée, aucune réouverture implicite |
| `RECONFIGURATION_NEGOTIATION` | `RECONFIGURATION_NEGOTIATING` | corriger par migration explicite, jamais par fallback silencieux |

Ces alias sont un pont de compatibilité, pas de nouveaux états canoniques.

### Points H à décider

- `household_rhythm_confirmed` : déterminer s’il s’agit d’un fait durable du foyer, d’une simple conclusion de band initial ou d’une ancienne preuve de présence. Il est explicitement insuffisant comme preuve de présence près de l’écran en J14.
- `j06_external_continuity_resolution` : identifier l’invariant exact qu’il protège avant de le remplacer par un événement ou de le retirer.

## 9. Principes du moteur simplifié

1. **Une source de vérité par concept.** Un statut de promesse appartient au registre de promesses ; une audience appartient à la trace ; une connaissance appartient au registre épistémique ; un état d’arc appartient à `RouteState`.
2. **Les événements expliquent, l’état courant résume.** Toute transition d’arc référence un `event_id`. Rejouer ou auditer la route ne dépend pas d’un champ `jNN_outcome` isolé.
3. **Aucun score obligatoire.** `trust`, `desire`, `intimacy` et `secrecy` sont des enums sémantiques. Ils ne sont ni additionnés, ni moyennés, ni comparés comme une jauge universelle.
4. **Les axes ne donnent aucune permission.** Une forte confiance, un désir mutuel, une intimité antérieure ou un secret partagé ne rend aucune scène disponible à eux seuls.
5. **Le consentement est local à la scène.** Il expire à la fin du contexte, peut être refusé ou retiré et n’est jamais restauré comme permission future.
6. **Fail closed.** Une preuve manquante, un alias inconnu, une audience ambiguë ou une obligation non vérifiable ferme la scène risquée.
7. **Les index sont reconstructibles.** Les listes de promesses, obligations, traces, scènes et médias d’une route ne possèdent jamais le statut de ces objets.
8. **Les transitions sont atomiques.** Un événement, la mutation de route et les écritures de registres associées réussissent ensemble ou pas du tout.
9. **Les règles sont déclaratives et pures.** L’évaluation d’une scène produit des candidats et des raisons ; seul un reducer applique une transition après un événement réel.
10. **Compatibilité avant nettoyage.** Aucune suppression de champ legacy avant double lecture, parité sur les sauvegardes de référence et restauration de l’ancien format.

Le schéma exclut explicitement `affection_score`, `lust_score`, `corruption_score`, `route_points` et `consent_score`.

## 10. Modèle cible `RouteState`

Le noyau commun proposé est une projection par personnage :

```text
RouteState
  character_id: CharacterId
  arc_state: CharacterArcState
  route_status: RouteStatus
  trust: TrustState
  desire: DesireState
  intimacy: IntimacyState
  secrecy: SecrecyState
  last_major_event_id: EventId?
  active_promise_ids: Array[PromiseId]
  active_obligation_ids: Array[ObligationId]
  trace_ids: Array[TraceId]
  unlocked_scene_ids: Array[SceneId]
  unlocked_media_ids: Array[AssetId]
  facts: Dictionary[FactId, RouteFact]
```

`CharacterArcState` reste un enum propre au personnage. C’est l’élément qui préserve la richesse canonique que les axes communs ne peuvent pas exprimer. `RouteStatus` décrit le cycle d’accessibilité de la route, pas la qualité de la relation.

Les champs d’identifiants sont des index matérialisés :

- `active_promise_ids` et `active_obligation_ids` sont reconstruits depuis les registres selon leurs statuts ;
- `trace_ids` est reconstruit depuis les sujets, contrôleurs et relations explicites des traces ;
- `unlocked_scene_ids` est calculé par le moteur de règles ;
- `unlocked_media_ids` est calculé depuis le catalogue, la livraison, les traces et les règles ;
- ils peuvent être exposés par l’API et mis en cache, mais ne doivent pas être la source autoritative de leur contenu.

`RouteFact` est un fait non épistémique, borné et traçable :

```text
RouteFact
  fact_id: FactId
  value: Variant
  source_event_id: EventId
  established_at: NarrativeTime
  superseded_by_event_id: EventId?
```

Un `RouteFact` n’est pas une copie d’une entrée `knowledge`. Il décrit ce qui est établi dans le monde pour la route ; le registre `knowledge` décrit qui sait quoi, avec quelle certitude et quelle partageabilité.

### Registres globaux

```text
NarrativeState
  season_progress
  routes: Dictionary[CharacterId, RouteState]
  events: EventRegistry
  promises: PromiseRegistry
  obligations: ObligationRegistry
  traces: TraceRegistry
  knowledge: KnowledgeRegistry
  media_delivery: MediaDeliveryState
```

Le nouveau `EventRegistry` remplace les tableaux et scalaires historiques par des événements typés :

```text
NarrativeEvent
  event_id
  event_type
  occurred_at
  scene_id
  character_ids
  source_choice_id?
  payload
  caused_by_event_ids
```

### Contexte de scène temporaire

```text
SceneContext
  scene_id
  character_ids
  temporary_conditions
  current_consent: ConsentState
  presented_evidence_ids
  pending_effects
```

`scene_context`, `current_consent` et `temporary_conditions` ne survivent pas comme permissions. Une sauvegarde en milieu de scène peut les conserver dans le snapshot du provider actif uniquement pour restaurer exactement la scène ; à la clôture, seuls les événements effectivement survenus sont commités.

### Vues dérivées non sauvegardées

```text
stage
can_progress
adult_content_available
next_scene_candidates
display_summary
```

Ces vues sont des fonctions pures de l’état autoritatif, des registres, du contenu disponible et du contexte. `adult_content_available` est un filtre d’éligibilité de contenu, jamais une permission relationnelle.

## 11. Enums communs et conservation des distinctions

### `route_status`

| Valeur | Sens |
|---|---|
| `LOCKED` | route non ouverte ; aucune implication négative sur le personnage |
| `OPEN` | route visible mais aucun engagement actif |
| `ACTIVE` | arc actuellement susceptible de progression bornée |
| `PAUSED` | progression suspendue par limite, obligation ou contexte |
| `CLOSED` | arc fermé pour la période courante, sans effacer l’historique |
| `COMPLETED` | conclusion canonique de l’arc atteinte |

### `trust`

`DISTANT`, `CAUTIOUS`, `STABLE`, `PRIVILEGED`, `DAMAGED`, `BROKEN`.

`DAMAGED` et `BROKEN` ne sont pas des scores bas ; ils sont des états qualitatifs avec règles de réparation propres à chaque arc. `PRIVILEGED` ne donne aucun droit sur une audience, une image ou un corps.

### `desire`

`NONE`, `UNEXPRESSED`, `AMBIGUOUS`, `ACKNOWLEDGED`, `MUTUAL`, `CONTAINED`, `WITHDRAWN`.

`CONTAINED` et `WITHDRAWN` ne sont pas « inférieurs » à `MUTUAL`. Ils expriment une décision ou une limite. Pour Nico, la valeur reste `NONE` dans la relation Player/Nico, y compris lorsqu’il devient confident ou garde-fou.

### `intimacy`

| Valeur | Distinction conservée |
|---|---|
| `NONE` | aucun événement d’intimité de cette famille |
| `FLIRTATION` | tension ou jeu reconnu sans contact intime établi |
| `EMOTIONAL` | confidence/intimité émotionnelle, sans inférence physique |
| `SENSUAL` | proximité sensuelle ou baiser ; l’événement précise lequel |
| `SEXUAL_INITIAL` | premier niveau sexuel borné ; Mathilde M-B2 |
| `SEXUAL_EXPLICIT` | niveau explicite supérieur ; Mathilde M-B3, toujours sans pénétration |
| `SEXUAL_ADVANCED` | séquence adulte avancée explicitement définie par le canon de la route |

Décision : les distinctions sont suffisantes **uniquement avec** `arc_state` et l’événement source. `SENSUAL` ne permet pas de confondre M-B1 et le premier baiser Raphaëlle, car `last_major_event_id` et l’historique typé gardent la nature exacte. `PHYSICAL_SECRET` peut résumer M-B2 ou M-B3, comme le canon l’autorise, tandis que l’événement préserve le niveau réellement vécu. Un arrêt ou retrait n’efface pas l’événement antérieur : il modifie `desire`, `trust`, `route_status` ou `arc_state` selon la route.

### `secrecy`

`NONE`, `PUBLIC`, `PRIVATE`, `SECRET`, `COMPROMISED`, `EXPOSED`.

Cet axe décrit la situation de la route, pas l’audience d’une trace particulière. Une route `PRIVATE` peut posséder une trace `PUBLIC_ACTIVE`; une route `COMPROMISED` n’implique pas que toutes ses traces ont été exposées.

### `consent` — scène uniquement

`NOT_ASKED`, `UNCLEAR`, `CONFIRMED`, `REFUSED`, `WITHDRAWN`.

Le consentement est évalué pour une action et un contexte précis. Il n’est ni copié dans `RouteState`, ni dérivé de `desire`, ni reconstruit depuis une intimité passée. Après restauration au milieu d’une scène, le provider doit prouver que l’énoncé ou le geste de consentement a réellement été présenté ; sinon l’état revient à `NOT_ASKED` ou ferme la branche.

## 12. Cartographie des six routes

| Personnage | Variables actuelles | États canoniques | États runtime réellement produits | Champs communs proposés | Faits spécifiques nécessaires |
|---|---|---|---|---|---|
| Marie / couple | `couple_state`; présence/dîner J09–J10; résultats Marie J11–J12; `j16_j17_outcome`; `j17_couple_outcome`; contradiction/finale | `BASELINE_SHARED_LIFE`, `STRAIN_VISIBLE`, `RECONQUEST_ACTIVE`, `PROVISIONAL_AGREEMENT`, `RECONFIGURATION_NEGOTIATING`, `DOUBLE_LIFE_FRAGILE`, `FRACTURE`, `SEPARATION` | `BASELINE_SHARED_LIFE`, `STRAIN_VISIBLE`, puis J17 `RECONQUEST_ACTIVE`, `PROVISIONAL_AGREEMENT`, `FRACTURE` ou `SEPARATION`; le runtime courant ne produit pas les deux autres conclusions canoniques | tous les champs communs ; `arc_state` porte l’état du couple, non une permission sur les routes extérieures | organisation du foyer, présence réelle, checkpoint du couple, mensonge/contradiction, promesses de présence |
| Sandra | `sandra_state`; `sandra_j05_outcome`; J10–J12; trace image; `j18_sandra_outcome` | `DISTANT_FRIEND`, `RECONNECTION_OPEN`, `FRIENDSHIP_RESTORED`, `PRIVILEGED_CONFIDENCE`, `DESIRE_RECOGNIZED_CONTAINED`, `PARALLEL_TENDER_RELATION`, `LATE_INTIMACY`, `PROTECTIVE_WITHDRAWAL`, `TRUST_BROKEN` | état de base `DISTANT_FRIEND`/`RECONNECTION_OPEN`; résultat parallèle J18 `PRIVILEGED_CONFIDENCE`, `FRIENDSHIP_RESTORED`, `PROTECTIVE_DISTANCE` ou `TRUST_BROKEN` | trust, desire, intimacy, secrecy, status et arc ; le retrait n’est pas un simple score bas | identité/contrôleur/audience de l’image, confidence, aftercare, initiative ou retrait Sandra |
| Mathilde | `mathilde_state`; outcomes J06/J08/J10/J11; `j11_physical_level`; `mathilde_j11_state`; trois booléens de sécurité; aftercare; départ J16–J17 | `FAMILY_GUEST`, `DOMESTIC_FAMILIARITY`, `LOOK_ACKNOWLEDGED`, `INTENT_OPEN`, `PROXIMITY_CONSENTED`, `PHYSICAL_SECRET`, `SECRET_SUSPENDED`, `FAMILY_RELATION_PRESERVED`, `DISTANCE`, `TRUST_BROKEN` | `FAMILY_GUEST`, `LOOK_ACKNOWLEDGED`, `INTENT_OPEN`, `PROXIMITY_CONSENTED`, `PHYSICAL_SECRET`, `DISTANCE`, `TRUST_BROKEN`, `FAMILY_RELATION_PRESERVED`; `mathilde_j11_state` en duplique un sous-ensemble | trust, desire, intimacy, secrecy, status et arc ; niveau exact conservé dans l’événement | option de sommeil indépendante, sortie sûre, absence Marie non provoquée, niveau M-B1/B2/B3, aftercare, départ du foyer |
| Pauline | `pauline_state`; outcomes/retained frame J04; trace privée J13; découverte J14; clarification J15; `j19_pauline_outcome` | `PUBLIC_ONLY`, `PRIVATE_TEST`, `SURFACE_RESTORED`, `COMPARTMENT_CLOSED`, `COMPARTMENT_PROTECTED`, `RECIPROCAL_TRACE`, `CONSCIOUS_MARIE_BETRAYAL`, `LIMITED_BASTIEN_COLLISION`, `PRIVATE_CONTACT_LIMITED` | `pauline_state` produit `PUBLIC_ONLY`; résultat parallèle J19 `SURFACE_RESTORED`, `COMPARTMENT_PROTECTED` ou `COMPARTMENT_CLOSED` | trust, desire, intimacy, secrecy, status et arc ; aucun état privé ne rend la surface publique mensongère par défaut | réalité de Bastien, connaissance légitime de Marie, audience des images, contradiction active, contrôleur informé |
| Raphaëlle | `raphaelle_state`; travail J03/J07/J08; image J10/J13; baiser J11; `j19_raphaelle_outcome`; invitation pending | `PROFESSIONAL_ONLY`, `CREATIVE_ACCESS`, `CHOSEN_IMAGE_ACCESS`, `CREATIVE_TRUST`, `BOUNDED_FUTURE_INVITATION`, `ATTRACTION_CONTAINED`, `CLEAR_UNFAITHFUL_SECRET`, `BOUNDARY_REINFORCED`, `COLLEAGUE_ONLY` | `PROFESSIONAL_ONLY`, `CREATIVE_ACCESS`; résultat parallèle J19 `CREATIVE_CONFIDENCE`, `FUTURE_INVITATION`, `BOUNDARY_REINFORCED` ou `COLLEAGUE_ONLY` | trust, desire, intimacy, secrecy, status et arc ; premier baiser `SENSUAL` avec événement spécifique | travail payé, processus respecté, T18/T18B, image choisie, rôle de Maud, invitation et créneau, limite renforcée |
| Nico | `nico_state`; outcomes J04/J07/J10/J11; alibi J13/J14; `j20_context`; `j20_nico_position`; meeting outcome | `ORDINARY_FRIEND`, `CONFIDENCE_ACTIVE`, `GUARDRAIL`, `LIMITED_CONFIDANT`, `HONEST_RIVAL`, `AUTHORIZED_GAZE_PARTNER`, `CONSCIOUS_ACCOMPLICE`, `COMPROMISED_WITNESS`, `TAKING_DISTANCE` | `ORDINARY_FRIEND`, `CONFIDENCE_ACTIVE`; résultat parallèle J20 `ORDINARY_FRIEND`, `GUARDRAIL`, `LIMITED_CONFIDANT` ou `DISTANCE` | trust, secrecy, status et arc ; `desire=NONE`, `intimacy=NONE` pour Player/Nico | confidence, garde-fou, fait d’alibi, dette de complicité, observation exacte, autorisation nominative par la personne concernée |

Règle de mapping tardif : J18–J20 doivent produire une transition de l’arc correspondant, et non un second état parallèle. Les valeurs runtime non canoniques passent par les alias de la section 8. Une valeur canonique jamais atteinte à la baseline reste autorisée par le schéma mais n’est jamais attribuée rétroactivement.

### Cas particulier Marie / couple / foyer

La route Marie représente l’arc du couple pour la saison 1, mais ne doit pas absorber toute la vérité du foyer. Un futur `RelationshipState` cross-entités pourrait devenir pertinent ; R8A n’en a pas besoin pour le pilote. Les faits de logement, de présence et de calendrier restent des événements ou faits de monde référencés par les règles. `routes["marie"].arc_state` est l’équivalent ciblé de `couple_state`, pas une propriété de Marie qui lui ferait porter seule les décisions du couple.

## 13. Règles de scènes déclaratives

Une règle de scène décrit l’éligibilité et les effets à remettre au reducer ; son évaluation ne mute aucun état. La façade d’auteur contient au minimum :

```text
scene_id
character_id
requires
blocks
temporary_requirements
effects
events_created
promises_created
obligations_created
traces_created
knowledge_created
media_unlocked
```

Elle est normalisée en représentation interne bornée :

```text
SceneRule
  rule_id
  scene_id
  character_id
  priority
  all_of[]
  any_of[]
  none_of[]
  required_promise_statuses[]
  required_obligation_statuses[]
  required_trace_predicates[]
  required_knowledge_predicates[]
  required_route_facts[]
  temporary_conditions[]
  block_if_unknown: true
  candidate_reason_code
```

Les prédicats sont bornés et nommés : `route.arc_state_is`, `event.exists`, `promise.status_is`, `trace.audience_contains`, `knowledge.knower_has_fact`, `route.fact_is_true`, `scene.consent_is`. Aucun prédicat arbitraire ne peut écrire dans l’état.

Pipeline :

```text
état autoritatif + contenu + contexte
  → évaluation pure de toutes les règles
  → candidats avec reasons et blockers
  → résolution déterministe de priorité
  → présentation par le provider
  → événement de présentation/choix
  → reducer transactionnel
  → RouteState + registres + événements
```

Exemple de gate Mathilde J11 :

```yaml
rule_id: mathilde_j11_mb3_rule
scene_id: mathilde_j11_mb3
character_id: mathilde
requires:
  route.arc_state: [INTENT_OPEN, PROXIMITY_CONSENTED]
  route.route_status: [OPEN, ACTIVE]
  route.trust: [STABLE, PRIVILEGED]
  route.desire: MUTUAL
  route.intimacy: [SENSUAL, SEXUAL_INITIAL]
  facts.mathilde_has_independent_sleep_option: true
  facts.mathilde_can_leave_safely: true
  facts.marie_absence_not_engineered: true
blocks:
  promise_status: { id: P10, status: ACTIVE }
  obligation_status: { id: aftercare_mathilde_j11, status: FAILED }
temporary_requirements:
  current_consent: CONFIRMED
effects:
  arc_state: PHYSICAL_SECRET
  route_status: PAUSED
  intimacy: SEXUAL_EXPLICIT
  secrecy: SECRET
events_created: [mathilde_j11_mb3_completed]
promises_created: []
obligations_created: [aftercare_mathilde_j11]
traces_created: [j11_mathilde_physical_aftercare_01]
knowledge_created: [fact_mathilde_physical_event_occurred]
media_unlocked: []
block_if_unknown: true
```

`scene.consent_is` n’est évalué qu’après la demande actuelle dans le contexte de scène. Les trois preuves matérielles ne remplacent pas ce consentement.

Exemple de découverte Pauline J14 :

```yaml
rule_id: pauline_j14_limited_discovery
scene_id: j14_pauline
character_id: pauline
all_of:
  - trace.accessible_to: { id: j13_pauline_private_version_01, character: Player }
  - scene.presence_evidence_admissible: Marie
  - scene.evidence_presented_before_selection: true
none_of:
  - trace.state_is: { id: j13_pauline_private_version_01, state: REMOVED }
block_if_unknown: true
```

La règle produit un candidat. Après présentation réelle, le reducer crée T20 et F26 de façon atomique. En l’absence de preuve admissible, il sélectionne la mutation canonique sans découverte et ne crée ni T20, ni F26, ni P14, ni P15.

## 14. Deux parcours de bout en bout

### Mathilde : de la reconnaissance du regard à la conséquence

| Étape narrative | Architecture actuelle | Modèle cible |
|---|---|---|
| Regard reconnu | `mathilde_j06_outcome` puis `mathilde_state=LOOK_ACKNOWLEDGED` | événement `mathilde_look_acknowledged`; transition d’arc, axes inchangés si non prouvés |
| Intention ouverte | `j10_pivot=MATHILDE`, `j10_pivot_outcome`, trace/fact, `mathilde_state=INTENT_OPEN` | événement J10 avec choix et trace ; `arc_state=INTENT_OPEN`, `desire=ACKNOWLEDGED` ou `MUTUAL` selon le résultat exact |
| Contexte matériel sûr | trois booléens persistés | trois `RouteFact` positifs, chacun avec provenance ; absence de l’un ferme la branche |
| Consentement actuel | paramètre `consent_current` de la fonction J11 | `SceneContext.current_consent=CONFIRMED` pour l’action précise ; jamais dans le snapshot de route |
| M-B1 | `j11_physical_level=M_B1`, outcome et état de proximité | événement `mathilde_proximity_consented`; `intimacy=SENSUAL`, `arc_state=PROXIMITY_CONSENTED` |
| M-B2 | niveau + `mathilde_j11_state` + `mathilde_state=PHYSICAL_SECRET` | événement `mathilde_physical_m_b2`; `intimacy=SEXUAL_INITIAL`, `secrecy=SECRET`, `arc_state=PHYSICAL_SECRET` |
| M-B3 | même état courant que M-B2, niveau dans le champ historique | événement `mathilde_physical_m_b3`; `intimacy=SEXUAL_EXPLICIT`, payload `penetration=false`, même `arc_state` |
| Arrêt/refus/retrait | outcome/état spécifique, souvent mêlé au niveau | événement typé `refused`, `stopped` ou `consent_withdrawn`; aucune sécurité matérielle n’est modifiée ; statut/axes suivent la règle canonique |
| Aftercare | trace J11, knowledge fact, obligation `aftercare_mathilde_j11`, marqueur J12 en cas d’échec | obligation autoritative référant l’événement physique ; paiement/échec terminal par événement ; aucun booléen d’idempotence global |
| Conséquence et départ | `j12_failed_aftercare_processed`, priorité J13/J16, `j16_departure_state`, `j17_departure_outcome` | événements de conséquence et départ ; mutation finale de `arc_state`, trust et route_status ; knowledge séparée par knower |
| Finale | plusieurs champs historiques restent présents | `RouteState` résume ; l’historique explique exactement M-B1/B2/B3, arrêt, aftercare et départ |

Ce parcours démontre pourquoi `intimacy` seul serait insuffisant. Le niveau commun sert aux règles générales et à l’UI ; l’événement signé conserve le geste exact, le consentement actuel, les limites et l’absence de pénétration de M-B3.

### Pauline : de la trace privée au compartiment final

| Étape narrative | Architecture actuelle | Modèle cible |
|---|---|---|
| Surface publique | `pauline_state=PUBLIC_ONLY`, outcome J04 | `arc_state=PUBLIC_ONLY`; événement public conservé sans déclarer la surface fausse |
| Test privé | priorité/outcome J13 et `j13_j14_trace_id` | événement de route ; `arc_state=PRIVATE_TEST`; trace privée autoritative avec contrôleur/audience |
| Audience limitée | métadonnées dans la trace J13 | uniquement `TraceRegistry`; `routes.pauline.trace_ids` est un index |
| Découverte | `j14_variant`, témoin, présence, mode, champs/valeurs, source | contexte de scène puis T20/F26 atomiques après présentation ; pas de copie dans `RouteState` |
| Vérité, mensonge ou protection | `j14_outcome`, réaction et explication | événement de choix ; mise à jour de `secrecy` et éventuellement trust ; facts de connaissance séparés |
| Contrôleur informé | booléen + P15 + knowledge fact | statut P15 et knowledge fact uniquement |
| Clarification | `j15_mode/outcome/urgent_*` + P14/P17/T21 | règle dérivée depuis registres ; événement terminal, pas de cache durable |
| Conclusion J19 | `j19_pauline_outcome` tandis que `pauline_state` peut rester ancien | transition unique vers `SURFACE_RESTORED`, `COMPARTMENT_CLOSED` ou `COMPARTMENT_PROTECTED` |
| Contradiction finale | `existing_contradiction_id` calculé et persisté | contradiction active dérivée de l’événement/arc ; options J21 recalculées |

Ce parcours exerce l’état de route, le secret, l’audience, la connaissance, les promesses et la contradiction sans introduire le risque supplémentaire d’une gate de consentement physique.

## 15. Sources de vérité et politique de persistance

| Question | Source de vérité | Vue/index autorisé | Interdit |
|---|---|---|---|
| Quel est l’état actuel d’un arc ? | `RouteState.arc_state` | `display_summary`, `stage` | conserver un second `jNN_outcome` courant |
| La route est-elle ouverte/active/fermée ? | `RouteState.route_status` | `can_progress` | déduire d’un score ou d’un ancien consentement |
| Quel événement a provoqué la transition ? | `EventRegistry` + `last_major_event_id` | historique filtré par personnage | payload historique dans des scalaires courants |
| Une promesse est-elle due/payée/échouée ? | `PromiseRegistry` | `active_promise_ids` | booléen parallèle |
| Une obligation est-elle due ? | `ObligationRegistry` | `active_obligation_ids` | pivot ou priorité comme substitut |
| Qui contrôle/voit une trace ? | `TraceRegistry` | `trace_ids` | copie `final_trace_audience` ou `j14_source_trace_id` comme vérité |
| Qui sait un fait ? | `KnowledgeRegistry` | requête par knower/fact | `RouteState.facts` utilisé comme connaissance universelle |
| Un fait matériel de route est-il établi ? | `RouteState.facts` avec source_event | prédicat de règle | booléen sans provenance |
| Le consentement actuel est-il confirmé ? | `SceneContext` du provider actif | événement signé après l’action | tout champ persistant de route |
| Une scène est-elle disponible ? | `SceneRuleEngine` | `unlocked_scene_ids`, `next_scene_candidates` | liste persistée autoritative |
| Un média peut-il être servi ? | catalogue + traces + `MediaDeliveryState` + règles | `unlocked_media_ids` | état d’intimité comme permission média |
| Où reprendre l’UI ? | snapshot du provider actif | checkpoint de livraison | `RouteState` |
| Quelle trace finale a été sélectionnée ? | événement `final_trace_selected` → `trace_id` | propriétés lues dans `TraceRegistry` | copie de state/controller/audience |

### Snapshot cible

Le sous-snapshot autoritatif d’une route persiste `character_id`, `arc_state`, `route_status`, les quatre axes, `last_major_event_id` et les `facts`. Les cinq listes d’identifiants peuvent être matérialisées pour le temps de chargement, mais la restauration doit les reconstruire et vérifier leur égalité ; une divergence échoue fermée ou invalide le cache, jamais le registre.

Le snapshot narratif persiste les registres globaux et les événements. Les vues `stage`, `can_progress`, `adult_content_available`, `next_scene_candidates` et `display_summary` ne sont jamais sauvegardées.

Le snapshot du provider actif persiste la phase, les lots présentés, les choix en attente et, si nécessaire, le contexte de scène. Lors d’une reprise au milieu d’une scène sensible, toute condition dépendant d’une présentation réelle est vérifiée contre les messages présentés avant d’être restaurée.

## 16. Plan de migration réversible, phases 0 à 5

Ce plan est futur ; aucune phase n’est implémentée par ce blueprint.

| Phase | Changement | Preuve de sortie | Retour arrière |
|---|---|---|---|
| 0 — Blueprint | le présent audit et les décisions produit ; documentation uniquement, aucune sémantique ni snapshot modifié | validation produit des enums, sources de vérité, pilote et points H | modifier ou refuser le blueprint, aucun runtime à annuler |
| 1 — `RouteSummary` calculé | introduire `get_route_summary(character_id)` / `RouteStateView` en lecture seule depuis v25, aliases canoniques et instrumentation des lectures ; aucun changement de snapshot | résumé stable, usages dynamiques identifiés, champs G mesurés | feature flag revient aux lectures directes |
| 2 — Tests d’équivalence | signer corpus de snapshots v25, golden summaries, décisions de scènes et replays ; prototyper règles pures sans changer les écritures | parité des candidats, traces, audiences, knowledge, promises, obligations, médias et finales | retirer la projection et les tests nouveaux sans toucher aux données |
| 3 — Personnage pilote | basculer Pauline sur les lectures `RouteSummary` et règles J13/J14/J15/J19/J21 sous flag ; état legacy et snapshot v25 restent autoritatifs | mêmes scènes et sorties observables pour chaque fixture, shadow-read sans divergence | flag Pauline repasse intégralement à legacy |
| 4 — Persistance commune | allouer une future version de snapshot ; introduire `routes` et `events`, reducer et double écriture ; Pauline puis Mathilde, ensuite autres routes par lots | migration v25, round-trip nouveau, parité champ/événement, aucune permission nouvelle | lecteur v25 + flag par route ; ignorer le nouveau bloc pendant la fenêtre |
| 5 — Dépréciation progressive | supprimer un champ legacy seulement sans lecteur, avec migrations et tests prouvés ; généraliser Sandra, Raphaëlle, Nico puis Marie/couple selon le risque | télémétrie sans lecture legacy, six routes validées, corpus produit identique | conserver migrateur v25 et ancien chemin tant que la fenêtre n’est pas close |

### Règles de migration

- La migration v25 est déterministe, explicite et idempotente.
- Les alias de vocabulaire sont appliqués uniquement à la lecture de valeurs connues ; une valeur inconnue bloque la restauration.
- Les résultats J18–J20 écrasent l’ancien `*_state` uniquement lorsqu’un événement/source canonique prouve qu’ils sont établis.
- M-B2 et M-B3 migrent vers le même `arc_state=PHYSICAL_SECRET` mais vers deux `intimacy` et deux événements distincts.
- Les trois preuves Mathilde ne sont vraies que si elles le sont dans v25 ; aucune valeur par défaut favorable.
- Les données J14 sont reconstruites depuis T20/F26/P14/P15 lorsque cohérentes. Une contradiction entre scalaire et registre bloque ou reste sur le lecteur legacy ; elle n’est pas arbitrée silencieusement.
- Les pivots historiques deviennent des événements de sélection avec raison, afin d’éviter qu’un recalcul sur l’état final change le passé.
- Aucun champ G n’est retiré tant que l’instrumentation n’a pas démontré l’absence de lecture et que son éventuelle valeur historique n’a pas été conservée par événement.

## 17. Stratégie de tests, risques et choix du pilote

### Stratégie de tests d’équivalence

Le principe est « mêmes entrées historiques, mêmes sorties observables ». Pour chaque sauvegarde de référence et chaque chemin smoke :

1. charger le snapshot v25 avec le runtime legacy ;
2. produire un `LegacyNarrativeSummary` normalisé : jour, arcs, scènes candidates, choix, traces avec états/contrôleurs/audiences, promises, obligations, knowledge, médias servis et options finales ;
3. migrer ou projeter vers le modèle cible ;
4. produire le même résumé via les nouvelles API ;
5. comparer strictement, avec une table d’alias explicite pour les quatre enums divergents ;
6. rejouer le prochain choix dans les deux moteurs et comparer l’événement, les registres, la scène suivante et le snapshot round-trip.

Suites à conserver et étendre lors d’une implémentation future :

- tests J10 : sélecteur pur, 22 outcomes bornés, absence de mutations rétroactives ;
- J11 : exclusivité du pivot, gates de conséquence, distinctions M-B1/B2/B3 et consentement actuel ;
- J12 : aftercare, distinctions épistémiques, migrations fail-closed ;
- J13 : obligation autoritative, livraison atomique, trace accessible à Player ;
- J14 C1 : preuve de présence, fallback sans découverte, exhaustivité T20/F26, P14/P15 après présentation, corruption refusée ;
- J15 : contrat amendé `NO_COLLISION`, aucune promesse rétroactive ;
- J16–J21 : handoffs, records/facts, conclusion des routes et finale ;
- restauration globale : ordre state puis provider, versions exactes, reprise de toutes les phases ;
- tests nouveaux par propriété : un consentement passé n’ouvre aucune scène, une trace retirée ne redevient pas active, un statut terminal ne redevient pas actif, un état de fermeture ne progresse pas sans nouvel événement.

### Matrice de risques

| Risque | Probabilité | Impact | Mitigation | Test exigé |
|---|---|---|---|---|
| Perte d’une branche cachée par lecture dynamique d’un champ G | Moyenne | Élevé | instrumentation phase 1, recherche runtime/outils, fenêtre de shadow-read | couverture de lecture + replays complets |
| Alias d’enum modifiant le sens canonique | Élevée | Élevé | mapping revu par narrative design, provenance conservée | fixtures par valeur runtime et état canonique attendu |
| Consentement reconstruit comme permission persistante | Faible si design respecté | Critique | interdit au schéma, scène fail-closed, revue dédiée Mathilde/Raphaëlle/Sandra | reprise avant/après demande, refus et retrait |
| Double écriture divergente | Moyenne | Élevé | transaction atomique, assertions de shadow parity | fuzz des reducers + rollback injecté |
| Registre et index de route désynchronisés | Moyenne | Élevé | registres autoritatifs, index reconstruits au restore | corruption volontaire des caches |
| Ordre historique des pivots perdu | Moyenne | Élevé | événement `route_selected` avec reason et timestamp | replay sur J10–J13 avec tie-breaks |
| Audience ou connaissance élargie | Faible | Critique | traces et knowledge séparés, pas de copie générique | matrices par knower/audience J13–J15/J21 |
| Atteignabilité involontaire d’un état canonique jamais produit | Moyenne | Élevé | migration factuelle, pas de valeur par défaut favorable | enumerate reachable states avant/après |
| Régression de reprise provider | Moyenne | Élevé | migration RouteState indépendante de la compaction provider | snapshots de toutes les phases J14/J15 |
| Explosion de complexité du moteur de règles | Moyenne | Moyen | petit DSL borné, prédicats nommés, pas de script arbitraire | validation de schéma + golden reasons |
| Marie/couple aplati en route individuelle | Moyenne | Élevé | règle spéciale documentée, faits de foyer hors route | scénarios J17/J21 et invariants cross-route |
| Médias réouverts par un axe d’intimité | Faible | Critique | catalogue+trace+delivery autoritatifs | tests assets retirés/servis et round-trip |
| Croissance non bornée du registre d’événements | Élevée | Moyen | événements compacts, index par saison/personnage, archivage sans perte de provenance | budget de taille et replay sur plusieurs saisons |
| Scène multi-personnages attribuée à une seule route | Moyenne | Élevé | événement à plusieurs `character_ids`, effets atomiques par route, faits de monde séparés | scénarios J14/J17/J21 avec ordre d’effets permuté |
| Extension future incompatible avec les enums communs | Moyenne | Moyen | versionner le schéma, garder `arc_state` spécifique et payload événement extensible | fixture de saison/extension avec enum inconnu fail-closed |

### Pilote : Mathilde ou Pauline

| Critère | Mathilde | Pauline |
|---|---|---|
| Richesse d’état de route | Très élevée : arc, désir, intimité, secret, départ | Élevée : arc, secret, confiance, contradiction |
| Registres exercés | trace, knowledge, obligation, faits matériels | trace, audience, knowledge, promises, contradiction |
| Risque | Critique : consentement, dépendance matérielle, aftercare, foyer | Élevé mais plus borné : confidentialité et mensonge |
| Couplage inter-routes | Marie, foyer, priorités J12/J16/J17 | Marie, contrôleur de trace, finale J21 |
| Facilité de preuve d’équivalence | Moyenne | Bonne, grâce aux contrats T20/F26/P14/P15 très testés |
| Valeur comme premier pilote | Excellente en second pour prouver les gates physiques | Meilleur équilibre richesse/risque pour le premier cutover |

**Recommandation : Pauline en premier pilote**, puis Mathilde immédiatement après. Pauline couvre presque toutes les frontières du modèle — arc, événement, trace, audience, connaissance, promesse, secret et contradiction — sans faire du premier cutover le lieu où valider aussi la sécurité matérielle et le consentement physique. Mathilde reste le test décisif qui doit réussir avant généralisation des routes adultes.

## 18. Décisions, questions produit et critères d’acceptation

### Décisions proposées pour validation produit/architecture

1. Adopter `RouteState` comme résumé par personnage et `EventRegistry` comme historique, sans score relationnel.
2. Garder `promises`, `obligations`, `traces` et `knowledge` comme registres spécialisés autoritatifs.
3. Considérer les listes d’identifiants de `RouteState` comme des index reconstructibles.
4. Valider les enums communs des sections 10–11, notamment la distinction M-B1/M-B2/M-B3 par `intimacy` **et** événement.
5. Valider Pauline comme pilote, Mathilde comme second passage obligatoire.
6. Valider la normalisation des quatre valeurs runtime divergentes et de la faute `RECONFIGURATION_NEGOTIATION` par aliases de migration explicites.
7. Décider l’ownership de `household_rhythm_confirmed` et `j06_external_continuity_resolution` avant de clore la phase 0.
8. Ne pas coupler la migration RouteState à une éventuelle compaction des snapshots de providers.

### Lots suivants recommandés

| Lot futur | Objet | Condition d’entrée |
|---|---|---|
| R8B | `RouteSummary` en lecture seule, instrumentation et corpus v25 | décisions de ce blueprint validées |
| R8C | harness d’équivalence, règles pures et golden reasons | API R8B stable |
| R8D | pilote Pauline sous feature flag, sans nouveau snapshot | parité R8C complète |
| R8E | persistance `routes/events` et second pilote Mathilde | pilote Pauline validé produit et sécurité |
| R8F | migration route par route et dépréciation mesurée | migration v25/round-trip prouvés |

### Critères d’acceptation d’une future implémentation

- chaque transition de route possède un événement source ;
- aucune scène nouvelle, aucun média nouveau et aucun état canonique supplémentaire ne devient atteignable sans décision produit ;
- les traces, audiences, connaissances, promesses et obligations sont identiques sur le corpus de parité ;
- le consentement n’apparaît dans aucun snapshot de route et toute reprise ambiguë ferme la branche ;
- les snapshots v25 se restaurent et migrent sans valeur favorable inventée ;
- les pivots historiques restent ceux réellement présentés ;
- les six routes conservent leurs invariants et leurs distinctions propres ;
- l’ancien chemin peut être réactivé par route pendant la fenêtre de compatibilité ;
- les champs legacy ne sont retirés qu’après mesure, double écriture, shadow-read et validation narrative ;
- les suites statiques et smoke existantes restent vertes et les nouveaux tests d’équivalence passent.

### Livrable R8A

Ce blueprint est le seul fichier ajouté. Aucun fichier runtime, test, outil, JSON, snapshot, asset, dialogue ou registre n’est modifié. Il ne crée ni PR, ni merge, ni tag et ne modifie pas `main`.

Verdict final : **READY_FOR_PRODUCT_REVIEW**.
