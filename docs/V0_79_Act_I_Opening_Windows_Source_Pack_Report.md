# V0.79 — Act I Opening Windows Source Pack Report

> Documentation-only narrative source-pack report.  
> No runtime, narrative JSON, Godot scene, script, test, asset, or playable content is changed.

## 1. Scope

V0.79 converts the opening portion of the V0.78 modular architecture into concrete, reviewable post-J1 content.

It defines:

- the first relative narrative windows after J1;
- exact French line sources;
- the water-damage entry of Mathilde into the household;
- ordinary access for Raphaëlle, Pauline, and Nico;
- restrained Sandra continuity;
- Marie's first topology-changing invitation;
- exactly three choices per foreground node;
- one foreground scene per selected topology;
- mandatory return to Marie;
- authorized opening visuals and their audiences;
- conceptual state writes;
- obligations, traces, conditions, cooldowns, mutation, and fallbacks;
- the exact end state of the opening band.

It does not:

- modify runtime;
- write a fixed calendar-labeled J2;
- integrate old J2 JSON;
- activate adult routes;
- create hard secrets;
- create runtime variables;
- validate a large refactor.

## 2. Files added

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/V0_79_Act_I_Opening_Windows_Source_Pack_Report.md
```

## 3. Files updated

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/CHARACTERS_CANON_CURRENT.md
docs/story_state/GLOBAL_STORY_STATE.md
docs/story_state/CHARACTER_CONTINUITY_MATRIX.md
README.md
ROADMAP.md
```

The README and roadmap were updated because they still described the old fixed J2, mandatory canapé selfie, and J3–J5 linear implementation sequence as current.

## 4. Relationship to V0.78

V0.78 defines the architecture:

```text
fixed spine
+ topology choices
+ modular windows
+ scene pools
+ persistent obligations
+ consequences returning to the couple
```

V0.79 defines the first concrete content inside that architecture.

```text
V0.78 = how the story moves
V0.79 = the first authored movement
```

## 5. Opening duration and order

The pack covers roughly:

```text
3–5 in-game days
```

It deliberately avoids a mandatory `J2` label.

Relative order:

```text
O0 — J1 carry-over
O1 — Marie / make room
O2 — Mathilde arrival
O3 — Raphaëlle ordinary work + Sandra continuity echo
O4 — Marie offers movement
O5 — selected topology foreground
O6 — mandatory return to Marie
O7 — Pauline public group-photo relay
O8 — Nico saved-seat follow-up + household breather
```

O7 and O8 may invert according to natural message timing.

## 6. Mathilde household entry

Mathilde's current canon is implemented through a real water-damage emergency.

Locked facts:

- bedroom and part of bathroom unusable;
- temporary stay of around ten to fifteen days;
- Marie offers the spare room / office;
- Player chooses the quality of participation, not whether emergency shelter exists;
- Mathilde arrives with suitcase, garment bag, legal tote, too many shoes, and a missing charger;
- arrival visual is practical and openly taken by Marie;
- no canapé selfie;
- no deliberate seduction;
- no route state above R1.

Core choice:

```text
proactive participation
playful but present
passive assent
```

This records how Player makes space inside shared life.

## 7. Raphaëlle ordinary entry

Raphaëlle first appears through a concrete UX/accessibility work correction.

The scene establishes:

- peer status;
- work competence;
- dry humor;
- Player's ability to accept, joke-and-fix, or delay a normal correction;
- no diagnosis of the couple;
- no refuge function;
- no personal image;
- no creative-account access.

A garment bag may appear later in the work topology as ordinary creative-life texture only.

## 8. Sandra continuity

Sandra remains present without stealing the opening.

The conditional echo uses:

- a poste du matin;
- the returning SentryCore button;
- the old J1 photo only when the J1 branch earned the mention.

The pack adds:

- no new Sandra image;
- no direct confession;
- no new fixed Thursday rendezvous;
- no pressure;
- no route-stage increase.

Sandra may remain active or cool naturally.

## 9. Marie's first topology choice

The `petit événement jeudi` referenced in J1 becomes a small local illustration vernissage at La Verrière.

Marie states two separate reasons:

```text
I need two arms at 18h.
I want you to come.
```

Player chooses:

### A — Join Marie early

Opens:

```text
PLAYER_WITH_MARIE_SOCIAL
```

Foreground:

- La Verrière setup;
- quality of active participation;
- Marie socially alive;
- ordinary Pauline and Nico echoes.

### B — Stay at the shared home

Opens:

```text
HOME_WITHOUT_MARIE
```

Foreground:

- practical Mathilde charger / spare-room scene;
- Mathilde independently stays for building / insurance follow-up and fatigue;
- no sexualized reward for declining Marie;
- Marie continues the event and sends a social echo.

### C — Finish a real work obligation and promise to join later

Opens:

```text
PLAYER_WORK -> MARIE_RETURN_DUE
```

Foreground:

- Raphaëlle work decision;
- promise kept, honestly amended, or missed;
- Raphaëlle does not retain Player or become the excuse.

Core rule:

```text
The choice does not select a woman.
It selects what Player does.
```

## 10. Mandatory return to Marie

Every O5 topology is followed by:

```text
marie_after_first_event_return_01
```

The return pays:

- proactive presence;
- playful presence;
- distracted presence;
- useful household participation;
- distance at home;
- promise kept;
- promise amended honestly;
- promise missed.

No new choice is offered.

Reason:

```text
The consequence must remember the prior choice,
not let Player undo it through a nicer reply.
```

The couple remains in `HABITUAL_WARMTH`.

Only reconnection or drift candidates are written.

## 11. Pauline ordinary access

Pauline enters through a public group-photo set created with her remote shutter.

The image set may include:

- Marie;
- Pauline;
- Bastien;
- Nico;
- Élodie;
- Player according to attendance.

Locked rules:

- authorized social/public image;
- Marie remains event owner;
- Bastien remains visible;
- Player selects practically, jokes, or defers to Marie;
- no alternate private crop;
- no one-view image;
- no reciprocal proof;
- no private compartment.

Pauline ends at R1 ordinary social access.

## 12. Nico ordinary access

Nico enters through:

- an event table / saved-seat gesture;
- ordinary male friendship;
- teasing about attendance or lateness;
- the possibility of asking how Marie was rather than commenting sexually.

He may learn that Mathilde is staying, but only through a credible source.

Locked exclusions:

- no body comment;
- no domestic-access envy activation;
- no photo request;
- no alibi;
- no voyeur pact;
- no rivalry;
- no NTR/cuckold language.

Nico ends at R1 ordinary access.

## 13. Exact choice audit

All foreground nodes use exactly three choices.

| Node | Decision axis | A | B | C |
|---|---|---|---|---|
| M0 | making room | proactive | playful-present | passive assent |
| MT0 | welcoming Mathilde | practical | teasing-helpful | distant |
| R0 | work correction | accountable | humor + action | delay |
| M1 | event topology | join early | stay home | work then promise |
| MA0 | event participation | initiative | joke + help | distracted |
| MH0 | domestic posture | help | playful help | distance |
| RW0 | work vs promise | decide/leave | honest delay | vague absorption |
| P0 | public-photo selection | practical | dry joke | defer to Marie |
| N0 | Nico friendship | honest | playful | ask about Marie |

No four-choice exception exists.

## 14. Visual inventory

### Required or conditional current visuals

#### `mathilde_arrival_room_01`

- private household image;
- taken openly by Marie;
- practical clutter;
- no erotic crop;
- no forwarding.

#### `raphaelle_blue_folder`

- optional work visual;
- no personal or body focus.

#### `marie_laverriere_setup_01`

- event image;
- Marie active in her life;
- required in joined branch or usable as social echo elsewhere.

#### `laverriere_public_group_photo_set_01`

- authorized social/public set;
- origin and audience known;
- no adult function.

### Explicitly absent

- old Mathilde canapé selfie;
- deliberate Mathilde adult image;
- second Sandra photo;
- Raphaëlle costume or personal image;
- Pauline private alternate;
- Nico private image;
- hidden capture;
- sexual video.

## 15. Route and adult ceiling

V0.79 remains inside:

```text
Act I opening
R0–R1
soft pre-R2 signals only
```

No adult frame exists.

No route lock exists.

No hard secret exists.

No image has been forwarded outside its intended audience.

No character has skipped ordinary characterization.

## 16. Pack-end state

```text
Mathilde stay = active
Marie event = completed
first topology choice = remembered
public group-photo trace = exists
Raphaëlle R1 = established
Pauline R1 = established
Nico R1 = established
Sandra trace = active or cooled
hard secrets = none
adult frames = none
relationship frame = ASSUMED_EXCLUSIVE
couple mode = HABITUAL_WARMTH
```

Possible future tendencies:

- `ACTIVE_RECONNECTION` candidate;
- `PARALLEL_DRIFT` candidate.

One event cannot finalize the transition.

## 17. Deprecated old J2 assumptions

V0.79 supersedes as current narrative requirements:

- fixed linear J2 order;
- Player being physically absent until J3;
- exactly four mandatory J2 visuals;
- Raphaëlle badge visual as mandatory entry;
- Mathilde canapé selfie;
- Pauline/Nico exclusion by day number;
- one fixed thread sequence;
- J3 as the mandatory first physical home return.

Old J2 runtime remains available for technical inspection during V0.80.

## 18. General-document reconciliation

The pass updates:

- reading order;
- narrative status;
- current-character doorway;
- global story state;
- continuity matrix;
- README;
- roadmap.

This ensures no top-level entry point still recommends the old linear J2/J3–J5 implementation path.

## 19. Runtime impact

None.

V0.79 changes no:

- Godot scene;
- GDScript;
- narrative JSON;
- route variable;
- conversation index;
- visual asset;
- test;
- playable line in the current prototype.

## 20. Next step

```text
V0.80 — First Modular Runtime Integration Plan
```

V0.80 must inspect current runtime and document:

- existing thread and day structures;
- mapping of O0–O8;
- minimal state requirements;
- old J2 replacement/deprecation strategy;
- visual placeholder mapping;
- one-thread-per-character continuity;
- test and validation plan;
- rollback;
- small PR boundary.

V0.80 remains documentation only.

A later V0.81 may implement the first small vertical slice after V0.80 Product Owner validation.

## 21. Product Owner decisions to review

1. The opening is a three-to-five-day relative band, not a fixed J2.
2. Player cannot veto emergency shelter; he chooses participation quality.
3. Mathilde's old canapé selfie is removed from current opening canon.
4. Raphaëlle enters through ordinary peer work.
5. Sandra receives only a restrained conditional echo.
6. Marie's vernissage creates the first three-way topology.
7. Staying home opens a practical Mathilde scene, not a sexual reward.
8. Work opens a Raphaëlle obligation scene, not an emotional refuge.
9. Every topology returns to Marie before Pauline/Nico foreground access.
10. Pauline and Nico remain R1 ordinary access only.
11. The public group photo has explicit origin and audience.
12. The pack ends with no hard secret, adult frame, or route above R1.

## 22. Final rule

```text
V0.79 does not begin by asking who Player wants.

It asks whether he makes room,
joins Marie,
keeps a promise,
and treats each new person as a real life before a route.
```
