# V0.79 — Act I Opening Windows Source Pack Report

> Documentation-only narrative source-pack report, including the temporal and communication-realism correction.  
> No runtime, narrative JSON, Godot scene, script, test, asset, or playable content is changed.

## 1. Scope

V0.79 converts the opening portion of the V0.78 modular architecture into concrete, reviewable post-J1 content.

It defines:

- the first post-J1 narrative windows;
- exact French line sources;
- a felt Tuesday–Friday chronology;
- believable smartphone communication modes;
- the water-damage entry of Mathilde into the household;
- ordinary access for Raphaëlle, Pauline, and Nico;
- restrained Sandra continuity;
- Marie's first topology-changing invitation;
- exactly three choices per foreground node;
- one foreground scene per selected topology;
- mandatory return to Marie;
- authorized visuals and their audiences;
- conceptual state writes;
- obligations, traces, conditions, cooldowns, mutation, and fallbacks;
- the exact end state of the opening band.

It does not:

- modify runtime;
- restore a fixed J2–J10 chronology;
- integrate old J2 JSON;
- activate adult routes;
- create hard secrets;
- create runtime variables;
- validate a large refactor.

## 2. Files added

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
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

The correction updates general entry points so temporal orientation and believable use of Messenger are not left as implicit style preferences.

## 4. Relationship to V0.78

```text
V0.78 = how the story moves
V0.79 = the first authored movement
Time/communication canon = when the movement happens and why it passes through a phone
```

The architecture remains modular.

Weekdays and time bands now make that modularity readable to the player.

## 5. Concrete chronology

J1's existing clues establish:

- La Verrière event on Thursday;
- Mathilde planning to inspect the installation `tomorrow`.

Current calendar:

```text
Tuesday evening
= J1 — Les choses qu'on remarque

Wednesday midday
= Mathilde emergency and shared-home decision

Wednesday late afternoon / evening
= Mathilde arrival and offline settling

Thursday morning
= Raphaëlle ordinary work access

Thursday early afternoon
= Sandra continuity echo if eligible

Thursday late afternoon
= Marie offers the event topology

Thursday evening
= one selected topology foreground

Thursday late evening / night
= mandatory return / consequence with Marie

Friday morning
= Pauline authorized public-photo relay

Friday afternoon
= Nico saved-seat follow-up

Friday late afternoon
= household breather
```

The exact displayed minute may vary inside approved ranges.

The weekday and time band are canon.

## 6. Communication-realism correction

Core rule:

```text
If two characters are in the same room
and can speak normally,
they do not conduct a full Messenger conversation.
```

Current communication modes:

- `REMOTE_ASYNC`;
- `TRACE_DELIVERY`;
- `SEPARATE_ROOMS_PING`;
- `SAME_VENUE_LOGISTICS`;
- `WORK_CHAT`;
- `OFFLINE_BEAT`;
- `AFTERGLOW_REMOTE`.

### Same room

Characters speak offline.

The interface may later show:

- a trace;
- a changed state;
- a short event card;
- a later message referring to what happened.

### Same home, separate rooms

A short practical ping is allowed.

When one character enters the room, the chat stops.

### Same busy venue

Short logistical messages are allowed across noise, guests, and work tasks.

A long emotional exchange moves to a later remote or offline consequence.

### Same workplace

Work chat requires separate workstations / rooms, hybrid work, or asynchronous file review.

If the characters sit together, the remainder occurs offline.

## 7. Scene-delivery audit

### O1 — Make room

```text
Wednesday midday
Marie at La Verrière; Player at work or in transit
REMOTE_ASYNC
```

### O2 — Mathilde arrives

```text
Wednesday early evening
Marie and Mathilde at home; Player still away
TRACE_DELIVERY + REMOTE_ASYNC
```

When Player returns, the move-in continues offline.

### O3 — Raphaëlle work

```text
Thursday morning
separate workstations / rooms
WORK_CHAT
```

### Sandra echo

```text
Thursday early afternoon
Sandra after a poste du matin; Player elsewhere
REMOTE_ASYNC
```

### O4 — Marie's invitation

```text
Thursday around 16h
Marie at La Verrière setup; Player elsewhere
REMOTE_ASYNC
```

### O5A — Join Marie

```text
Thursday evening
same venue, separated by noise and tasks
SAME_VENUE_LOGISTICS
```

Only short practical messages remain on the phone.

### O5B — Stay home

```text
Thursday evening
Player and Mathilde in separate rooms
SEPARATE_ROOMS_PING
```

When Player enters the spare room, help continues offline.

### O5C — Finish work

```text
Thursday late afternoon / evening
separate work positions
WORK_CHAT
```

Raphaëlle does not keep Player from Marie.

### O6 — Return to Marie

```text
Thursday late evening / night
AFTERGLOW_REMOTE if separated
OFFLINE_BEAT if together
```

The scene remains mandatory regardless of delivery mode.

### O7 — Pauline relay

```text
Friday morning
TRACE_DELIVERY + REMOTE_ASYNC
```

### O8 — Nico follow-up

```text
Friday afternoon
REMOTE_ASYNC
```

This respects Nico's late hospitality rhythm.

## 8. Mathilde household entry

Locked facts:

- real water-damage emergency;
- bedroom and part of bathroom unusable;
- temporary stay around ten to fifteen days;
- Marie offers the spare room / office;
- Player chooses participation quality, not whether emergency shelter exists;
- suitcase, garment bag, legal tote, shoes, and missing charger;
- practical arrival image taken openly by Marie;
- no canapé selfie;
- no deliberate seduction;
- no route above R1.

Core choice:

```text
proactive participation
playful but present
passive assent
```

## 9. Raphaëlle ordinary entry

Raphaëlle first appears through a concrete UX/accessibility correction.

The scene establishes:

- peer status;
- work competence;
- dry humor;
- accountable, joking-but-active, or delaying Player posture;
- no diagnosis of the couple;
- no refuge function;
- no personal image;
- no creative-account access.

A garment bag remains ordinary texture only.

## 10. Sandra continuity

Sandra receives only a conditional echo after a poste du matin.

The pack adds:

- no new image;
- no direct confession;
- no fixed new rendezvous;
- no pressure;
- no route-stage increase.

## 11. Marie's topology choice

The `petit événement jeudi` becomes a local illustration vernissage at La Verrière.

Marie states separate practical and emotional reasons for wanting Player.

Player chooses:

```text
A — join Marie early
B — stay at the shared home
C — finish a real work obligation and promise to join later
```

Core rule:

```text
The choice does not select a woman.
It selects what Player does.
```

## 12. Mandatory return to Marie

Every topology is followed by:

```text
marie_after_first_event_return_01
```

The return pays proactive presence, useful household participation, honest delay, distraction, or missed promise.

No fake undo choice is offered.

When Player and Marie are physically together, the consequence becomes an offline beat rather than an artificial chat.

The couple remains `HABITUAL_WARMTH` with only reconnection or drift candidates.

## 13. Pauline ordinary access

Pauline enters through an authorized group-photo set created with her remote shutter.

Locked rules:

- Friday-morning relay;
- authorized social/public image;
- Marie remains event owner;
- Bastien remains visible;
- no alternate crop;
- no one-view image;
- no reciprocal proof;
- no private compartment.

Pauline ends at R1 ordinary access.

## 14. Nico ordinary access

Nico enters through an event table / saved-seat gesture and ordinary male friendship.

Locked exclusions:

- no body comment;
- no domestic-access envy activation;
- no photo request;
- no alibi;
- no voyeur pact;
- no rivalry;
- no NTR/cuckold language.

Default follow-up is Friday afternoon rather than an implausible early morning after a late close.

Nico ends at R1 ordinary access.

## 15. Choice audit

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

## 16. Visual inventory

### Current

- `mathilde_arrival_room_01` — Wednesday evening, private ordinary household image;
- optional `raphaelle_blue_folder` — Thursday-morning work visual;
- `marie_laverriere_setup_01` — Thursday event image;
- `laverriere_public_group_photo_set_01` — Friday-morning authorized social/public set.

### Explicitly absent

- old Mathilde canapé selfie;
- deliberate Mathilde adult image;
- second Sandra photo;
- Raphaëlle costume or personal image;
- Pauline private alternate;
- Nico private image;
- hidden capture;
- sexual video.

## 17. Route and adult ceiling

V0.79 remains inside:

```text
Act I opening
R0–R1
soft pre-R2 signals only
```

No adult frame, route lock, hard secret, or unauthorized forwarding exists.

## 18. Pack-end state

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

## 19. Deprecated old assumptions

V0.79 supersedes:

- fixed linear J2 order;
- Player physically absent until J3;
- four mandatory J2 visuals;
- Raphaëlle badge image as required entry;
- Mathilde canapé selfie;
- Pauline/Nico exclusion by day number;
- J3 as mandatory first home return;
- long Messenger exchanges between co-present people;
- opening content with no readable morning/evening progression.

## 20. General-document reconciliation

The pass updates:

- reading order;
- narrative status;
- current-character doorway;
- global story state;
- continuity matrix;
- README;
- roadmap;
- PR description.

The new temporal and communication documents become required sources for V0.80.

## 21. Runtime impact

None.

V0.79 changes no Godot scene, GDScript, narrative JSON, route variable, conversation index, asset, test, or current playable line.

## 22. Next step

```text
V0.80 — First Modular Runtime Integration Plan
```

V0.80 must inspect current runtime and document:

- mapping of Tuesday–Friday time anchors;
- day / time separators and representative timestamps;
- communication-mode handling;
- transitions to `OFFLINE_BEAT` at co-presence;
- existing thread and day structures;
- mapping of O0–O8;
- minimal state requirements;
- old J2 replacement/deprecation strategy;
- visual placeholder mapping;
- test, validation, rollback, and small PR boundary.

V0.80 remains documentation only.

## 23. Product Owner decisions to review

1. J1 is felt as Tuesday evening; the opening runs Wednesday–Friday.
2. The player receives day/time cues rather than an abstract scene sequence.
3. Co-present characters do not conduct long artificial chats.
4. Same-room events can become offline beats with later smartphone consequences.
5. Player cannot veto emergency shelter; he chooses participation quality.
6. Mathilde's canapé selfie is removed.
7. Raphaëlle enters through ordinary peer work.
8. Sandra receives only a restrained conditional echo.
9. Marie's vernissage creates the three-way topology.
10. Every topology returns to Marie.
11. Pauline and Nico remain R1 ordinary access only.
12. The pack ends with no hard secret, adult frame, or route above R1.

## 24. Final rule

```text
V0.79 gives the opening a real week and a believable phone.

Tuesday establishes warmth.
Wednesday disrupts the home.
Thursday creates movement.
Friday preserves the residue.

When characters are together, they speak.
When distance, logistics, traces, or aftermath matter, the phone records it.
```
