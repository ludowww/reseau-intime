# Act I Named Boundaries Wave Scene Cards — V0.93

> Modular scene cards for the V0.93 named-boundaries wave.
> Companion to `ACT_I_NAMED_BOUNDARIES_WAVE_SOURCE_PACK.md`.
> Documentation only. These cards do not create runtime, JSON, GDScript, tests, assets, saves, commits on `main`, merges, or tags.

## 1. Card usage rules

Every future implementation must preserve:

```text
3 choices per normal node
one primary decision axis per node
real Player messages
character agency
Marie centrality
explicit state writes
no route-selection menu
no automatic adult permission
```

The full character canon remains primary.

Read the global NSFW canon when reviewing attraction, image, secrecy, voyeurism, cheating, or adult-route implications, even though this wave does not open an adult frame.

Scene absence is meaningful.

The W15 carry-over consequence may be:

```text
Mathilde
Sandra
none
```

It must never be replaced by an unrelated character merely to fill a slot.

---

# 2. Card — Marie next-week real plan

## Identity

```text
scene_id: marie_next_week_real_plan_01
working_title: Pas une semaine floue
primary_function: explicit couple request + topology choice
primary_relationship: Player / Marie
principal_character: Marie
```

## Canon dependencies

```text
required_canon_files:
- MARIE_CANON_FULL.md
- PLAYER_CANON_FULL.md
- CHOICE_DESIGN_CANON.md
- MODULAR_NARRATIVE_ARC_BLUEPRINT.md
- DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
adult_canon_required: no
```

## Scope and intensity

```text
act_range: Act I S5
route_stage_range: couple HABITUAL_WARMTH
intensity_tier: warm pressure
window_types: REMOTE_ASYNC -> OFFLINE_TOPOLOGY
foreground_cost: 1 fixed foreground
echo_compatible: yes
```

## Eligibility

Hard requirements:

- `first_repetition_wave_complete`;
- Tuesday after the closed Monday;
- Marie and Player still share a home and assumed-exclusive frame;
- no urgent safety or adult aftermath;
- Marie has a real Wednesday La Verrière commitment;
- Pauline and Bastien are legitimately available for the social hub;
- Nico is scheduled at L'Annexe.

Hard exclusions:

- relationship already explicitly ended;
- Marie route closed through a future state not defined in V0.93;
- the Wednesday hub was already resolved;
- the same exact plan was already offered.

Availability reason:

```text
Marie needs to confirm the Wednesday social table before noon.
She also refuses another week structured by Player's vague availability.
```

## Context reads

- active-reconnection evidence;
- parallel-drift evidence;
- whether both coexist;
- Monday Marie return outcome;
- recent broken or paid promises;
- current work pressure;
- Mathilde stay active;
- no private route knowledge beyond what Marie directly observed.

## Opening beat

Marie gives concrete facts before emotional interpretation:

- La Verrière ends around 19:00;
- Pauline and Bastien plan to stop at L'Annexe;
- Nico needs a table answer;
- Thursday is still available as couple time;
- Player must choose an action, not a route.

## Choice node M4

Choice count:

```text
3
```

Primary axis:

```text
What real place does Player choose inside the next two evenings?
```

### M4A — Join from the beginning

Player action:

```text
join Marie at La Verrière
help close
leave with her for L'Annexe
```

State writes:

```text
marie_wednesday_join_from_start
social_hub_topology_joined
obligation: marie_wednesday_shared_presence = SCHEDULED
```

Consequence due:

- payment at La Verrière before the group table;
- no external route reward;
- failure if Player simply does not appear.

### M4B — Precise late arrival

Player action:

```text
finish real work
arrive at L'Annexe at a named time
warn before any change
```

State writes:

```text
marie_wednesday_precise_arrival
social_hub_topology_late
obligation: marie_wednesday_arrival = SCHEDULED
```

Consequence due:

- paid if on time or amended before deadline;
- failed if missed without warning;
- work remains a fact, not a moral excuse.

### M4C — Decline group, protect Thursday

Player action:

```text
do not attend the group evening
reserve Thursday couple time
make one concrete proposal
```

State writes:

```text
marie_thursday_couple_time_reserved
social_hub_topology_marie_independent
obligation: marie_thursday_couple_time = SCHEDULED
```

Consequence due:

- Marie attends Wednesday independently;
- Thursday plan must be paid or honestly failed;
- this choice is not labeled bad or cowardly.

## Character agency

Marie may accept all three choices.

She does not promise identical warmth after every outcome.

She keeps the right to enjoy Wednesday, change her own plan, refuse a late amendment, or shorten Thursday if Player turns another concrete promise into a vague one.

## Exit contract

```text
one M4 obligation exists
Wednesday topology is known
Marie remains active
no route stage changes
```

## Anti-patterns

Reject:

- `choose Marie / Pauline / Nico` labels;
- Marie asking for reassurance instead of action;
- Player promising both Wednesday and Thursday to avoid choosing;
- a fourth choice for `maybe`;
- automatic jealousy because Pauline or Nico will be present;
- a scene that frames Marie as the safe option against erotic routes.

---

# 3. Card — Mathilde named gaze boundary

## Identity

```text
scene_id: mathilde_named_gaze_boundary_01
working_title: Pas innocent, pas autorisé
primary_function: acknowledged attraction + explicit limit
primary_relationship: Player / Mathilde
principal_character: Mathilde
```

## Canon dependencies

```text
required_canon_files:
- MATHILDE_CANON_FULL.md
- MARIE_CANON_FULL.md
- PLAYER_CANON_FULL.md
relevant_deprecation_maps:
- MATHILDE_CANON_DEPRECATION_MAP.md
adult_canon_required: yes, for exclusions and consent meaning
```

## Scope and intensity

```text
act_range: Act I S5
route_stage_range: R1-R2
intensity_tier: acknowledged attraction
window_types: DOMESTIC_PRIVATE_CONVERSATION
foreground_cost: 1 carry-over consequence
echo_compatible: no
```

## Eligibility

Preferred hard trigger:

```text
first_repetition.charged_access_owner = mathilde
```

Fallback trigger:

```text
Mathilde historical scene = RESOLVED
and no more urgent charged-owner consequence exists
```

Additional requirements:

- temporary stay active;
- Mathilde has not clearly closed the route;
- Player did not pressure her after a refusal;
- Marie is absent from the immediate room but present in the meaning;
- no adult aftermath due.

Hard exclusions:

- Mathilde scene never occurred;
- historical scene expired or deferred without acknowledgement;
- boundary already named in an equivalent scene;
- Mathilde has left the apartment permanently;
- a future Marie discovery requires priority.

Availability reason:

```text
Mathilde and Player share the kitchen before work.
The same ordinary outfit now carries remembered meaning because the Sunday gaze was acknowledged.
```

## Context reads

- historical charged owner;
- Mathilde Sunday choice;
- Player's earlier Mathilde posture;
- Marie return outcomes;
- current household trust;
- whether Player denied, joked, or owned the gaze before;
- no Sandra knowledge leak.

## Choice node MT2

Choice count:

```text
3
```

Primary axis:

```text
Does Player own the gaze and respect the limit,
restore distance,
or deny what Mathilde has named?
```

### MT2A — Own and slow

State writes:

```text
mathilde_gaze_owned_without_escalation
mathilde_boundary_respected_explicit
named_boundary: mathilde_no_secret_escalation
```

Preserves:

- Mathilde owner if already owner;
- future trust;
- no image, touch, or adult permission.

### MT2B — Restore ordinary distance

State writes:

```text
mathilde_attraction_named
mathilde_route_held
named_boundary: mathilde_distance_before_escalation
```

Preserves:

- attraction as real;
- route stage unchanged;
- ordinary household functioning.

### MT2C — Minimize

State writes:

```text
mathilde_feels_gaze_denied
mathilde_access_cooled
named_boundary: mathilde_no_more_opinion_requests
```

Consequences:

- Mathilde stops asking Player's view during this wave;
- no punishment seduction;
- no historical ledger erasure;
- current access may pause.

## Character agency

Mathilde initiates the boundary because she wants control over what her own pleasure means.

She may:

- stay playful;
- become briefly serious;
- reject a response;
- leave the kitchen;
- continue ordinary life without resolving the attraction.

Player does not decide whether Mathilde liked being watched.

She says it herself.

## Exit contract

```text
Mathilde pleasure may be named
Mathilde limit is explicit
Marie remains active in the subtext
route stage <= R2
adult permission = false
```

## Anti-patterns

Reject:

- wardrobe change presented as consent;
- more than one legal joke;
- `you know you wanted it` language from Player;
- Mathilde forgetting Marie;
- instant confession or physical crossing;
- chosen provocative photo;
- route advancement because Player gives the boldest reply;
- owner clearing merely to simplify later selection.

---

# 4. Card — Sandra not-a-secret-routine boundary

## Identity

```text
scene_id: sandra_not_a_secret_routine_01
working_title: Pas une habitude cachée
primary_function: name emotional repetition + soft limit
primary_relationship: Player / Sandra
principal_character: Sandra
```

## Canon dependencies

```text
required_canon_files:
- SANDRA_CANON_FULL.md
- PLAYER_CANON_FULL.md
- MARIE_CANON_FULL.md
supporting_character_source:
- Jeff remains part of Sandra's real life through SANDRA_CANON_FULL.md
adult_canon_required: yes, for secrecy and consent exclusions
```

## Scope and intensity

```text
act_range: Act I S5
route_stage_range: R1
intensity_tier: soft charge
window_types: REMOTE_ASYNC
foreground_cost: 1 carry-over consequence
echo_compatible: no
```

## Eligibility

Hard requirements:

- Sandra historical Monday scene = `RESOLVED`;
- charged owner is empty;
- Sandra is the most recent resolved foreground, or Mathilde has no higher-priority consequence;
- no unanswered Player pressure;
- route not closed;
- concrete availability reason.

Hard exclusions:

- Sandra scene expired or deferred;
- Player ignored a clear no and continued;
- same exact boundary already named;
- Jeff or Marie knowledge is incorrectly inferred;
- the scene would require a new photo.

Availability reason:

```text
Sandra passes the café again during a lunch break or after a later poste.
The place creates a concrete trace before she names the emotional problem.
```

## Context reads

- Monday Sandra outcome;
- Thursday Sandra trace history;
- whether Player was precise, warm, or evasive;
- whether the meeting occurred or a future lunch was proposed;
- no Mathilde details;
- no Jeff villainization.

## Choice node S3

Choice count:

```text
3
```

Primary axis:

```text
Does Player accept the truth without pressure,
protect rarity,
or avoid responsibility through humor?
```

### S3A — Name mutual importance

State writes:

```text
sandra_importance_named_soft
sandra_boundary_respected
named_boundary: sandra_no_proof_demand
```

No writes:

```text
confession
affair
new image
R2
```

### S3B — Protect a rare rhythm

State writes:

```text
sandra_contact_kept_rare
sandra_warm_bounded_access
named_boundary: sandra_no_hidden_routine
```

No future promise is required.

### S3C — Deflect

State writes:

```text
sandra_reads_avoidance
sandra_access_cooled
named_boundary: sandra_withdraws_after_deflection
```

Sandra closes the conversation herself.

## Character agency

Sandra chooses to reveal that the moment mattered.

She also chooses the limit.

Player may answer well or badly.

He may not earn more access by pressing after she has closed the exchange.

## Exit contract

```text
repetition can no longer be called accidental
Sandra remains R1
no new image
no confession
no affair
```

## Anti-patterns

Reject:

- direct love confession;
- Jeff made monstrous to justify the scene;
- another café meeting as automatic reward;
- photo as proof of trust;
- multiple `haha` markers;
- Mathilde legal vocabulary;
- pressure rewarded;
- Sandra explaining the whole route architecture.

---

# 5. Card — L'Annexe legitimate social return

## Identity

```text
scene_id: lannexe_legitimate_social_return_01
working_title: La table gardée
primary_function: social visibility + obligation payment
primary_relationship: Player / Marie
principal_characters: Marie, Pauline, Nico
supporting_character: Bastien
```

## Canon dependencies

```text
required_canon_files:
- MARIE_CANON_FULL.md
- PAULINE_CANON_FULL.md
- NICO_CANON_FULL.md
- PLAYER_CANON_FULL.md
supporting_character_source:
- SUPPORTING_CHARACTER_CANON_POLICY.md
adult_canon_required: yes, for image and betrayed-partner exclusions
```

## Scope and intensity

```text
act_range: Act I S5
route_stage_range: R1 only
intensity_tier: ordinary social charge
window_types: CO_PRESENT_SOCIAL_HUB
foreground_cost: fixed hub, not a route-stage foreground
echo_compatible: yes
```

## Eligibility

Hard requirements:

- M4 resolved;
- Wednesday evening;
- Marie's La Verrière task occurred;
- Pauline and Bastien are both legitimately available;
- Nico is working at L'Annexe;
- no safety incident outranks the hub.

Hard exclusions:

- Bastien erased from a scene that depends on his hosting/social presence;
- Pauline private route already active through a future state;
- Nico unavailable due to a future authored schedule conflict;
- Player topology already failed in a way requiring immediate Marie consequence before social content.

Availability reason:

```text
Marie, Pauline, and Bastien stop at L'Annexe after La Verrière.
Nico is working and has held a table after a real confirmation.
```

## Context reads

- M4 topology;
- precise arrival obligation;
- Marie presence/drift evidence;
- Pauline public-photo posture;
- Nico friendship posture;
- no hidden route information.

## Interaction contract

This hub is primarily co-present.

Do not represent the full table as a long Messenger transcript.

Phone content may include:

- arrival logistics;
- one compact delay notification;
- a short table-location message;
- a later follow-up.

The actual social evening is represented through:

- state;
- short result beats;
- later character tone;
- no explanatory `Moments hors ligne` card.

## Topology results

### Joined

```text
Player helps Marie close
-> obligation paid
-> couple enters hub together
```

### Precise arrival paid

```text
Player arrives at named time
-> obligation paid
-> Marie did not need to chase him
```

### Precise arrival failed

```text
Player misses without warning
-> obligation failed
-> Marie stays socially active
-> Thursday consequence sharpens
```

### Marie independent

```text
Player does not attend by prior agreement
-> Marie enjoys the hub independently
-> Thursday obligation remains due
```

## Pauline state

May write:

```text
pauline_legitimate_social_cycle_02_complete
```

Must keep false:

```text
pauline_private_compartment
pauline_private_crop
pauline_secret_test
pauline_reciprocal_proof
```

## Bastien contract

Bastien must:

- have ordinary dialogue or action;
- remain affectionate or socially real with Pauline;
- not be made stupid because he trusts her;
- not become implied consenting cuckold;
- not disappear when the camera or Player's gaze turns toward Pauline.

## Nico contract

Nico is publicly competent before the W17 quiet scene.

He may:

- manage the table;
- bring food;
- tease the group;
- notice timing;
- become quiet only after the room thins.

He may not:

- request a private image;
- offer an alibi;
- privately sexualize Marie or Mathilde during the public hub;
- treat work access as ownership of social images.

## Image rule

New required asset:

```text
none
```

A referenced public photo must preserve:

```text
origin = known
intended audience = group or legitimate social circle
private crop = none
forwarding permission = none inferred
route progression = none
```

## Exit contract

```text
Pauline second legitimate social cycle may be complete
Bastien remains visible
Nico public competence established
M4 obligation paid or failed
W17 Nico scene becomes available
```

## Anti-patterns

Reject:

- Pauline private message hidden inside the hub;
- seductive group photo created as route reward;
- Nico narrating everyone's desire;
- Marie reduced to jealousy observation;
- Player receiving surveillance details when absent;
- a social evening that exists only to place attractive characters in one room.

---

# 6. Card — Nico quiet truth after the room

## Identity

```text
scene_id: nico_quiet_truth_after_room_01
working_title: La version confortable
primary_function: second friendship cycle + male-gaze boundary
primary_relationship: Player / Nico
principal_character: Nico
```

## Canon dependencies

```text
required_canon_files:
- NICO_CANON_FULL.md
- PLAYER_CANON_FULL.md
- MARIE_CANON_FULL.md
- MATHILDE_CANON_FULL.md
adult_canon_required: yes, for gaze, image, alibi, and consent exclusions
```

## Scope and intensity

```text
act_range: Act I S5
route_stage_range: R1
intensity_tier: ordinary friendship with named desire
window_types: QUIET_AFTER_SOCIAL | REMOTE_FOLLOWUP
foreground_cost: 1 fixed foreground
echo_compatible: no
```

## Eligibility

Hard requirements:

- social hub terminal;
- Nico ordinary friendship access active;
- no Nico route closure;
- no image request or alibi already active;
- no overdue Marie consequence requiring immediate priority.

Hard exclusions:

- Nico is intoxicated;
- Player uses the scene to disclose private images;
- Marie or Mathilde consent is inferred;
- same quiet-truth scene already resolved;
- a future safety conflict makes the conversation inappropriate.

Availability reason variants:

```text
Player attended
-> room thins after service

Player arrived late
-> Nico comments after timing became visible

Player was absent
-> Thursday message about the empty chair and Marie's independent evening
```

## Context reads

- M4 topology;
- whether Player paid the arrival obligation;
- whether Mathilde is charged owner;
- only public knowledge of Mathilde's stay;
- Marie social visibility;
- Nico Friday saved-seat posture;
- no private Sandra knowledge.

## Choice node N2

Choice count:

```text
3
```

Primary axis:

```text
Does Player answer honestly without exchanging access,
enter soft complicity,
or define a boundary around the women in his life?
```

### N2A — Honest without exchange

State writes:

```text
nico_quiet_friendship_cycle_02_complete
nico_truth_without_private_exchange
named_boundary: nico_no_domestic_circulation
```

No writes:

```text
shared_gaze
image_request
alibi
R2
```

### N2B — Soft complicity

State writes:

```text
nico_quiet_friendship_cycle_02_complete
nico_complicity_risk_soft
named_boundary: none yet, risk recorded
```

The scene may name attraction.

It may not exchange descriptions, images, or access.

### N2C — Explicit boundary

State writes:

```text
nico_quiet_friendship_cycle_02_complete
nico_gaze_boundary_set
named_boundary: women_not_content_between_men
```

Nico may respect the boundary without becoming humiliated or villainous.

## Character agency

Nico may:

- admit attraction;
- admit envy;
- reject being treated as only a threat;
- become quieter;
- respect a line;
- recognize that direct language is not complete ethics.

Player does not control Nico's attraction.

Nico does not control Marie or Mathilde through his attraction.

## Exit contract

```text
Nico second ordinary cycle complete
shared gaze = false
image request = false
alibi = false
route stage = R1
```

## Anti-patterns

Reject:

- pornographic locker-room monologue;
- stolen or domestic image request;
- `I know she wants it` language;
- Marie or Mathilde treated as objects being traded;
- Nico made villainous for naming attraction;
- Player rewarded for disclosing private details;
- a secret cover pact;
- automatic rivalry route.

---

# 7. Card — Marie named-boundary return

## Identity

```text
scene_id: marie_named_boundary_return_01
working_title: Ce qu'on fait vraiment
primary_function: obligation payment + couple consequence
primary_relationship: Player / Marie
principal_character: Marie
```

## Canon dependencies

```text
required_canon_files:
- MARIE_CANON_FULL.md
- PLAYER_CANON_FULL.md
- CHOICE_DESIGN_CANON.md
adult_canon_required: no
```

## Scope and intensity

```text
act_range: Act I S5
route_stage_range: couple HABITUAL_WARMTH
intensity_tier: warm, disappointed, or mixed
window_types: REMOTE_RETURN -> OFFLINE_SHARED_LIFE
foreground_cost: fixed consequence
echo_compatible: no
```

## Eligibility

Hard requirements:

- M4 obligation exists;
- carry-over consequence terminal or absent;
- social hub terminal;
- Nico scene terminal or explicitly deferred;
- Thursday evening;
- no higher-priority safety aftermath.

Hard exclusions:

- M4 obligation missing because the opening scene never occurred;
- unresolved Wednesday phase;
- another scene attempts to erase the obligation;
- future relationship mode already changed.

Availability reason:

```text
Thursday is the deadline created by Player's own M4 choice.
Marie does not manufacture a crisis; she reads whether the chosen action happened.
```

## Result variants

### Paid join-from-start

Writes:

```text
marie_real_plan_paid
active_reconnection_evidence
couple_boundary_named
```

### Paid precise arrival

Writes:

```text
marie_precise_arrival_paid
active_reconnection_evidence
couple_boundary_named
```

### Paid Thursday couple time

Writes:

```text
marie_thursday_time_paid
active_reconnection_evidence
couple_boundary_named
```

### Amended before deadline

Writes:

```text
marie_real_plan_amended
couple_boundary_named
```

The amendment must contain a new real action.

It is not automatically positive evidence.

### Failed honestly

Writes:

```text
marie_real_plan_failed
parallel_drift_evidence_soft
couple_boundary_named
```

Marie continues her evening.

She does not keep an indefinite invitation open.

## Choice rule

No new three-choice node is required when M4 already determined the action and the result is observable.

A short Player reply may exist only when it changes:

- whether failure is admitted;
- whether a real amendment is offered;
- whether Player lies.

V0.93 does not authorize a lie branch or hard secret.

The preferred source-pack outcome is consequence, not duplicate choice.

## Character agency

Marie may:

- be warm after payment;
- remain mixed after an amendment;
- shorten the conversation after failure;
- go out, eat, walk, or call Pauline;
- refuse a late abstract apology;
- remain desirable and active.

## Wave close contract

Closure requires:

```text
M4 obligation terminal
carry-over scene terminal or absent
social hub terminal
Nico scene terminal or explicitly deferred
no unowned SCHEDULED / DUE obligation
```

Recommended completion fact:

```text
named_boundaries_wave_complete
```

Relationship exit:

```text
Marie / Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
couple boundary = explicitly named through action
```

## Anti-patterns

Reject:

- a grand breakup speech;
- instant repair mode;
- Marie forgiving a missed action because Player phrases regret well;
- Marie waiting motionless;
- final score summary;
- route menu;
- hard-secret creation;
- adult-frame negotiation inside this wave.

---

# 8. Internal closure card

## Identity

```text
scene_id: named_boundaries_wave_close_01
working_title: Internal wave close
primary_function: guarded completion
primary_relationship: none
principal_character: none
```

This is not a visible narrative scene.

It must contain:

```text
no conversation
no Player choice
no notification
no day-log exposition
no visible closure card
no new route content
```

It may write only the validated completion fact after every closure condition passes.

It must remain idempotent.

A later runtime plan must define the exact pure closure predicate and test matrix.

---

# 9. Cross-card validation matrix

| Contract | Marie M4 | Mathilde | Sandra | Social hub | Nico N2 | Marie return |
|---|---:|---:|---:|---:|---:|---:|
| Marie remains active | yes | subtext | subtext | yes | consequence | yes |
| 3 choices max | 3 | 3 | 3 | 0 | 3 | 0 preferred |
| New adult permission | no | no | no | no | no | no |
| New required image | no | no | no | no | no | no |
| Hard secret | no | no | no | no | no | no |
| Route R2+ created | no | no | no | no | no | no |
| Concrete consequence | obligation | boundary | boundary | payment | boundary/risk | payment/failure |
| Can be absent | no | yes | yes | no | no | no |

---

# 10. Final scene-card rule

```text
A boundary scene is not a reward scene.

The character names what became real,
Player answers through an action or a limit,
and the story records what remains possible afterward.
```
