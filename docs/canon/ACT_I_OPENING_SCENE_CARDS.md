# Act I Opening Scene Cards — V0.79

> Structured authoring cards for the first post-J1 modular narrative slice.  
> Companion to `ACT_I_OPENING_WINDOWS_SOURCE_PACK.md`.  
> These cards satisfy the V0.78 Modular Scene Authoring Contract and remain runtime-neutral.

## 1. Reading rule

For exact dialogue and line variants, read:

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
```

For architecture and authoring requirements, read:

```text
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
```

Conceptual labels below are not final runtime variable names.

---

## 2. Opening window map

| Window ID | Class | Foreground | Echo capacity | Fixed / variable |
|---|---|---|---:|---|
| `opening_o1_make_room` | spine / household setup | `marie_mathilde_emergency_make_room_01` | 1 | fixed |
| `opening_o2_arrival` | spine / household access | `mathilde_arrival_too_much_luggage_01` | 1 | fixed |
| `opening_o3_work` | ordinary access | `raphaelle_blue_folder_review_01` | 1 | fixed |
| `opening_o4_movement_offer` | spine / topology choice | `marie_thursday_movement_offer_01` | 0 | fixed |
| `opening_o5_topology` | topology result | one of O5A / O5B / O5C | 1–2 | variable |
| `opening_o6_return` | consequence / couple return | `marie_after_first_event_return_01` | 0 | fixed |
| `opening_o7_public_trace` | trace / ordinary access | `pauline_public_group_photo_relay_01` | 1 | fixed; may swap with O8 |
| `opening_o8_nico_followup` | ordinary access / social mirror seed | `nico_saved_seat_followup_01` | 1–2 | fixed or shortened variant |

Conditional echo:

```text
sandra_poste_matin_continuity_01
```

Closing breather echoes:

```text
marie_household_report_echo_01
mathilde_bathroom_correction_echo_01
```

---

# 3. Card — Marie makes room

```yaml
scene_id: marie_mathilde_emergency_make_room_01
working_title: Make room
scene_class: spine scene
primary_function: household change + quality of Player participation
primary_relationship: Player / Marie
principal_character: Marie
```

## Canon dependencies

```yaml
required_canon_files:
  - MARIE_CANON_FULL.md
  - MATHILDE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - MODULAR_NARRATIVE_ARC_BLUEPRINT.md
  - CHOICE_DESIGN_CANON.md
relevant_deprecation_maps:
  - MATHILDE_CANON_DEPRECATION_MAP.md
supporting_character_source: none
adult_canon_required: no
```

## Scope

```yaml
act_range: Act I opening
route_stage_range:
  Marie: couple baseline
  Mathilde: R0 -> stay confirmed, not yet R1 direct
intensity_tier: ordinary
window_types:
  - PRIVATE_MESSAGE
  - PLAYER_WORK_OR_TRANSIT
foreground_cost: 1
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - J1 complete
  - couple mode HABITUAL_WARMTH
  - Mathilde temporary stay inactive
  - water damage can occur
hard_exclusions:
  - Mathilde already established as resident
  - old casual sleepover treated as current canon
  - explicit couple crisis already active
soft_preferences:
  - J1 Mathilde installation seed shown
  - Player showed some presence with Marie in J1
availability_reason:
  - Marie has just received Mathilde's emergency call
```

## Context reads

- J1 Player presence tendency;
- optional J1 Mathilde indirect seed;
- couple mode;
- current household occupancy;
- no adult state.

## Stable engine

```text
real family emergency
-> Marie asks for a shared practical response
-> Player chooses proactive, playful-present, or passive assent
-> Mathilde's stay becomes fixed
-> Marie records whether Player joined the decision or merely allowed it
```

## Choice contract

```yaml
choice_node: M0
primary_decision_axis: how Player participates in making room
choice_count: 3
choices:
  A:
    posture: proactive
    writes:
      - household_preparation_active
      - player_presence_positive
      - marie_feels_joined
  B:
    posture: playful-present
    writes:
      - household_preparation_active
      - playful_presence_signal
      - annexion_joke_available_once
  C:
    posture: passive assent
    writes:
      - marie_carries_decision
      - player_presence_flat
      - parallel_drift_candidate_soft
```

No choice cancels the emergency stay.

Reason:

```text
The scene decides Player's participation,
not whether Marie's cousin is denied short-term emergency shelter.
```

## Character agency

Marie:

- wants to help Mathilde;
- wants Player to exist in the shared-home decision;
- can confirm the stay even if Player answers passively;
- does not turn one weak answer into a relationship crisis;
- does not apologize for having a family life.

Player:

- controls his participation quality;
- does not control Mathilde's feelings or future route.

## State writes

- stay confirmed;
- expected duration 10–15 days;
- arrival obligation due;
- household-preparation quality;
- Marie presence read;
- no route stage advance.

## Trace / knowledge / consent

- no image;
- Marie and Player know the practical cause;
- Mathilde knows Marie is checking with Player;
- no sexual consent question exists.

## Exit contract

```yaml
exit_state:
  - Mathilde stay confirmed
  - arrival due next compatible evening
  - Player participation quality stored conceptually
follow_up_candidates:
  - mathilde_arrival_too_much_luggage_01
  - Marie practical echo
consequence_due: next compatible evening
cooldown: scene never repeats
expiry_or_mutation: mandatory spine; cannot expire
fallback_if_not_seen: none; scene or function-equivalent variant required
```

---

# 4. Card — Mathilde arrives

```yaml
scene_id: mathilde_arrival_too_much_luggage_01
working_title: Too much luggage
scene_class: spine + ordinary access
primary_function: activate household topology and establish Mathilde R1
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
relevant_deprecation_maps:
  - MATHILDE_CANON_DEPRECATION_MAP.md
supporting_character_source: none
adult_canon_required: no
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: Mathilde R0 -> R1
intensity_tier: ordinary
window_types:
  - COUPLE_HOME
  - PRIVATE_MESSAGE
  - TRACE_OR_IMAGE
foreground_cost: 1
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - Mathilde stay confirmed
  - spare room available
  - arrival photo origin is Marie
hard_exclusions:
  - old canapé selfie
  - body-focused arrival photo
  - deliberate Mathilde seduction
  - prior route state above R1
soft_preferences:
  - Player prepared room proactively or playfully
availability_reason:
  - Mathilde arrives with suitcase and practical belongings after water damage
```

## Context reads

- M0 branch;
- J1 optional Mathilde seed;
- current household state;
- Player location or practical absence;
- Marie's availability to take the photo.

## Stable engine

```text
Mathilde occupies visible physical space
-> Marie sends an ordinary arrival trace
-> Mathilde mocks the evidence
-> Player welcomes through help, teasing, or distance
-> direct household access becomes current
```

## Choice contract

```yaml
choice_node: MT0
primary_decision_axis: how Player welcomes Mathilde's temporary presence
choice_count: 3
choices:
  A:
    posture: practical welcome
    writes:
      - mathilde_ordinary_trust_up
      - practical_help_available
  B:
    posture: teasing welcome
    writes:
      - mathilde_ordinary_complicity_up
      - legal_joke_used_once
  C:
    posture: distant welcome
    writes:
      - mathilde_access_established_cool
      - Marie_carries_welcome
```

## Character agency

Mathilde:

- accepts help but does not beg for intimacy;
- can joke to manage embarrassment;
- does not interpret distance as a challenge to seduce;
- remains loyal to Marie;
- has work, belongings, fatigue, and a practical reason for being there.

Marie:

- takes the photo openly;
- remains the family bridge;
- does not sexualize Mathilde's clothes.

## State writes

- temporary stay active;
- household windows unlocked;
- Mathilde R1 ordinary access;
- practical trust / playful complicity / cool access;
- morning kitchen and spare-room engines eligible later.

## Trace record

```yaml
trace_id: mathilde_arrival_room_01
origin: Marie phone
creator: Marie
initial_holder: Player
intended_audience:
  - Player
actual_audience:
  - Player
consent_level: authorized ordinary household image
save_rule: ordinary private saving only
forward_rule: none
knowledge_state:
  Marie: KNOWN
  Mathilde: KNOWN
  Player: KNOWN
risk: low unless later forwarded or sexualized
status: active ordinary trace
```

## Exit contract

```yaml
exit_state:
  - Mathilde is a real temporary resident
  - no sexual intention established
  - direct thread available
follow_up_candidates:
  - morning kitchen
  - spare-room practical scene
  - Marie household check-in
  - Mathilde work anecdote
consequence_due: none unless Player was markedly distant
cooldown: no second arrival/settling foreground
expiry_or_mutation: household state persists until end-of-stay arc
fallback_if_not_seen: mandatory function-equivalent arrival scene
```

---

# 5. Card — Raphaëlle blue-folder review

```yaml
scene_id: raphaelle_blue_folder_review_01
working_title: Already verified
scene_class: ordinary access
primary_function: establish Raphaëlle through normal peer work
primary_relationship: Player / Raphaëlle
principal_character: Raphaëlle
```

## Canon dependencies

```yaml
required_canon_files:
  - RAPHAELLE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
relevant_deprecation_maps:
  - RAPHAELLE_CANON_DEPRECATION_MAP.md
supporting_character_source: none
adult_canon_required: no
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: Raphaëlle R0 -> R1
intensity_tier: ordinary
window_types:
  - PLAYER_WORK
foreground_cost: 1
 echo_compatible: true
```

## Eligibility

```yaml
hard_requirements:
  - normal work collaboration
  - peer relationship intact
  - no private route active
hard_exclusions:
  - after-hours seduction framing
  - personal costume photo
  - Player using Raphaëlle as couple refuge
soft_preferences:
  - Player has an ordinary work mistake or unfinished note
availability_reason:
  - Raphaëlle and Player share the same project review
```

## Context reads

- Player work obligation;
- Raphaëlle work trust baseline;
- no couple secret required;
- no private Raphaëlle knowledge.

## Stable engine

```text
concrete work inconsistency
-> Raphaëlle points it out without humiliation
-> Player owns, jokes-and-fixes, or delays
-> professional trust is established
-> ordinary human detail closes the scene
```

## Choice contract

```yaml
choice_node: R0
primary_decision_axis: how Player handles a normal professional correction
choice_count: 3
choices:
  A:
    posture: accountable
    writes:
      - raphaelle_work_trust_up
      - task_complete
  B:
    posture: dry humor plus action
    writes:
      - raphaelle_humor_access
      - raphaelle_work_trust_stable_up
      - task_complete
  C:
    posture: delay
    writes:
      - work_correction_due_today
      - raphaelle_work_trust_neutral
```

## Character agency

Raphaëlle:

- asks one work question;
- does not diagnose Player's personal life;
- does not become intimate because he is tired;
- leaves the responsibility with Player;
- uses dry humor only after the practical point is clear.

## State writes

- Raphaëlle R1 ordinary access;
- professional trust variant;
- optional work correction obligation;
- no attraction state.

## Trace / knowledge / consent

- optional blue-folder work visual;
- work-channel appropriate;
- no personal image;
- no adult frame.

## Exit contract

```yaml
exit_state:
  - Raphaëlle is established as a real colleague
  - work trust quality known
follow_up_candidates:
  - ordinary lunch walk
  - garment-bag work detail
  - after-hours deadline only if context creates it
consequence_due: work correction if R0C
cooldown: no second correction engine in next work window
expiry_or_mutation: R0C obligation must be paid or become a work consequence
fallback_if_not_seen: another ordinary work-access scene before any personal Raphaëlle content
```

---

# 6. Echo card — Sandra morning continuity

```yaml
scene_id: sandra_poste_matin_continuity_01
working_title: The button returned
scene_class: echo
primary_function: preserve J1 trace continuity without escalation
primary_relationship: Player / Sandra
principal_character: Sandra
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: soft trace seed; no advance
time_cost: echo
window_types:
  - PRIVATE_MESSAGE
```

## Eligibility

Required:

- J1 Sandra thread occurred;
- enough time has passed for a poste du matin;
- Sandra has not just closed after a distant branch in a way that makes immediate contact implausible.

Excluded:

- new photo;
- Thursday rendezvous promise;
- Jeff exposition;
- direct confession;
- pressure.

## Engine

```text
ordinary work absurdity
-> short contact
-> photo continuity only if earned
-> Sandra ends before the scene becomes a demand
```

## Reads

- J1 Sandra choice;
- recent message cooldown;
- route cooled or open.

## Writes

- continuity active or intentionally cooled;
- no route-stage increase;
- no obligation.

## Mutation

- precise J1 branch: mention the old photo remains floue;
- warm/playful branch: mention it is back in her bag;
- distant branch: end after work joke or omit echo.

## Exit

No consequence due.

---

# 7. Card — Marie's movement offer

```yaml
scene_id: marie_thursday_movement_offer_01
working_title: Two reasons
scene_class: spine topology scene
primary_function: S2 Movement Offered
primary_relationship: Player / Marie
principal_character: Marie
```

## Canon dependencies

```yaml
required_canon_files:
  - MARIE_CANON_FULL.md
  - PLAYER_CANON_FULL.md
  - MATHILDE_CANON_FULL.md
  - MODULAR_NARRATIVE_ARC_BLUEPRINT.md
  - CHOICE_DESIGN_CANON.md
supporting_character_source:
  - SUPPORTING_CHARACTER_CANON_POLICY.md
adult_canon_required: no
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: couple baseline
intensity_tier: ordinary
window_types:
  - PRIVATE_MESSAGE
  - COUPLE_HOME
foreground_cost: 1
 echo_compatible: false
```

## Eligibility

```yaml
hard_requirements:
  - J1 petit événement jeudi reference available
  - Mathilde stay active
  - Marie event not yet completed
hard_exclusions:
  - couple open crisis
  - event canceled
  - urgent safety or aftermath scene due
soft_preferences:
  - Player has already made one household participation choice
availability_reason:
  - Marie is finalizing the La Verrière event and asks Player directly
```

## Stable engine

```text
Marie has a real event and wants Player there
-> she names practical need and personal desire separately
-> Player chooses early presence, home, or real work obligation
-> each choice opens one distinct topology
-> later consequence returns to Marie
```

## Choice contract

```yaml
choice_node: M1
primary_decision_axis: where and how Player will be present for Marie's movement
choice_count: 3
choices:
  A:
    posture: join early
    topology: PLAYER_WITH_MARIE_SOCIAL
    writes:
      - event_arrival_18h_due
      - opening_branch_O5A
  B:
    posture: stay at shared home
    topology: HOME_WITHOUT_MARIE
    writes:
      - opening_branch_O5B
      - Marie_independent_social_action
  C:
    posture: finish real work and promise later arrival
    topology: PLAYER_WORK_THEN_MARIE_SOCIAL
    writes:
      - opening_branch_O5C
      - join_after_work_obligation
```

## Character agency

Marie:

- goes regardless of Player's answer;
- wants him but does not collapse if he declines;
- does not offer Mathilde as a reason to stay;
- distinguishes practical help from being chosen;
- creates a later return consequence.

Mathilde:

- independently chooses to stay home because of insurance follow-up and fatigue;
- is not assigned to Player.

## Exit contract

```yaml
exit_state:
  - one topology selected
  - branch foreground due
  - return-to-Marie consequence guaranteed
follow_up_candidates:
  - marie_laverriere_setup_joined_01
  - mathilde_spare_room_charger_01
  - raphaelle_accessibility_review_late_01
consequence_due: branch O5 then O6 return
cooldown: one topology offer only for this event
expiry_or_mutation: event happens without waiting indefinitely
fallback_if_not_seen: mandatory movement-offered variant required
```

---

# 8. Card — O5A Marie / La Verrière

```yaml
scene_id: marie_laverriere_setup_joined_01
working_title: The black extension cord
scene_class: topology foreground
primary_function: active couple participation
primary_relationship: Player / Marie
principal_character: Marie
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: couple baseline
intensity_tier: ordinary with soft charge
window_types:
  - PLAYER_WITH_MARIE_SOCIAL
  - GROUP_EVENT
foreground_cost: 1
 echo_compatible: true
```

## Eligibility

Required:

- M1A chosen;
- Player arrives for setup;
- Marie event active.

Excluded:

- Player misses 18h entirely;
- explicit adult aftermath due;
- social event canceled.

## Engine

```text
Marie is active in her own world
-> practical task proves whether Player joins
-> Player takes initiative, jokes-and-helps, or delays attention
-> Marie reads presence quality
-> Pauline and Nico appear through ordinary echoes
```

## Choice contract

```yaml
choice_node: MA0
primary_decision_axis: quality of Player participation after choosing to attend
choice_count: 3
choices:
  A:
    posture: initiative
    writes:
      - couple_presence_up
      - active_reconnection_candidate
  B:
    posture: playful help
    writes:
      - playful_presence_signal
      - task_paid
  C:
    posture: present but distracted
    writes:
      - presence_strained
      - parallel_drift_candidate_soft
```

## Character agency

Marie:

- runs the event;
- assigns tasks;
- stays socially alive;
- can be pleased or disappointed without becoming jealous;
- does not exist only as a test.

Pauline:

- appears practically;
- does not open a private crop.

Nico:

- keeps a table as ordinary social support;
- does not make a body comment.

## Trace

`marie_laverriere_setup_01` may be created.

Consent:

- authorized event image;
- public/social context;
- no private sexual function.

## Exit contract

```yaml
exit_state:
  - Marie social visibility established
  - Player participation quality known
  - public group photo due
follow_up_candidates:
  - marie_after_first_event_return_01
  - pauline_public_group_photo_relay_01
  - nico_saved_seat_followup_01
consequence_due: O6 return to Marie
cooldown: no second event-setup foreground in opening band
expiry_or_mutation: exact event cannot repeat
fallback_if_not_seen: not applicable; mutually exclusive topology
```

---

# 9. Card — O5B Mathilde / spare room

```yaml
scene_id: mathilde_spare_room_charger_01
working_title: Evidence in the blue box
scene_class: topology foreground
primary_function: practical domestic access
primary_relationship: Player / Mathilde
principal_character: Mathilde
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: Mathilde R1
intensity_tier: ordinary
window_types:
  - HOME_WITHOUT_MARIE
  - PRIVATE_MESSAGE
foreground_cost: 1
 echo_compatible: true
```

## Eligibility

Required:

- M1B chosen;
- Mathilde independently stays home;
- Marie at La Verrière;
- stay active.

Excluded:

- deliberate outfit scene;
- prior Mathilde boundary;
- Nico photo request;
- explicit adult tension.

## Engine

```text
practical lost object
-> Mathilde uses one light legal joke
-> Player helps, jokes-and-helps, or keeps distance
-> household access changes without sexualizing the room
-> Marie social echo prevents route replacement
```

## Choice contract

```yaml
choice_node: MH0
primary_decision_axis: Player's practical domestic posture
choice_count: 3
choices:
  A:
    posture: direct help
    writes:
      - mathilde_practical_trust_up
  B:
    posture: playful help
    writes:
      - mathilde_ordinary_complicity_up
  C:
    posture: distance
    writes:
      - mathilde_access_cools
      - player_household_presence_down
```

## Character agency

Mathilde:

- chose to stay for her own practical reason;
- requests help but can solve the problem herself;
- does not use Player's presence as automatic flirtation;
- stops asking if he is distant.

Marie:

- remains active through the social echo;
- asks whether both are surviving, not whether they are behaving.

## Trace

Optional cable-pile visual:

- ordinary;
- no body;
- intended for Player only;
- no forwarding.

## Exit contract

```yaml
exit_state:
  - Mathilde household access remains ordinary
  - no gaze or intent acknowledged
  - Marie event continues independently
follow_up_candidates:
  - morning kitchen later
  - Mathilde work anecdote
  - Marie household return
consequence_due: O6 return to Marie
cooldown: no second lost-object engine in next two Mathilde windows
expiry_or_mutation: exact charger scene cannot repeat
fallback_if_not_seen: not applicable; mutually exclusive topology
```

---

# 10. Card — O5C Raphaëlle / after-hours review

```yaml
scene_id: raphaelle_accessibility_review_late_01
working_title: A correct version at 18h40
scene_class: topology foreground
primary_function: work obligation under an external promise
primary_relationship: Player / Raphaëlle
secondary_relationship: Player / Marie
principal_character: Raphaëlle
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: Raphaëlle R1
intensity_tier: ordinary
window_types:
  - PLAYER_WORK
foreground_cost: 1
 echo_compatible: true
```

## Eligibility

Required:

- M1C chosen;
- real work review incomplete;
- join-after-work promise active.

Excluded:

- Raphaëlle personal route above R1;
- workplace hierarchy pressure;
- invented deadline solely to create intimacy.

## Engine

```text
real work decision
-> Raphaëlle asks for a usable version
-> Player chooses to decide, amend promise honestly, or remain vague
-> Raphaëlle completes her own responsibility and leaves
-> Marie promise outcome becomes due
```

## Choice contract

```yaml
choice_node: RW0
primary_decision_axis: how Player handles work and his explicit promise
choice_count: 3
choices:
  A:
    posture: decide and leave
    writes:
      - work_complete
      - promise_kept
      - raphaelle_work_trust_up
  B:
    posture: honest limited delay
    writes:
      - work_complete_late
      - Marie_informed_before_expiry
      - promise_amended_honestly
  C:
    posture: vague absorption
    writes:
      - Player_continues_alone
      - promise_likely_missed
      - work_as_shelter_signal
```

## Character agency

Raphaëlle:

- refuses `on voit` as a project decision;
- does not invite Player to stay for intimacy;
- leaves after her own responsibility;
- may reveal the garment bag only as ordinary life;
- does not become an excuse.

## Trace / knowledge

- join-after-work promise is known to Player and Marie;
- Raphaëlle knows only that Player has somewhere to be if he tells her;
- Raphaëlle does not know the couple crisis;
- garment bag creates no image or consent state.

## Exit contract

```yaml
exit_state:
  - work complete or Player continues alone
  - promise outcome determined
  - Raphaëlle remains ordinary work access
follow_up_candidates:
  - marie_after_first_event_return_01
  - later garment-bag ordinary access
consequence_due: immediate O6 Marie return
cooldown: no second after-hours deadline in opening band
expiry_or_mutation: exact event promise expires that evening
fallback_if_not_seen: not applicable; mutually exclusive topology
```

---

# 11. Card — Return to Marie

```yaml
scene_id: marie_after_first_event_return_01
working_title: What the evening meant
scene_class: consequence scene
primary_function: pay topology and promise consequence
primary_relationship: Player / Marie
principal_character: Marie
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: couple baseline
intensity_tier: ordinary emotional consequence
window_types:
  - COUPLE_HOME
  - PRIVATE_MESSAGE
  - AFTERMATH_LIGHT
foreground_cost: 1
 echo_compatible: false
```

## Eligibility

Required:

- O5 topology foreground complete;
- Marie event complete or ending;
- no higher safety consequence due.

Excluded:

- replacement by a new external opportunity;
- open-crisis speech;
- route lock.

## Context reads

- M1 topology;
- MA0 / MH0 / RW0 branch;
- promise status;
- J1 presence tendency;
- current couple mode.

## Stable engine

```text
private branch ends
-> Marie returns or Player returns to Marie
-> prior action is reflected accurately
-> no abstract relationship speech
-> presence tendency becomes a remembered pattern candidate
```

## Choice contract

No new choice.

Reason:

```text
The meaningful decision was already made.
This scene is the consequence and should not offer a fake undo.
```

## Character agency

Marie:

- names what she experienced;
- can appreciate another kind of useful presence;
- can be disappointed without escalating to crisis;
- does not forgive or condemn an event that is still low-stakes;
- ends the cycle in shared life.

## State writes

- promise kept / amended / missed resolved;
- presence candidate strengthened;
- missed-opportunity trace on RW0C;
- no immediate couple-mode transition;
- next public-trace window eligible.

## Exit contract

```yaml
exit_state:
  - topology consequence paid
  - couple remains HABITUAL_WARMTH
  - active_reconnection or parallel_drift candidate may exist
follow_up_candidates:
  - pauline_public_group_photo_relay_01
  - nico_saved_seat_followup_01
  - household breather
consequence_due: none immediate
cooldown: no new Marie event test in next cycle
expiry_or_mutation: fixed consequence; cannot expire
fallback_if_not_seen: none; mandatory
```

---

# 12. Card — Pauline public group-photo relay

```yaml
scene_id: pauline_public_group_photo_relay_01
working_title: Three public versions
scene_class: ordinary access + trace scene
primary_function: establish Pauline through legitimate image competence
primary_relationship: Player / Pauline
secondary_relationship: Marie / Pauline
principal_character: Pauline
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: Pauline R0 -> R1
intensity_tier: ordinary
window_types:
  - TRACE_OR_IMAGE
  - PRIVATE_MESSAGE
foreground_cost: 1
 echo_compatible: true
```

## Eligibility

Required:

- La Verrière event occurred;
- authorized group-photo set exists;
- Marie asks Pauline to relay or select;
- Pauline/Bastien current couple remains visible.

Excluded:

- private crop;
- one-view image;
- body-focused alternate;
- secret route;
- image-forwarding breach.

## Engine

```text
authorized public image set
-> Pauline relays through Marie's request
-> Player answers practically, dryly, or defers to Marie
-> Pauline's competence and tone become recognizable
-> no private compartment opens
```

## Choice contract

```yaml
choice_node: P0
primary_decision_axis: how Player participates in a legitimate public selection
choice_count: 3
choices:
  A:
    posture: practical
    writes:
      - Pauline_practical_trust_up
      - public_photo_2_selected
  B:
    posture: dry joke
    writes:
      - Pauline_ordinary_complicity
      - public_photo_2_selected
  C:
    posture: defer to Marie
    writes:
      - Marie_remains_decision_owner
      - Pauline_access_established
```

## Character agency

Pauline:

- owns the practical photo process;
- does not create a private version;
- remains attached to Bastien and Marie;
- can find Player dryly funny without testing him.

Marie:

- remains event owner;
- may decide the final public post.

## Trace record

```yaml
trace_id: laverriere_public_group_photo_set_01
origin: Pauline remote shutter
creator: Pauline
holders:
  - Pauline
  - Marie
  - Player after relay
intended_audience:
  - photographed group
  - La Verrière archive/public post
actual_audience: same
consent_level: authorized social image
save_rule: ordinary social saving
forward_rule: event/public context only
adult_function: none
risk: low at creation
```

## Exit contract

```yaml
exit_state:
  - Pauline R1 ordinary access
  - Bastien visible in social context
  - public trace exists
follow_up_candidates:
  - later social logistics
  - later private selectivity only after another cycle
consequence_due: none
cooldown: no second photo-selection scene immediately
expiry_or_mutation: image may gain context later; no private meaning now
fallback_if_not_seen: equivalent legitimate Pauline relay before any private route content
```

---

# 13. Card — Nico saved-seat follow-up

```yaml
scene_id: nico_saved_seat_followup_01
working_title: The chair had better hours
scene_class: ordinary access
primary_function: establish friendship and social-mirror seed
primary_relationship: Player / Nico
principal_character: Nico
```

## Scope

```yaml
act_range: Act I opening
route_stage_range: Nico R0 -> R1
intensity_tier: ordinary
window_types:
  - PRIVATE_MESSAGE
foreground_cost: 1 or shortened ordinary variant
 echo_compatible: true
```

## Eligibility

Required:

- La Verrière event occurred;
- Nico credibly reserved or held a table/seat;
- no Nico route active.

Excluded:

- body comment about Marie or Mathilde;
- voyeuristic photo request;
- alibi pact;
- NTR/cuckold framing;
- fake friendship.

## Engine

```text
saved seat or event survival joke
-> Player answers honestly, playfully, or asks about Marie
-> Nico responds as friend, not rival
-> Marie remains the subject of Player's attention
-> Nico may learn Mathilde's stay without sexualizing it yet
```

## Choice contract

```yaml
choice_node: N0
primary_decision_axis: how Player receives Nico's ordinary friendship mirror
choice_count: 3
choices:
  A:
    posture: honest
    writes:
      - Nico_friendship_trust_up
      - missed_opportunity_acknowledged_if_relevant
  B:
    posture: playful
    writes:
      - Nico_ordinary_banter_access
  C:
    posture: ask about Marie
    writes:
      - Nico_social_mirror_seed
      - Player_attention_returns_to_Marie
```

## Character agency

Nico:

- saves a seat genuinely;
- can tease without using Marie as a conquest object;
- does not diagnose Player's erotic reaction yet;
- may learn Mathilde's stay through a credible source;
- does not ask for images.

## Knowledge update

Optional:

```yaml
fact: Mathilde temporary stay
Nico: KNOWN
source: Marie, Pauline, or Player
meaning: ordinary social knowledge only
```

## Exit contract

```yaml
exit_state:
  - Nico R1 ordinary access
  - social mirror seed possible
  - no voyeurism or rivalry state
follow_up_candidates:
  - ordinary L'Annexe scene
  - pool/darts friendship
  - Act II domestic-access envy after new context
consequence_due: none
cooldown: no immediate Nico body/gaze escalation
expiry_or_mutation: saved-seat joke cannot repeat unchanged
fallback_if_not_seen: another ordinary friendship scene before Nico tension
```

---

# 14. Echo cards — Household breather

## 14.1 Marie household report

```yaml
scene_id: marie_household_report_echo_01
class: echo
function: confirm enlarged ordinary life
requirements:
  - Mathilde stay active
  - opening event consequence paid
writes:
  - household_rhythm_confirmed
route_effect: none
```

## 14.2 Mathilde correction

```yaml
scene_id: mathilde_bathroom_correction_echo_01
class: echo
function: give Mathilde ordinary voice and family friction
requirements:
  - Mathilde ordinary access warm enough
exclusions:
  - Mathilde recently withdrew after distance
writes:
  - household_rhythm_confirmed
route_effect: none
```

These echoes do not create a visible mandatory group thread.

---

# 15. Opening selection policy

## 15.1 Fixed priority

Within this pack:

```text
O1 household spine
-> O2 arrival spine
-> O3 Raphaëlle ordinary access
-> O4 topology choice
-> O5 selected branch
-> O6 Marie consequence
-> O7 Pauline trace and O8 Nico follow-up in context-appropriate order
```

Sandra echo may appear when it does not displace a foreground scene.

## 15.2 O5 exclusivity

```text
marie_laverriere_setup_joined_01
OR
mathilde_spare_room_charger_01
OR
raphaelle_accessibility_review_late_01
```

The unselected scenes are not queued unchanged.

They become missed context-specific opportunities and may later be replaced by different scenes using the same engine.

## 15.3 Consequence priority

`marie_after_first_event_return_01` outranks:

- Pauline photo relay;
- Nico follow-up;
- Sandra echo;
- any new optional route opportunity.

## 15.4 Coverage priority

If O7 or O8 must be delayed for pacing:

- the unseen principal character's ordinary access becomes priority E in the next compatible window;
- it must occur before any R2 tension scene for that character.

---

# 16. Opening-state summary

At pack completion:

```yaml
couple:
  mode: HABITUAL_WARMTH
  frame: ASSUMED_EXCLUSIVE
  active_reconnection_candidate: possible
  parallel_drift_candidate: possible
  hard_trust_damage: false

Mathilde:
  stay_active: true
  route_stage: R1
  deliberate_intent: false

Sandra:
  route_stage: soft trace seed / cooled R1
  new_image: false

Raphaëlle:
  route_stage: R1
  personal_access: false

Pauline:
  route_stage: R1
  private_compartment: false

Nico:
  route_stage: R1
  voyeurism_active: false
  photo_pact_active: false

traces:
  mathilde_arrival_room: authorized private ordinary
  laverriere_setup: authorized event image if created
  laverriere_public_group_photo_set: authorized social/public

secrets:
  consequential_hidden_count: 0

adult_frames:
  none
```

---

# 17. Review checklist

The pack is authoring-complete only if every item remains true:

- [ ] J1 text unchanged;
- [ ] Mathilde stay begins through water damage;
- [ ] Player choice controls participation, not emergency shelter itself;
- [ ] Mathilde arrival visual is practical, not erotic;
- [ ] Raphaëlle's first scene is normal peer work;
- [ ] Sandra sends no new photo;
- [ ] Marie's event choice has exactly three topologies;
- [ ] Mathilde independently chooses whether to attend;
- [ ] only one O5 branch foreground occurs;
- [ ] every O5 branch returns to Marie;
- [ ] Pauline relays only authorized public images;
- [ ] Bastien remains visible in Pauline's social context;
- [ ] Nico remains an ordinary friend before voyeurism;
- [ ] no route exceeds R1;
- [ ] no secret or adult consent frame exists;
- [ ] every foreground node has exactly three choices;
- [ ] no fake undo choice appears in the return consequence;
- [ ] image origin and audience are explicit;
- [ ] runtime remains untouched.

---

# 18. Final rule

```text
These scene cards do not build routes by distributing flirt points.

They build a remembered opening:
Player made room or let Marie make it,
joined or missed her event,
kept or weakened a promise,
and met every other person first inside ordinary life.
```
