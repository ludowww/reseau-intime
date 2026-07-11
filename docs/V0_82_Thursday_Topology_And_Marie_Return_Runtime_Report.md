# V0.82 — Thursday Topology & Mandatory Marie Return — Runtime Report

> Second runtime slice of the modular post-J1 architecture.  
> Extends the active prototype from Wednesday night through Thursday night.  
> Friday, Pauline, Nico, R2 routes, hard secrets, and adult content remain out of scope.

## 1. Baseline

```text
Base version: V0.81
Base commit: ebb71aae0d92b92b1da0f10141aca5d9a70e7052
Branch: work/thursday-topology-marie-return-v0-82
```

Primary narrative sources:

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
```

Technical plan:

```text
docs/runtime/V0_82_THURSDAY_TOPOLOGY_IMPLEMENTATION_PLAN.md
```

## 2. Implemented chronology

```text
09:10 — Raphaëlle / ordinary work access
13:50 — Sandra / optional continuity echo
16:05 — Marie / event offer and M1
17:45, 17:55 or 18:20 — exactly one topology branch
22:10+ — mandatory consequence with Marie
```

The active runtime now exposes:

```text
Mardi
Mercredi
Jeudi
```

Friday remains absent.

## 3. Raphaëlle O3

`chapter_03_raphaelle_blue_folder.json` establishes Raphaëlle through normal UX/accessibility work.

R0 contains exactly three choices:

- accountable correction;
- dry humor followed by action;
- delay until after the client point.

Runtime writes only observable flags:

```text
raphaelle_work_accountable
raphaelle_work_playful
raphaelle_work_delayed
raphaelle_r1_established
```

No private image, creative-account access, diagnosis, refuge role, attraction state, or adult frame opens.

## 4. Sandra continuity echo

`chapter_03_sandra_continuity.json` unlocks silently after Raphaëlle.

It contains:

- a poste du matin;
- the returning SentryCore button;
- one guided reply;
- no new image;
- no promise;
- no route-stage increase.

It is optional and does not gate Marie's event offer.

## 5. M1 topology

`chapter_03_marie_event_offer.json` presents Marie's La Verrière vernissage and exactly three actions:

```text
opening_topology_join_marie
opening_topology_stay_home
opening_topology_work_then_join
```

The choice controls what Player does, not which woman he selects.

After M1, conditional unlock logic opens exactly one of:

```text
chapter_03_marie_event_joined
chapter_03_mathilde_home_charger
chapter_03_raphaelle_late_review
```

The other two remain unavailable for this event.

## 6. O5A — Join Marie

Communication mode:

```text
SAME_VENUE_LOGISTICS
```

Player and Marie exchange only short practical messages across a noisy, busy room.

MA0 records:

```text
marie_event_initiative
marie_event_playful_help
marie_event_distracted
```

Possible tendency flags:

```text
couple_reconnection_candidate
couple_presence_strained
```

The branch may display the authorized ordinary event image:

```text
marie_laverriere_setup_01
```

The emotional evaluation waits for O6 after physical separation.

## 7. O5B — Stay home

Communication mode:

```text
SEPARATE_ROOMS_PING
```

Mathilde independently remains home for the insurer/building follow-up and move fatigue.

MH0 records:

```text
mathilde_home_help
mathilde_home_playful_help
mathilde_home_distance
```

The helpful branches stop Messenger and continue through an `offline_beat` when Player enters the spare room.

No outfit, body image, gaze acknowledgement, sexual intention, or hidden route is introduced.

## 8. O5C — Finish work

Communication mode:

```text
WORK_CHAT
```

Raphaëlle asks for a real project decision and does not retain Player.

RW0 records:

```text
work_promise_kept
work_promise_amended
work_promise_missed
```

Player's promise to Marie remains his responsibility.

No personal Raphaëlle frame opens.

## 9. Mandatory O6 Marie return

Any completed O5 branch unlocks:

```text
chapter_03_marie_event_return
```

The unlock rule uses:

```text
after_any_conversation_completed
```

The single consequence file filters its messages and guided acknowledgements from the actual branch-quality flags.

Examples:

- initiative/playful attendance -> Marie values Player arriving before she must chase him;
- distracted attendance -> Marie notes the difference without declaring crisis;
- practical/helpful home presence -> Marie recognizes another form of participation;
- home distance -> the couple receives a softer drift consequence;
- promise kept/amended/missed -> Marie responds to the actual handling of the promise.

O6 offers no new topology and cannot be replaced by another route opportunity.

The couple remains:

```text
HABITUAL_WARMTH
```

Only reconnection/drift candidates are recorded.

## 10. Runtime foundation added

### PhonePrototypeV082

Adds narrowly:

- unlock `conditions`;
- `after_any_conversation_completed`;
- optional `notify: false`;
- condition-aware contact messages/choices;
- reuse of V0.81 time behavior.

### ConversationViewV082

Adds:

- conditional messages and choices;
- `unless_conditions` support;
- consequence segments without fake empty-choice hint;
- cumulative cross-day thread merging by source conversation + segment ID;
- preserved history while appending Thursday episodes;
- reuse of V0.81 semantic time/offline rendering.

The base phone and conversation scripts remain unchanged.

## 11. Active runtime data

New active index:

```text
game/data/conversations/chapter_03_modular_index.json
```

New conversations:

```text
chapter_03_raphaelle_blue_folder.json
chapter_03_sandra_continuity.json
chapter_03_marie_event_offer.json
chapter_03_marie_event_joined.json
chapter_03_mathilde_home_charger.json
chapter_03_raphaelle_late_review.json
chapter_03_marie_event_return.json
```

New visual bundle:

```text
game/data/visual_content/chapter_03_proofs.json
```

Legacy Chapter 3 remains on disk but is not loaded.

## 12. Tests

Added:

```text
tests/test_v082_thursday_static.py
```

Updated V0.81 tests to preserve Wednesday assertions through the V0.82 adapter inheritance chain.

Coverage includes:

- active Tuesday–Thursday indexes;
- exact Thursday moments/files;
- silent Sandra + notified Marie unlock;
- exact M1 topology flags;
- branch condition rules;
- mandatory O6 after any branch;
- three choices in each foreground node;
- conditional exclusivity of O6 variants;
- no automatic Player messages;
- cross-day thread merge hooks;
- authorized event visual;
- absence of Friday, Pauline, Nico, R2, NTR, and adult content.

## 13. Validation limitation

The GitHub connector environment cannot run the Python/Godot commands or manual prototype walkthrough.

No claim is made that execution checks passed here.

Before merge, run:

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest tests.test_v081_wednesday_static -v
python3 -m unittest tests.test_v082_thursday_static -v
python3 tools/player_choice_text_check.py game/data/conversations/chapter_03_*.json
python3 tools/player_presence_check.py game/data/conversations/chapter_03_*.json
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## 14. Manual acceptance walkthrough

1. Confirm only Tuesday, Wednesday, and Thursday are active.
2. Open Thursday: only Raphaëlle is initially pending at 09:10.
3. Complete R0: Sandra becomes available silently and Marie receives a 16:05 notification.
4. Open Marie and select one M1 topology.
5. Confirm exactly one corresponding O5 contact/episode unlocks.
6. Complete the selected O5 branch.
7. Confirm Marie O6 unlocks in every branch.
8. Confirm O6 text and optional guided reply match the exact quality flag.
9. Reopen Marie/Mathilde/Raphaëlle/Sandra and confirm prior-day history remains, with no duplicated segments.
10. Confirm Friday, Pauline, Nico, adult content, and old Chapter 3 are absent.

## 15. Explicit exclusions

V0.82 does not implement:

- Friday O7/O8;
- Pauline or Nico threads;
- public group-photo relay;
- route R2+;
- hard secrets;
- adult content;
- open-couple negotiation;
- NTR/cuckold logic;
- universal scheduler;
- save migration;
- legacy-file deletion.

## 16. Next step

After Product Owner validation and successful execution checks:

```text
V0.83 — Friday public traces and opening completion
```

## 17. Final rule

```text
Thursday opens one context, not three routes.
Whatever Player does in that context returns to Marie before the story moves on.
```
