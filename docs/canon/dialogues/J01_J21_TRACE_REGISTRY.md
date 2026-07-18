# Réseau Intime — Registre canonique des traces J01–J21

## Statut

**Catégorie : Contrat narratif pré-runtime**

**Périmètre : traces diégétiques et états d’accès capables de modifier une branche**

Ce document définit les identifiants canoniques des traces de la saison 1.

Il ne recense pas :

- chaque image de scène non diégétique ;
- chaque message ordinaire ;
- chaque objet de décor ;
- chaque visuel encore à produire.

Une entrée existe ici uniquement si elle peut :

- être vue par un nouveau témoin ;
- modifier une connaissance ;
- créer une dette ou une obligation ;
- être retirée ;
- devenir une preuve ;
- être recontextualisée en J21 ;
- conditionner une branche.

---

# 1. Règle fondamentale

```text
IMAGE_DE_SCÈNE != TRACE_DIÉGÉTIQUE
```

Une image de scène sert au joueur.

Elle ne peut pas :

- apparaître dans le téléphone d’un personnage ;
- être transférée ;
- être découverte en J14 ;
- devenir une preuve ;
- être choisie comme trace finale J21.

Pour être utilisée narrativement, une trace doit posséder un `trace_id` présent dans ce registre.

---

# 2. Schéma canonique

Chaque trace utilise les champs suivants :

```text
trace_id
trace_type
source_day
source_scene
creator
subjects
owner
initial_audience
current_audience
storage_location
saving_rule
transfer_rule
current_state
removed_at
replaces_or_derives_from
discoverable_by
knowledge_created
eligible_for_j14
eligible_for_j21
legacy_runtime_alias
```

## 2.1 `trace_type`

Valeurs bornées :

```text
PHOTO
PHOTO_SET
TEXT_MESSAGE
NOTIFICATION
ACCESS_GRANT
ACCESS_REVOCATION
PHYSICAL_PRINT
ABSENCE_MARKER
FACT_RECORD
```

## 2.2 `current_state`

Valeurs bornées :

```text
ACTIVE
PRIVATE_ACTIVE
PUBLIC_ACTIVE
RESTRICTED
REMOVED
DELETED
INACCESSIBLE
EXPIRED
SUPERSEDED
NOT_CREATED
```

## 2.3 Audience

Une audience est une liste de personnes ou de groupes nommés.

Interdit :

```text
friends
private people
authorized viewers
social circle
```

sans identifiants résolus.

## 2.4 Sauvegarde et transfert

```text
saving_rule:
NONE
IN_THREAD_ONLY
DEVICE_ALLOWED
OWNER_ONLY
PUBLIC_SOURCE_RULES

transfer_rule:
FORBIDDEN
SAME_AUDIENCE_ONLY
OWNER_CONFIRMATION_REQUIRED
PUBLIC_SOURCE_RULES
```

Voir une trace ne donne jamais automatiquement le droit de la sauvegarder ou de la transférer.

---

# 3. Traces d’ouverture J01–J06

## T01 — Photographie du déjeuner Sandra

```text
trace_id: j01_sandra_lunch_memory_soft
trace_type: PHOTO
source_day: J01
source_scene: conversation Sandra photo du dernier déjeuner
creator: Sandra
subjects: [Sandra]
owner: Sandra
initial_audience: [Sandra, Player]
current_audience: variable selon Sandra
storage_location: fil Player / Sandra ou stockage Sandra
saving_rule: IN_THREAD_ONLY par défaut
transfer_rule: FORBIDDEN
current_state: ACTIVE, RESTRICTED, REMOVED ou INACCESSIBLE
removed_at: null ou jour de retrait Sandra
replaces_or_derives_from: null
discoverable_by: Player seulement sauf changement d’audience explicite
knowledge_created: fact_player_saw_sandra_lunch_photo
eligible_for_j14: true si encore affichable
eligible_for_j21: true
legacy_runtime_alias: j1_sandra_lunch_memory_soft
```

Règles :

- Sandra a sélectionné cette image ;
- Player ne peut pas l’envoyer à Nico, Marie ou un groupe ;
- une impression J18 dérive de cette trace mais possède un propriétaire différent ;
- si Sandra retire l’accès, la connaissance demeure mais le fichier ne revient pas.

## T02 — Trace d’arrivée Mathilde

```text
trace_id: j02_mathilde_arrival_room_01
trace_type: FACT_RECORD
source_day: J02
source_scene: installation de Mathilde
creator: none
subjects: [Mathilde, foyer]
owner: état narratif du foyer
initial_audience: non applicable
current_audience: non applicable
storage_location: état narratif du foyer
saving_rule: NONE
transfer_rule: FORBIDDEN
current_state: ACTIVE
knowledge_created: fact_mathilde_stay_started
eligible_for_j14: false par défaut
eligible_for_j21: false
legacy_runtime_alias: mathilde_arrival_room_01
```

Si aucun créateur exact n’est choisi, cette entrée reste `FACT_RECORD` et ne peut jamais être affichée comme photo en J21.

## T03 — Trace La Verrière Marie d’ouverture

```text
trace_id: j03_marie_laverriere_setup_01
trace_type: FACT_RECORD
source_day: J03
source_scene: vie professionnelle Marie établie
creator: none
subjects: [Marie]
owner: état narratif La Verrière
initial_audience: non applicable
current_audience: non applicable
storage_location: registre de connaissances
saving_rule: NONE
transfer_rule: FORBIDDEN
current_state: ACTIVE
knowledge_created: fact_marie_laverriere_world_exists
eligible_for_j14: false
eligible_for_j21: false
legacy_runtime_alias: marie_laverriere_setup_01
```

Cette entrée ne doit pas conserver une origine J03 incompatible après consolidation J03–J04.

## T04 — Set public Pauline / Bastien / groupe

```text
trace_id: j04_pauline_bastien_public_set_01
trace_type: PHOTO_SET
source_day: J04
source_scene: réseau social Pauline / Bastien
creator: Pauline via retardateur
subjects: [Pauline, Bastien, groupe nommé]
owner: Pauline
initial_audience: groupe social nommé
current_audience: groupe social nommé
storage_location: fil de groupe / dossier social
saving_rule: PUBLIC_SOURCE_RULES
transfer_rule: PUBLIC_SOURCE_RULES
current_state: PUBLIC_ACTIVE
knowledge_created: fact_public_pauline_bastien_version_exists
eligible_for_j14: false seul
eligible_for_j21: true
legacy_runtime_alias: aucun alias automatique
```

Le legacy `laverriere_public_group_photo_set_01` ne peut pas être mappé ici sans réconciliation de son origine.

## T05 — État du regard Mathilde J06

```text
trace_id: j06_mathilde_look_acknowledged_01
trace_type: TEXT_MESSAGE
source_day: J06
source_scene: tenue domestique ordinaire / regard remarqué
creator: Mathilde et Player par messages
subjects: [Mathilde, Player]
owner: fil Player / Mathilde
initial_audience: [Mathilde, Player]
current_audience: [Mathilde, Player]
storage_location: fil Player / Mathilde
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: ACTIVE ou INACCESSIBLE
knowledge_created: fact_mathilde_knows_player_noticed_her
eligible_for_j14: true seulement comme notification textuelle crédible
eligible_for_j21: false
legacy_runtime_alias: null
```

Cette trace ne crée ni intention sexuelle Mathilde ni route automatique.

---

# 4. Traces J07–J09

## T06 — Confidence Nico

```text
trace_id: j07_nico_confidence_01
trace_type: TEXT_MESSAGE
source_day: J07
source_scene: confidence calme Nico
creator: Player et Nico
subjects: [Player, Nico]
owner: fil Player / Nico
initial_audience: [Player, Nico]
current_audience: [Player, Nico]
storage_location: fil Player / Nico
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: ACTIVE, RESTRICTED ou INACCESSIBLE
knowledge_created: fact_nico_received_player_confidence
eligible_for_j14: true si aperçu crédible
eligible_for_j21: false sauf comme absence ou dette Nico
legacy_runtime_alias: null
```

## T07 — Préparation privée robe noire Marie

```text
trace_id: j09_marie_black_dress_private_01
trace_type: PHOTO
source_day: J09
source_scene: préparation avant La Verrière
creator: Marie
subjects: [Marie]
owner: Marie
initial_audience: [Marie, Player]
current_audience: [Marie, Player] sauf retrait
storage_location: fil couple
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: PRIVATE_ACTIVE, REMOVED ou INACCESSIBLE
knowledge_created: fact_player_received_marie_chosen_black_dress_image
eligible_for_j14: true
eligible_for_j21: true
legacy_runtime_alias: null
```

## T08 — Marie visible à La Verrière

```text
trace_id: j09_marie_laverriere_public_01
trace_type: PHOTO
source_day: J09
source_scene: événement La Verrière
creator: Élodie
subjects: [Marie, participants visibles]
owner: créateur ou La Verrière
initial_audience: groupe photographié / canal social nommé
current_audience: audience sociale initiale
storage_location: dossier La Verrière / fil social
saving_rule: PUBLIC_SOURCE_RULES
transfer_rule: PUBLIC_SOURCE_RULES
current_state: PUBLIC_ACTIVE
knowledge_created: fact_marie_public_professional_version_visible
eligible_for_j14: true seulement en juxtaposition avec une trace privée
eligible_for_j21: true
legacy_runtime_alias: null
```

## T09 — Fin de soirée Marie relayée à Player

```text
trace_id: j09_marie_laverriere_after_01
trace_type: PHOTO
source_day: J09
source_scene: fermeture ou fin de soirée
creator: Élodie
subjects: [Marie]
owner: Marie ou Élodie selon accord final
initial_audience: [Marie, groupe autorisé]
current_audience: ajoute Player seulement si Marie relaie
storage_location: fil Marie / Player après relais
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN hors audience
current_state: PRIVATE_ACTIVE, PUBLIC_ACTIVE ou NOT_CREATED
knowledge_created: fact_marie_recontextualized_evening_for_player
eligible_for_j14: true
eligible_for_j21: true
legacy_runtime_alias: null
```

---

# 5. Traces J10–J11

## T10 — Tenue choisie Mathilde

```text
trace_id: j10_mathilde_outfit_choice_01
trace_type: PHOTO
source_day: J10
source_scene: Mathilde choisit l’effet de sa tenue
creator: Mathilde
subjects: [Mathilde]
owner: Mathilde
initial_audience: [Mathilde, Player]
current_audience: [Mathilde, Player] sauf retrait
storage_location: fil Player / Mathilde
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: PRIVATE_ACTIVE, REMOVED ou INACCESSIBLE
knowledge_created: fact_mathilde_chose_player_as_outfit_audience
eligible_for_j14: true
eligible_for_j21: true seulement si encore accessible et pertinente
legacy_runtime_alias: null
```

## T11 — Image choisie Sandra

```text
trace_id: j11_sandra_chosen_image_01
trace_type: PHOTO
source_day: J11
source_scene: S19 photographie choisie
creator: Sandra
subjects: [Sandra]
owner: Sandra
initial_audience: [Sandra, Player]
current_audience: [Sandra, Player] si maintenue
storage_location: fil Player / Sandra
saving_rule: IN_THREAD_ONLY par défaut
transfer_rule: FORBIDDEN
current_state: PRIVATE_ACTIVE, REMOVED ou INACCESSIBLE
knowledge_created: fact_sandra_chose_private_image_for_player
eligible_for_j14: true
eligible_for_j21: true
legacy_runtime_alias: null
```

Une mutation avancée peut autoriser la conservation dans le fil pour cette image précise.

Elle ne crée jamais une règle générale.

## T12 — Image choisie Raphaëlle après processus

```text
trace_id: j11_raphaelle_chosen_result_01
trace_type: PHOTO
source_day: J11
source_scene: S21 continuation
creator: Maud
subjects: [Raphaëlle]
owner: Raphaëlle ou Maud selon accord de production final
initial_audience: [Raphaëlle, Maud]
current_audience: ajoute Player si Raphaëlle l’envoie
storage_location: fil Player / Raphaëlle
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: PRIVATE_ACTIVE, REMOVED ou INACCESSIBLE
knowledge_created: fact_raphaelle_chose_player_for_result_image
eligible_for_j14: true
eligible_for_j21: true
legacy_runtime_alias: null
```

## T13 — Après-coup physique Mathilde

```text
trace_id: j11_mathilde_physical_aftercare_01
trace_type: TEXT_MESSAGE
source_day: J11
source_scene: après-coup Mathilde si passage physique éligible
creator: Mathilde et Player
subjects: [Mathilde, Player, Marie comme personne affectée]
owner: fil Player / Mathilde
initial_audience: [Mathilde, Player]
current_audience: [Mathilde, Player]
storage_location: fil Player / Mathilde
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: ACTIVE ou NOT_CREATED
knowledge_created: fact_mathilde_physical_event_requires_consequence
eligible_for_j14: true comme notification textuelle seulement
eligible_for_j21: false
legacy_runtime_alias: null
```

---

# 6. Traces de convergence J12

## T14 — Set public La Verrière J12

```text
trace_id: j12_laverriere_public_group_set_01
trace_type: PHOTO_SET
source_day: J12
source_scene: convergence La Verrière
creator: Élodie
subjects: participants réellement présents
owner: La Verrière ou créateur final
initial_audience: groupe photographié / canal La Verrière nommé
current_audience: audience initiale
storage_location: groupe social ou dossier La Verrière
saving_rule: PUBLIC_SOURCE_RULES
transfer_rule: PUBLIC_SOURCE_RULES
current_state: PUBLIC_ACTIVE
knowledge_created: fact_j12_laverriere_public_versions_coexisted
eligible_for_j14: true en comparaison avec une version privée
eligible_for_j21: true
legacy_runtime_alias: laverriere_public_group_photo_set_01 seulement après source reconciliation
```

## T15 — Set public L’Annexe J12

```text
trace_id: j12_annexe_public_group_set_01
trace_type: PHOTO_SET
source_day: J12
source_scene: continuation sociale à L’Annexe
creator: Sophie
subjects: participants réellement présents
owner: Sophie
initial_audience: groupe photographié nommé
current_audience: audience initiale
storage_location: fil social / dossier L’Annexe
saving_rule: PUBLIC_SOURCE_RULES
transfer_rule: PUBLIC_SOURCE_RULES
current_state: PUBLIC_ACTIVE ou NOT_CREATED selon branche
knowledge_created: fact_j12_annexe_social_overlap_visible
eligible_for_j14: true
eligible_for_j21: true
legacy_runtime_alias: null
```

## T16 — Publication publique Sandra consultée

```text
trace_id: j12_sandra_public_context_view_01
trace_type: NOTIFICATION ou FACT_RECORD
source_day: J12
source_scene: Sandra absente voyant une publication publique
creator: canal public La Verrière
subjects: [Marie ou groupe visible]
owner: source publique
initial_audience: audience publique nommée incluant Sandra
current_audience: identique
storage_location: source publique
saving_rule: PUBLIC_SOURCE_RULES
transfer_rule: PUBLIC_SOURCE_RULES
current_state: ACTIVE ou NOT_CREATED
knowledge_created: fact_sandra_saw_public_j12_context
eligible_for_j14: false
eligible_for_j21: false
legacy_runtime_alias: null
```

---

# 7. Traces de conséquence J13–J16

## T17 — Version privée Pauline J13

```text
trace_id: j13_pauline_private_version_01
trace_type: PHOTO
source_day: J13
source_scene: S24 les deux versions
creator: Élodie, source j12_laverriere_public_group_set_01
selected_by: Pauline
subjects: [Pauline]
owner: Pauline
initial_audience: [Pauline]
current_audience: ajoute Player si envoi
storage_location: fil Player / Pauline
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN
current_state: PRIVATE_ACTIVE, REMOVED ou INACCESSIBLE
knowledge_created: fact_pauline_created_private_double_address
eligible_for_j14: true
eligible_for_j21: true
legacy_runtime_alias: null
```

Le créateur ne peut plus rester `Pauline ou personne autorisée` au moment de l’intégration.

## T18 — Version masquée Raphaëlle

```text
trace_id: j13_raphaelle_masked_version_01
trace_type: PHOTO ou ACCESS_GRANT selon variante
source_day: J13
source_scene: S25 le masque change la posture
creator: Maud ou créateur exact établi en J11
subjects: [Raphaëlle]
owner: Raphaëlle
initial_audience: [Raphaëlle, Maud]
current_audience: ajoute Player si Raphaëlle choisit
storage_location: fil Player / Raphaëlle ou compte créatif
saving_rule: IN_THREAD_ONLY ou OWNER_ONLY
transfer_rule: FORBIDDEN
current_state: PRIVATE_ACTIVE, RESTRICTED, REMOVED ou NOT_CREATED
knowledge_created: fact_raphaelle_private_role_version_exists
eligible_for_j14: true
eligible_for_j21: true
legacy_runtime_alias: null
```

## T19 — Message d’heure ou d’alibi Nico

```text
trace_id: j13_nico_alibi_or_hour_message_01
trace_type: TEXT_MESSAGE
source_day: J13 ou antérieur selon branche réelle
source_scene: S26 Nico demande ou reçoit une version
creator: Player et Nico
subjects: [Player, Nico, personne affectée par l’heure]
owner: fil Player / Nico
initial_audience: [Player, Nico]
current_audience: [Player, Nico]
storage_location: fil Player / Nico
saving_rule: IN_THREAD_ONLY
transfer_rule: FORBIDDEN sauf réponse factuelle directe ultérieure
current_state: ACTIVE, RESTRICTED, INACCESSIBLE ou NOT_CREATED
knowledge_created: fact_nico_knows_specific_hour_or_alibi_request
eligible_for_j14: true
eligible_for_j21: true comme dette ou preuve
legacy_runtime_alias: null
```

## T20 — Événement de découverte J14

```text
trace_id: j14_discovery_event_01
trace_type: FACT_RECORD
source_day: J14
source_scene: S27 photo au mauvais écran
creator: système narratif à partir d’une trace existante
subjects: [témoin, Player, contrôleur de la trace]
owner: état narratif
initial_audience: non applicable
current_audience: non applicable
storage_location: registre de connaissances
saving_rule: NONE
transfer_rule: FORBIDDEN
current_state: ACTIVE ou NOT_CREATED
replaces_or_derives_from: un seul trace_id réel
knowledge_created: fact_witness_saw_limited_trace
eligible_for_j14: false
eligible_for_j21: true comme conséquence, jamais comme image
legacy_runtime_alias: null
```

T20 ne contient jamais le fichier observé.

Il référence :

```text
discovered_trace_id
witness_id
visible_fields
player_reaction
player_explanation
```

## T21 — Obligation ou contradiction J15

```text
trace_id: j15_obligation_collision_record_01
trace_type: FACT_RECORD
source_day: J15
source_scene: S28 engagements incompatibles
creator: système narratif à partir de promesses actives
subjects: [Player, personnes en attente]
owner: état narratif
initial_audience: non applicable
current_audience: non applicable
storage_location: registre des promesses
saving_rule: NONE
transfer_rule: FORBIDDEN
current_state: ACTIVE ou NOT_CREATED
knowledge_created: fact_player_prioritized_or_failed_obligation
eligible_for_j14: false
eligible_for_j21: true comme dette, jamais comme image
legacy_runtime_alias: null
```

## T22 — Paiement J16

```text
trace_id: j16_consequence_payment_record_01
trace_type: FACT_RECORD
source_day: J16
source_scene: paiement de la dette prioritaire
creator: système narratif
subjects: personnes concernées
owner: état narratif
storage_location: registre des promesses / conséquences
current_state: ACTIVE
knowledge_created: fact_priority_consequence_paid_or_failed
eligible_for_j14: false
eligible_for_j21: true comme contexte
legacy_runtime_alias: null
```

---

# 8. Traces de résolution J17–J20

## T23 — État du couple J17

```text
trace_id: j17_couple_definition_record_01
trace_type: FACT_RECORD
source_day: J17
source_scene: définition provisoire du couple
creator: Marie et Player par choix et conséquence
subjects: [Marie, Player]
owner: état couple
storage_location: contrat d’état
current_state: ACTIVE
knowledge_created: fact_couple_state_defined
eligible_for_j14: false
eligible_for_j21: true
legacy_runtime_alias: null
```

## T24 — Impression du déjeuner Sandra

```text
trace_id: j18_sandra_lunch_print_01
trace_type: PHYSICAL_PRINT
source_day: J18
source_scene: Sandra choisit ce qu’elle garde
creator: Sandra
subjects: [Sandra]
owner: Sandra
initial_audience: [Sandra]
current_audience: [Sandra] sauf choix explicite différent
storage_location: livre ou archive physique Sandra
saving_rule: OWNER_ONLY
transfer_rule: OWNER_CONFIRMATION_REQUIRED
current_state: ACTIVE ou NOT_CREATED
replaces_or_derives_from: j01_sandra_lunch_memory_soft
knowledge_created: fact_sandra_kept_physical_lunch_trace
eligible_for_j14: false
eligible_for_j21: true par message de Sandra, pas accès direct Player
legacy_runtime_alias: null
```

## T25 — Trace réciproque Pauline

```text
trace_id: j19_pauline_reciprocal_message_01
trace_type: TEXT_MESSAGE
source_day: J19
source_scene: Pauline preuve réciproque
creator: Player
subjects: [Player, Pauline, Bastien ou Marie comme personnes exclues]
owner: Pauline
initial_audience: [Pauline, Player]
current_audience: [Pauline, Player]
storage_location: fil Player / Pauline ou sauvegarde Pauline
saving_rule: OWNER_ONLY
transfer_rule: FORBIDDEN sauf protection factuelle
current_state: ACTIVE, RESTRICTED ou NOT_CREATED
knowledge_created: fact_pauline_has_player_acknowledgement
eligible_for_j14: false
eligible_for_j21: true
legacy_runtime_alias: null
```

## T26 — Accès créatif Raphaëlle

```text
trace_id: j19_raphaelle_creative_access_01
trace_type: ACCESS_GRANT ou ACCESS_REVOCATION
source_day: J19
source_scene: après le rôle
creator: Raphaëlle
subjects: [Raphaëlle, Player, processus créatif]
owner: Raphaëlle
initial_audience: [Raphaëlle, Player]
current_audience: selon état Raphaëlle
storage_location: compte créatif / dossier fabrication
saving_rule: OWNER_ONLY
transfer_rule: FORBIDDEN
current_state: ACTIVE, RESTRICTED, REMOVED ou NOT_CREATED
knowledge_created: fact_player_creative_access_state
eligible_for_j14: false
eligible_for_j21: true
legacy_runtime_alias: null
```

## T27 — Fait d’heure Nico

```text
trace_id: j20_nico_exact_hour_record_01
trace_type: FACT_RECORD
source_day: J20
source_scene: heure ou alibi
creator: Nico par réponse factuelle
subjects: [Nico, Player, personne ayant demandé]
owner: état de connaissance
storage_location: registre de connaissances
current_state: ACTIVE ou NOT_CREATED
knowledge_created: fact_third_party_received_exact_hour
eligible_for_j14: false
eligible_for_j21: true comme dette ou fermeture d’alibi
legacy_runtime_alias: null
```

## T28 — Copie supprimée par Nico

```text
trace_id: j20_nico_unauthorized_copy_deleted_01
trace_type: ABSENCE_MARKER
source_day: J20
source_scene: copie ou image hors audience
creator: Nico par action de suppression
subjects: [personne représentée, Nico, Player]
owner: personne représentée pour le contenu ; Nico pour la connaissance
storage_location: absence de fichier + registre de connaissances
saving_rule: NONE
transfer_rule: FORBIDDEN
current_state: DELETED ou NOT_CREATED
knowledge_created: fact_nico_saw_then_deleted_unauthorized_trace
eligible_for_j14: false
eligible_for_j21: true comme absence, jamais comme image restaurée
legacy_runtime_alias: null
```

---

# 9. Sortie de sélection J21

J21 ne crée pas une nouvelle trace principale.

À la fin de J20, le système narratif doit produire :

```text
final_trace_id
final_trace_state
final_trace_controller
final_trace_audience
```

`final_trace_id` référence obligatoirement une entrée existante de ce registre.

## 9.1 Priorité

```text
1. trace liée à une dette de sécurité ou d’audience active
2. trace liée à une contradiction active
3. trace de la relation dominante
4. trace du couple
5. trace sociale publique
6. absence contrôlée d’une trace retirée
```

## 9.2 Tie-breaker

Si plusieurs traces ont la même priorité :

```text
trace ayant produit la conséquence la plus récente
→ trace dont le contrôleur a pris une décision active
→ trace la moins récemment foreground
→ ordre authored du registre
```

Aucun score relationnel n’est utilisé.

## 9.3 Traces finales sûres

Peuvent être sélectionnées si leur état le permet :

```text
j01_sandra_lunch_memory_soft
j04_pauline_bastien_public_set_01
j09_marie_black_dress_private_01
j09_marie_laverriere_public_01
j09_marie_laverriere_after_01
j10_mathilde_outfit_choice_01
j11_sandra_chosen_image_01
j11_raphaelle_chosen_result_01
j12_laverriere_public_group_set_01
j12_annexe_public_group_set_01
j13_pauline_private_version_01
j13_raphaelle_masked_version_01
j13_nico_alibi_or_hour_message_01
j18_sandra_lunch_print_01
j19_pauline_reciprocal_message_01
j19_raphaelle_creative_access_01
j20_nico_exact_hour_record_01
j20_nico_unauthorized_copy_deleted_01
```

## 9.4 Inéligibles comme image finale

```text
IMAGE_DE_SCÈNE
j14_discovery_event_01
j15_obligation_collision_record_01
j16_consequence_payment_record_01
j17_couple_definition_record_01
```

Ces faits peuvent influencer le sens de la finale mais ne sont pas des photographies.

---

# 10. Invariants

1. Une trace `REMOVED`, `DELETED` ou `INACCESSIBLE` ne redevient jamais `ACTIVE` sans action explicite de son contrôleur.
2. Une audience ne s’élargit jamais par déduction.
3. Une trace publique reste soumise à son cadre public ; elle n’autorise pas un recadrage privé.
4. Une trace privée ne peut pas être envoyée à Nico « pour expliquer » sans changement d’audience et conséquence.
5. Le contrôleur de la trace décide de son retrait.
6. La suppression du fichier ne supprime pas les connaissances créées.
7. Une impression physique possède son propre propriétaire et sa propre audience.
8. Un `FACT_RECORD` n’est jamais montré comme capture ou photo.
9. J14 ne peut découvrir qu’un `trace_id` déjà créé.
10. J21 ne peut sélectionner qu’un `trace_id` encore cohérent avec son audience finale.

---

# 11. Legacy et consolidation

Les identifiants runtime historiques suivants peuvent être conservés :

```text
j1_sandra_lunch_memory_soft
mathilde_arrival_room_01
marie_laverriere_setup_01
```

Le legacy `laverriere_public_group_photo_set_01` se mappe vers `j12_laverriere_public_group_set_01`, créé par Élodie pour l’audience La Verrière nommée.

Le lot C devra :

- remplacer les formulations génériques par les `trace_id` ci-dessus ;
- fixer les créateurs encore non résolus ;
- supprimer les traces diégétiques non produites ;
- garantir que les scripts J14 et J21 ne citent aucun contenu absent du registre.

---

# 12. Verdict

```text
TRACES DE BRANCHE : BORNÉES
TRACES J14 : SOURÇABLES
TRACES J21 : SÉLECTIONNABLES DE MANIÈRE DÉTERMINISTE
IMAGES DE SCÈNE : EXCLUES DES PREUVES
CRÉATEURS RESTANT À RÉSOUDRE : MARQUÉS EXPLICITEMENT
```

> **Une trace n’existe pas parce qu’un script en a besoin plus tard. Elle existe parce qu’une personne l’a créée, contrôlée et laissée dans un état précis.**
