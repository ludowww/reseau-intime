# Act I First Repetition Windows Scene Cards — V0.87

> Structured scene contracts for the first post-opening repetition wave.  
> Companion to `ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md`.  
> Documentation only; conceptual labels are not final runtime variable names.

## 1. Reading rule

Exact line sources and branch meaning:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
```

Temporal placement and realistic message delivery:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
```

Architecture and choice contracts:

```text
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/CHOICE_DESIGN_CANON.md
```

Every implementation must also read the relevant full character canon and deprecation map.

---

## 2. Wave map

| Window | Class | Foreground | Echo capacity | Fixed / variable |
|---|---|---|---:|---|
| `first_repeat_w9_shared_hour` | spine / couple agency | `marie_saturday_shared_hour_01` | 0–1 | fixed |
| `first_repeat_w10_weekend_pool` | opportunity | one eligible external scene | 0–2 | variable |
| `first_repeat_w11_couple_return` | consequence / couple anchor | `marie_concrete_return_due_01` or paid-state echo | 0 | fixed when due |
| `first_repeat_w12_workday_pool` | opportunity | one eligible external scene | 0–2 | variable |
| `first_repeat_w13_wave_close` | consequence / couple anchor | `marie_concrete_return_due_01` or warm close | 0–1 | fixed |

External scene pool:

```text
mathilde_morning_kitchen_afterglow_01
sandra_ticket_ghost_hot_chocolate_01
raphaelle_lunch_walk_outside_work_01
pauline_bastien_sunday_table_01
nico_pre_shift_lunch_friendship_01
```

Global caps:

```text
external foreground tickets = 2 maximum
same character foreground twice = forbidden
charged_access_owner = none or one of Mathilde / Sandra / Raphaëlle
Pauline and Nico ceiling = R1
```

---

## 3. Global selection contract

```yaml
hard_prerequisites:
  - opening_band_complete
  - no unresolved safety or aftermath state
  - no overdue couple consequence before external opportunity
hard_exclusions:
  - adult frame active
  - hard secret already requiring immediate consequence
  - route stage above source-pack ceiling
  - exact scene engine inside cooldown
selection_priority:
  - safety / aftermath
  - fixed spine
  - obligation due
  - compatible continuation
  - physical and temporal context fit
  - unseen eligible scene
  - longest deferred scene
  - least recently foregrounded pool
  - authored deterministic order
budget:
  foreground_per_window: 1
  echoes_per_window: 0-2
  external_foregrounds_per_wave: 0-2
  charged_routes_per_wave: 0-1
```

A quiet fallback is valid.

No engine should manufacture a weak pretext simply to consume a ticket.

---

# 4. Card — Marie claims one shared hour

```yaml
scene_id: marie_saturday_shared_hour_01
working_title: One hour before being useful again
scene_class: spine scene
primary_function: positive couple agency + concrete presence test
primary_relationship: Player / Marie
principal_character: Marie
```

## Canon dependencies

```yaml
required_canon_files:
  - MARIE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - CHOICE_DESIGN_CANON.md
  - MODULAR_NARRATIVE_ARC_BLUEPRINT.md
adult_canon_required: no
relevant_previous_sources:
  - J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
  - ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
```

## Scope

```yaml
act_range: Act I S4 entry
route_stage_range: couple baseline only
intensity_tier: ordinary / warm
window_types:
  - PRIVATE_MESSAGE
  - OFFLINE_SHARED_TIME
foreground_cost: 1 fixed spine
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - opening_band_complete
  - couple mode HABITUAL_WARMTH
  - relationship frame ASSUMED_EXCLUSIVE
  - Marie and Player physically separated when messages begin
hard_exclusions:
  - explicit couple crisis already active
  - urgent safety or aftermath state
  - Marie already waiting on another unpaid concrete promise from the same morning
soft_preferences:
  - Saturday or equivalent first free morning after Friday
  - Marie has a real errand and one free hour
availability_reason:
  - Marie has already moved into her own morning and invites Player into it
```

## Context reads

- J1 Marie presence posture;
- Wednesday household-participation quality;
- Thursday topology and promise result;
- Friday public/social posture;
- current household occupancy;
- no external route stage above R1.

## Stable engine

```text
Marie already has a real morning
-> offers one bounded shared hour
-> Player joins, creates a concrete alternative, or stays outside it
-> Marie moves either way
-> the result creates evidence, not an instant couple-mode change
```

## Entry contract

```yaml
calendar_anchor: Saturday or first equivalent free morning
time_band: MORNING
communication_mode: REMOTE_ASYNC
physical_context:
  Marie: market / bakery / returning La Verrière keys / practical errand
  Player: home or leaving home
  Mathilde: occupied elsewhere in the apartment or outside
why_message_is_used:
  - Marie is already outside
  - Player must decide before the bounded hour passes
when_messaging_stops:
  - if Player joins Marie
possible_offline_continuation:
  - coffee
  - market walk
  - carrying one bag
  - ordinary conversation without phone transcript
```

## Choice contract

```yaml
choice_node: M2
primary_decision_axis: how Player makes or fails to make shared time
choice_count: 3
choices:
  A:
    posture: join now
    writes:
      - marie_shared_hour_joined
      - active_reconnection_evidence
      - marie_feels_actively_chosen
  B:
    posture: bounded alternative
    writes:
      - marie_shared_hour_rescheduled
      - shared_time_obligation_due
      - reconnection_only_if_paid
  C:
    posture: leave Marie to act independently
    writes:
      - marie_moves_without_player
      - concrete_return_due
      - parallel_drift_evidence_soft
```

All three choices preserve Marie's ability to enjoy the hour.

## Character agency

Marie:

- is already doing something before Player answers;
- invites rather than begs;
- accepts a real alternative;
- does not treat a weak reply as a full relationship diagnosis;
- completes the morning without Player if needed.

Player:

- chooses an observable action;
- cannot convert a vague `later` into repair;
- may be imperfect without being empty.

## State writes

- weekend presence posture;
- concrete promise or no promise;
- Marie independent-action trace;
- couple return requirement;
- no affection score;
- no external route state.

## Exit contract

```yaml
exit_state:
  - Marie acted for herself
  - first external repetition ticket may become eligible
  - return consequence exists after external foreground
follow_up_candidates:
  - weekend repetition pool
  - marie_concrete_return_due_01
consequence_due: after next external foreground or by end of weekend
cooldown: exact scene never repeats
expiry_or_mutation:
  M2B: paid or missed before weekend close
  M2C: Marie no longer waits in the same hour
fallback_if_not_seen: mandatory function-equivalent couple scene
```

## Anti-pattern check

Reject if Marie:

- is only jealous;
- waits at home for Player to select her;
- offers a route menu;
- diagnoses the whole couple;
- becomes a moral obstacle to later desire.

---

# 5. Card — Mathilde morning kitchen afterglow

```yaml
scene_id: mathilde_morning_kitchen_afterglow_01
working_title: Not discreet before coffee
scene_class: opportunity / attention
primary_function: make the gaze readable without making clothing consent
primary_relationship: Player / Mathilde
secondary_relationship: Player / Marie
principal_character: Mathilde
```

## Canon dependencies

```yaml
required_canon_files:
  - MATHILDE_CANON_FULL.md
  - MARIE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - NSFW_CHARACTER_ROUTE_CANON.md
relevant_deprecation_maps:
  - MATHILDE_CANON_DEPRECATION_MAP.md
adult_canon_required: yes for guardrails, not for explicit content
```

## Scope

```yaml
act_range: Act I S4
route_stage_range: Mathilde R1 -> optional R2 Charged Access
intensity_tier: soft charge
window_types:
  - HOME_WITHOUT_MARIE
  - AFTERGLOW_REMOTE
foreground_cost: 1 external ticket
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - Mathilde stay active
  - ordinary kitchen moment occurred
  - Marie absent from the room for a real reason
  - Player and Mathilde separated before the chat begins
  - no Mathilde boundary breach unresolved
  - no Marie consequence overdue
  - charged_access_owner empty or Mathilde
hard_exclusions:
  - deliberate Mathilde seduction already established
  - secret photo or description to Nico
  - Marie physically present and available to speak
  - explicit aftermath due
  - exact engine inside two-window cooldown
soft_preferences:
  - positive household help or ordinary trust
  - playful arrival posture
  - O5B not immediately previous foreground
availability_reason:
  - Mathilde noticed Player's gaze during an ordinary unperformed morning
```

## Context reads

- M0 household participation;
- MT0 Mathilde welcome posture;
- O5B selected or missed;
- Friday household rhythm;
- current Marie location;
- charged-access owner;
- any prior Mathilde limit.

## Stable engine

```text
ordinary fitted homewear + unprepared morning
-> Player looks slightly too long
-> Mathilde notices
-> physical moment ends
-> Mathilde reopens it by message
-> Player owns, jokes, or limits the gaze
-> intention remains unconfirmed
```

## Entry contract

```yaml
calendar_anchor: weekend morning or first compatible weekday morning
time_band: MORNING
communication_mode: AFTERGLOW_REMOTE
physical_context:
  before_chat: Player and Mathilde briefly shared the kitchen
  during_chat: Mathilde has left for work / insurer / laundry / contractor call
why_message_is_used:
  - the physical moment is over
  - embarrassment becomes easier at distance
when_messaging_stops:
  - Mathilde closes the subject after the branch
```

## Choice contract

```yaml
choice_node: MT1
primary_decision_axis: how Player owns the gaze
choice_count: 3
choices:
  A:
    posture: respectful acknowledgement
    writes:
      - mathilde_gaze_acknowledged_soft
      - player_owns_gaze_without_claim
      - mathilde_r2_candidate_if_prior_trust
  B:
    posture: playful but readable
    writes:
      - mathilde_gaze_playful_soft
      - ordinary_complicity_charged
      - mathilde_r2_candidate_if_playful_trust
  C:
    posture: restore distance
    writes:
      - mathilde_distance_respected
      - mathilde_route_remains_r1
```

## R2 gate

Mathilde reaches R2 only if all are true:

```text
positive household trust or playful complicity
+ no prior overstep
+ choice MT1A or MT1B
+ no other charged_access_owner
+ Marie consequence not overdue
```

R2 does not write:

- deliberate intent;
- image permission;
- sexual consent;
- secret relationship;
- adult frame.

## Character agency

Mathilde:

- notices and names the gaze herself;
- states that the outfit is normal for her;
- may admit the gaze did not make her uncomfortable;
- may choose distance;
- does not reward insistence;
- keeps Marie as real moral context without reciting her name every line.

Player:

- cannot call clothing an invitation;
- can own the gaze;
- can joke without erasing meaning;
- can restore distance.

Marie:

- remains the trusted host and family bridge;
- does not become an offscreen fool whose absence creates permission.

## Trace / knowledge / consent

```yaml
new_trace: none
knowledge:
  Player: knows Mathilde noticed
  Mathilde: knows Player looked
  Marie: does not know by default
consent:
  clothing: ordinary, no sexual permission
  gaze_acknowledgement: local conversation only
  image_permission: none
```

## Exit contract

```yaml
exit_state:
  - gaze meaning stored
  - deliberate intent false
  - Marie trust active
follow_up_candidates:
  - later outfit-opinion candidate only after another cycle
  - Mathilde work anecdote
  - Marie household consequence
consequence_due: Marie return before another charged external scene
cooldown: two compatible foreground windows
expiry_or_mutation:
  ignored: Mathilde stops asking about this exact moment
  distant: later scene needs a fresh trigger
  overstep: route cools or closes
fallback_if_not_seen: ordinary Mathilde household/work echo
```

## Anti-pattern check

Reject if scene uses:

- oversized grey sweater as signature;
- photo canapé;
- clothing accident;
- legal jokes as entire voice;
- automatic seduction;
- Marie forgotten;
- Nico photo circulation.

---

# 6. Card — Sandra ticket ghost and hot chocolate

```yaml
scene_id: sandra_ticket_ghost_hot_chocolate_01
working_title: The ticket reopened itself
scene_class: continuation / attention
primary_function: repeat a chosen private rhythm without another photo
primary_relationship: Player / Sandra
principal_character: Sandra
```

## Canon dependencies

```yaml
required_canon_files:
  - SANDRA_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - NSFW_CHARACTER_ROUTE_CANON.md
supporting_character_source:
  - SANDRA_CANON_FULL.md for Jeff
adult_canon_required: yes for route/consent guardrails
```

## Scope

```yaml
act_range: Act I S4
route_stage_range: Sandra R1 -> optional R2 Charged Access
intensity_tier: soft charge
window_types:
  - PRIVATE_MESSAGE
  - AFTERGLOW_REMOTE
foreground_cost: 1 external ticket
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - J1 Sandra trace active or warmly unresolved
  - no Sandra route closure
  - prior soft boundary respected
  - credible end-of-post or quiet late interval
  - at least one compatible window since prior Sandra foreground
  - no Marie consequence overdue
  - charged_access_owner empty or Sandra
hard_exclusions:
  - new Sandra image
  - direct Jeff villain exposition
  - Player pressing after a closed subject
  - Sandra asleep / unavailable
  - exact engine inside cooldown
soft_preferences:
  - J1 precise observation or safe warmth
  - Thursday Sandra scene completed
availability_reason:
  - Sandra chooses Player as the person still awake after an absurd work recurrence
```

## Missed-Thursday mutation

If `thursday_sandra_echo_missed` is true:

```yaml
preferred_action: defer exact scene
mutation:
  - later colder work-afterglow
  - no automatic penalty
  - no immediate route advance
exception:
  - J1 safe warmth remains strong
  - at least two days elapsed
  - no recent Sandra offer
```

## Context reads

- J1 Sandra posture;
- Thursday seen/expired;
- last boundary result;
- Sandra work rhythm;
- current time;
- Marie consequence state;
- charged-access owner.

## Stable engine

```text
concrete SentryCore absurdity
-> Sandra chooses Player for the afterglow
-> ordinary refuge object appears
-> Player reads, cares, or closes
-> Sandra confirms or protects the choice
```

## Choice contract

```yaml
choice_node: S2
primary_decision_axis: how Player responds to being the chosen late contact
choice_count: 3
choices:
  A:
    posture: precise, not magical
    writes:
      - sandra_chosen_contact_read_precisely
      - sandra_r2_candidate_if_prior_precision
  B:
    posture: ordinary care
    writes:
      - sandra_ordinary_warmth_repeated
      - route_stays_r1
  C:
    posture: respect the hour and close
    writes:
      - sandra_boundary_respected_again
      - route_stays_r1
```

## R2 gate

```text
prior precise or safe warmth
+ prior boundary respected
+ S2A
+ no other charged owner
+ no pressure language
```

R2 means Sandra selected Player and admitted it mattered.

It does not mean:

- confession;
- affair;
- image permission;
- sexual invitation;
- Jeff erased.

## Character agency

Sandra:

- initiates the late contact;
- uses a concrete work detail;
- may admit she wanted someone still awake;
- keeps the right to minimize and close;
- is not forced to send an image.

Player:

- may read correctly, partly correctly, or choose not to read through;
- must not become a magic therapist;
- can respect a closing without route loss.

Jeff:

- remains a real partner offscreen;
- is not made cruel to justify the conversation;
- is not required to be named in every line.

## Trace / knowledge / consent

```yaml
new_trace: none
existing_trace_read:
  - j1_sandra_lunch_memory_soft as history only
knowledge:
  Sandra: knows why she selected Player
  Player: may understand partially
  Jeff: no new knowledge
consent:
  private conversation only
  no image or physical permission
```

## Exit contract

```yaml
exit_state:
  - chosen-contact meaning stored or ordinary warmth repeated
  - soft boundary intact
follow_up_candidates:
  - later printed-object or family-home scene after cooldown
  - Marie return consequence
consequence_due: Marie return before another charged external scene
cooldown: two compatible private-message windows
expiry_or_mutation:
  ignored: exact late interval expires
  declined warmly: no penalty
  pressed: route cools or closes
fallback_if_not_seen: colder work echo or silence
```

## Anti-pattern check

Reject:

- new photo reward;
- romance-novel exposition;
- Jeff monster;
- multiple `haha` beats;
- Player reading her perfectly by default;
- pressure becoming access.

---

# 7. Card — Raphaëlle lunch walk outside work

```yaml
scene_id: raphaelle_lunch_walk_outside_work_01
working_title: Ten minutes outside the file
scene_class: access / attention
primary_function: reveal one ordinary outside-work layer
primary_relationship: Player / Raphaëlle
principal_character: Raphaëlle
```

## Canon dependencies

```yaml
required_canon_files:
  - RAPHAELLE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - NSFW_CHARACTER_ROUTE_CANON.md
relevant_deprecation_maps:
  - RAPHAELLE_CANON_DEPRECATION_MAP.md
adult_canon_required: yes for workplace and frame guardrails
```

## Scope

```yaml
act_range: Act I S4
route_stage_range: Raphaëlle R1 -> optional R2 Charged Access
intensity_tier: ordinary to soft charge
window_types:
  - PLAYER_WORK
  - OFFLINE_WALK
  - AFTERGLOW_REMOTE
foreground_cost: 1 external ticket
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - Raphaëlle work access established
  - peer relation intact
  - real work task just resolved
  - separate workstations justify written opening
  - lunch / walk interval available
  - no Marie consequence overdue
  - charged_access_owner empty or Raphaëlle
hard_exclusions:
  - work hierarchy or evaluation pressure
  - Player using Raphaëlle to avoid immediate Marie obligation
  - private creative account reveal
  - costume / fitting / garment-bag invitation
  - adult image
  - deadline panic carrying emotional access
soft_preferences:
  - Player respected prior correction
  - O5C history or fresh work continuity
availability_reason:
  - Raphaëlle chooses to extend ordinary contact beyond the resolved file
```

## Context reads

- Raphaëlle work trust;
- O5C selected or missed;
- promise/lateness history;
- current workload;
- Player couple-return obligation;
- charged-access owner.

## Stable engine

```text
work task closes
-> Raphaëlle chooses a short walk
-> Player joins, defers honestly, or hides in work
-> one ordinary personal detail becomes selected access
-> work resumes with the distinction intact
```

## Choice contract

```yaml
choice_node: R1
primary_decision_axis: whether Player enters selected outside-work time
choice_count: 3
choices:
  A:
    posture: join
    writes:
      - raphaelle_outside_work_access
      - raphaelle_r2_candidate_if_not_refuge
  B:
    posture: honest defer
    writes:
      - raphaelle_walk_deferred_once
      - route_stays_r1_until_paid
  C:
    posture: stay inside work
    writes:
      - raphaelle_professional_frame_maintained
      - route_stays_r1
```

## R2 gate

```text
R1A join
+ Player not escaping a due Marie act
+ work task genuinely complete
+ Raphaëlle offers one personal detail herself
+ no other charged owner
```

R2 is `outside-work person`, not attraction named.

No creative account, photo, costume, or explicit role is unlocked.

## Character agency

Raphaëlle:

- chooses the walk;
- does not diagnose Player;
- may share one useless but real personal detail;
- accepts a no;
- does not wait indefinitely on a deferred invitation;
- restores work boundaries after the walk.

Player:

- can join without confession;
- can defer honestly;
- can remain professional;
- cannot ask Raphaëlle to solve Marie.

## Trace / knowledge / consent

```yaml
new_trace: none
knowledge:
  Raphaelle: knows whether Player enters a non-work interval
  Player: learns one ordinary outside-work detail if joined
  Marie: no automatic knowledge of the walk
consent:
  walk only
  no image, touch, costume, or adult frame
```

## Exit contract

```yaml
exit_state:
  - professional trust preserved
  - possible outside-work access
follow_up_candidates:
  - later ordinary creative-process mention
  - no private account until a later pack
  - Marie consequence
consequence_due: Marie return if route reaches R2
cooldown: one full work cycle
expiry_or_mutation:
  one defer: may return once
  second defer or miss: fresh reason required
  refusal: professional scene pool remains available
fallback_if_not_seen: one-line work closure
```

## Anti-pattern check

Reject:

- therapist Raphaëlle;
- panda as automatic vulnerability button;
- glasses-off transformation;
- costume reveal;
- workplace seduction shortcut;
- clear language treated as global permission.

---

# 8. Card — Pauline and Bastien's Sunday table

```yaml
scene_id: pauline_bastien_sunday_table_01
working_title: The leftovers need a second career
scene_class: ordinary access repetition
primary_function: prove a second legitimate social cycle before private selectivity
primary_relationship: Player / Pauline
secondary_relationships:
  - Player / Marie
  - Pauline / Bastien
principal_character: Pauline
```

## Canon dependencies

```yaml
required_canon_files:
  - PAULINE_CANON_FULL.md
  - MARIE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - NSFW_CHARACTER_ROUTE_CANON.md
relevant_deprecation_maps:
  - PAULINE_CANON_DEPRECATION_MAP.md
supporting_character_source:
  - PAULINE_CANON_FULL.md for Bastien
adult_canon_required: yes for double-life guardrails, not for explicit content
```

## Scope

```yaml
act_range: Act I S4
route_stage_range: Pauline R1 only
intensity_tier: ordinary
window_types:
  - PRIVATE_MESSAGE with legitimate social reason
  - GROUP_EVENT
foreground_cost: 1 external ticket
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - Pauline R1 social/public access
  - Marie / Pauline friendship active
  - Bastien visible in setup
  - one full cycle since Friday photo relay
  - private compartment inactive
  - no Marie consequence overdue
hard_exclusions:
  - private alternate crop
  - one-view image
  - body-focused selection
  - old affair disclosure to Player
  - unnecessary alibi
  - choir as erotic shorthand
  - Bastien erased for convenience
availability_reason:
  - Pauline and Bastien host a real ordinary dinner or leftover plan
```

## Context reads

- Pauline public-photo choice;
- Thursday topology;
- Marie social independence;
- Player presence pattern;
- Bastien relationship reality;
- no private Pauline route.

## Stable engine

```text
Pauline and Bastien create a real social plan
-> Pauline contacts Player for a legitimate reason
-> Player joins with Marie, helps inside the public frame, or declines without controlling Marie
-> Pauline observes the quality of his participation
-> private selection remains locked
```

## Choice contract

```yaml
choice_node: P1
primary_decision_axis: how Player enters or leaves a real shared social plan
choice_count: 3
choices:
  A:
    posture: join with Marie
    writes:
      - pauline_legitimate_social_repetition
      - bastien_visible_again
      - player_joins_marie_socially
  B:
    posture: help inside the legitimate frame
    writes:
      - pauline_practical_access_repeated
      - bastien_present_during_setup
      - no_private_selection
  C:
    posture: decline without speaking for Marie
    writes:
      - marie_social_independence_respected
      - pauline_reads_player_nondecision_if_repeated
      - route_stays_r1
```

## Character agency

Pauline:

- has a real home and partner;
- coordinates without omniscience;
- may notice Player's public/private rhythm;
- does not create a secret layer in this pack.

Bastien:

- cooks, changes a recipe, gives a task, or hosts;
- is present as a human partner;
- is not stupid because he trusts Pauline;
- is not a silent obstacle.

Marie:

- decides whether she attends;
- is not represented by Player as owner;
- remains Pauline's real friend.

Player:

- may join, help, or decline;
- cannot turn legitimate private logistics into route permission.

## Trace / knowledge / consent

```yaml
new_trace: none required
existing_trace_read:
  - laverriere_public_group_photo_set_01 remains public/social only
knowledge:
  Pauline: may observe Player's participation pattern
  Bastien: knows the dinner and setup
  Marie: knows the social plan
consent:
  ordinary social contact only
  no private image or adult frame
```

## Exit contract

```yaml
exit_state:
  - Pauline second legitimate cycle complete or deferred
  - Bastien visible
  - private selectivity still locked
follow_up_candidates:
  - later public/social repetition
  - future recognition scene in another source pack
consequence_due: normal Marie social result, not secret consequence
cooldown: one social cycle
expiry_or_mutation:
  Player absent: dinner happens without him
  Marie attends alone: Pauline observes but does not immediately test Player
  scene missed: fresh social event required
fallback_if_not_seen: public scheduling echo
```

## Anti-pattern check

Reject:

- Pauline presented as single;
- indestructible Marie friendship;
- private crop;
- constant halo jokes;
- Bastien absent by convenience;
- secret compartment opening immediately after Friday.

---

# 9. Card — Nico pre-shift lunch

```yaml
scene_id: nico_pre_shift_lunch_friendship_01
working_title: Omelette with a witness
scene_class: ordinary access repetition
primary_function: prove quiet friendship before shared gaze
primary_relationship: Player / Nico
principal_character: Nico
```

## Canon dependencies

```yaml
required_canon_files:
  - NICO_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - NSFW_CHARACTER_ROUTE_CANON.md
relevant_deprecation_maps:
  - NICO_CANON_DEPRECATION_MAP.md
adult_canon_required: yes for image / gaze exclusions, not for explicit content
```

## Scope

```yaml
act_range: Act I S4
route_stage_range: Nico R1 only
intensity_tier: ordinary
window_types:
  - PRIVATE_MESSAGE
  - OFFLINE_FRIENDSHIP
foreground_cost: 1 external ticket
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - Nico R1 friendship access
  - one full cycle since Friday follow-up
  - credible pre-shift lunch or quiet afternoon
  - no Nico route closure
  - no Marie consequence overdue
hard_exclusions:
  - domestic photo request
  - body commentary as foreground
  - alibi proposal
  - shared-gaze offer
  - rivalry as sole function
  - intoxication
availability_reason:
  - Nico invites Player into ordinary time where Nico is not performing for a room
```

## Context reads

- N0 friendship posture;
- Thursday presence history;
- Nico work schedule;
- any deferred lunch promise;
- current couple obligation;
- no shared-gaze state.

## Stable engine

```text
Nico has one quiet hour
-> invites Player to eat
-> Player shows up, makes a real later plan, or withdraws
-> Nico exists without social performance
-> friendship gains substance before desire can corrupt it
```

## Choice contract

```yaml
choice_node: N1
primary_decision_axis: whether Player invests in the ordinary friendship
choice_count: 3
choices:
  A:
    posture: show up
    writes:
      - nico_friendship_repeated
      - nico_quiet_access_seen
      - shared_gaze_locked
  B:
    posture: concrete defer
    writes:
      - nico_lunch_deferred_once
      - friendship_obligation_due
  C:
    posture: withdraw plainly
    writes:
      - nico_friendship_invite_declined
      - no_immediate_rivalry
```

## Character agency

Nico:

- has food, work, fatigue, and quiet life;
- can accept a no;
- does not weaponize Marie or Mathilde immediately;
- does not ask for proof or images;
- may reveal one short vulnerability through ordinary silence.

Player:

- can invest in the friendship;
- can delay with a date;
- can withdraw;
- cannot call future shared gaze harmless because the friendship is real.

## Trace / knowledge / consent

```yaml
new_trace: none
knowledge:
  Nico: knows whether Player shows up outside group logistics
  Player: sees quiet Nico if N1A
consent:
  ordinary friendship only
  no image, alibi, gaze-sharing, or adult frame
```

## Exit contract

```yaml
exit_state:
  - friendship repeated or deferred
  - quiet Nico established if seen
  - shared-gaze engine still locked
follow_up_candidates:
  - later social observation scene
  - future gaze proposal only in a later source pack
consequence_due:
  N1B: lunch promise once
cooldown: one social cycle
expiry_or_mutation:
  missed promise: trust cools, not automatic rivalry
  declined: new reason required
fallback_if_not_seen: ordinary L'Annexe logistics echo
```

## Anti-pattern check

Reject:

- fake friendship;
- pure jealousy button;
- photo-pact teaser;
- explicit Mathilde clothing question;
- alibi joke with route effect;
- omniscient social reading;
- permanent crude commentary.

---

# 10. Card — Marie concrete return

```yaml
scene_id: marie_concrete_return_due_01
working_title: The later is yours
scene_class: consequence / couple anchor
primary_function: pay or fail a real couple act after external attention
primary_relationship: Player / Marie
principal_character: Marie
```

## Canon dependencies

```yaml
required_canon_files:
  - MARIE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - CHOICE_DESIGN_CANON.md
adult_canon_required: no
```

## Scope

```yaml
act_range: Act I S4
route_stage_range: couple evidence only
intensity_tier: ordinary / warm / lightly hurt
window_types:
  - AFTERGLOW_REMOTE
  - COUPLE_HOME
  - OFFLINE_SHARED_TIME
foreground_cost: fixed consequence; does not consume external ticket
 echo_compatible: false
```

## Eligibility

```yaml
hard_requirements:
  - an external foreground just resolved or Marie shared-time obligation due
hard_exclusions:
  - Player and Marie co-present while a long chat is staged
  - urgent safety or aftermath state requiring another consequence first
availability_reason:
  - external attention changed time, presence, or opportunity cost
```

## Context reads

- M2 result;
- whether M2B promise was paid;
- external foreground character;
- whether one route reached R2;
- current physical positions;
- elapsed time;
- prior Marie return history.

## Stable engine

```text
external attention or missed shared time
-> Marie has continued living
-> Player receives a concrete return opportunity
-> he acts now, binds a later act, or refuses false promise
-> evidence accumulates without instant couple diagnosis
```

## Variant selection

### Paid warm variant

Use when:

- M2A occurred; or
- M2B was paid; or
- the external scene did not displace a due couple act.

No new choice is necessary.

Writes:

- `marie_return_paid`;
- active-reconnection evidence;
- next opportunity may proceed.

### Unpaid / charged-attention variant

Use when:

- M2B was missed;
- M2C occurred and no later act exists;
- external R2 attention displaced shared time;
- Player accumulated another delay.

## Choice contract

```yaml
choice_node: M3
primary_decision_axis: what concrete return Player makes
choice_count: 3
choices:
  A:
    posture: immediate act
    writes:
      - immediate_couple_return_due
      - marie_return_paid_if_completed
      - active_reconnection_evidence
  B:
    posture: bounded next act
    writes:
      - bounded_couple_obligation_due
      - no_repair_until_paid
  C:
    posture: honest non-repair
    writes:
      - honest_drift_evidence
      - no_false_repair
```

## Character agency

Marie:

- has already continued her day;
- names a checkable act rather than asking for a speech;
- accepts honesty without calling it repair;
- does not forgive a pattern because of one good sentence;
- remains desirable and active.

Player:

- owns action or non-action;
- cannot use private attention as excuse;
- is not forced to confess a non-boundary-crossing thought;
- must still pay opportunity cost in shared life.

## Trace / knowledge / consent

```yaml
new_trace: none
knowledge:
  Marie: reads Player's presence quality, not private thread contents
  Player: knows whether he paid the shared act
hard_secret_created: no
```

## Exit contract

```yaml
exit_state:
  - couple return paid, due, or honestly failed
  - no external opportunity may bypass an overdue return
follow_up_candidates:
  - next repetition ticket if return resolved
  - later couple consequence if missed
consequence_due:
  M3A: immediate action
  M3B: next bounded window
cooldown: function reusable, exact dialogue must mutate
expiry_or_mutation:
  missed bounded act: stronger drift evidence and priority consequence
  paid act: warm close
fallback_if_not_seen: mandatory function-equivalent consequence
```

## Anti-pattern check

Reject:

- grand couple speech;
- forced confession of every attraction;
- Marie becoming only punishment;
- reassurance counted as action;
- same exact bread/walk loop copied from J1;
- fake messages while co-present.

---

## 11. Global trace and knowledge review

```yaml
new_required_images: none
new_adult_images: none
new_hard_secrets: none
existing_trace_mutations: none
private_attention_states:
  - Mathilde may know Player looked
  - Sandra may know Player understood why she wrote
  - Raphaëlle may know Player chose a walk
ordinary_social_states:
  - Pauline / Bastien dinner
  - Nico quiet lunch
Marie_default_knowledge:
  - Player's observable presence and absence
  - not private thread contents
```

Forbidden inference:

```text
private message != secret affair
charged access != consent
public photo != private forwarding permission
ordinary sensuality != image permission
clear local invitation != global relationship permission
```

---

## 12. Cooldown and lifecycle review

Each external scene begins:

```text
DORMANT -> ELIGIBLE -> OFFERED
```

Possible results:

```text
SEEN
DEFERRED
MISSED
MUTATED
EXPIRED
CONSEQUENCE_DUE
RESOLVED
```

Implementation plan must map every scene to this lifecycle before runtime integration.

No scene remains permanently `OFFERED`.

No refusal is bypassed by a renamed duplicate.

---

## 13. Route ceiling review

| Character | Start | Maximum after V0.87 source content | Required restraint |
|---|---|---|---|
| Marie | `HABITUAL_WARMTH` | same mode + reconnection/drift evidence | no instant mode change |
| Sandra | R1 | R2 at most | no image/confession |
| Mathilde | R1 | R2 at most | intent still unconfirmed |
| Raphaëlle | R1 | R2 at most | no account/costume/image |
| Pauline | R1 | R1 | second legitimate cycle only |
| Nico | R1 | R1 | second friendship cycle only |

Global maximum:

```text
one external R2 owner
```

---

## 14. Final authoring check

Before approving an implementation plan, confirm:

- Marie has a fixed positive scene for herself;
- only two external foreground tickets exist;
- one route reaches R2 at most;
- Pauline and Nico remain R1;
- Mathilde clothing is not consent;
- Sandra sends no new photo;
- Raphaëlle reveals no private creative account;
- every external foreground returns to Marie/shared life;
- every scene has a cooldown and mutation;
- no fake co-present chat exists;
- current smartphone time/notification behavior is preserved;
- no runtime file is changed in V0.87.

```text
A valid scene changes meaning through repetition.
It does not skip the repetition because a later engine is exciting.
```
