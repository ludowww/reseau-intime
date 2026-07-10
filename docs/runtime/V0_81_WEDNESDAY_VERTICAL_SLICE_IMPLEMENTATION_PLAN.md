# V0.81 — Tuesday Handoff + Wednesday Vertical Slice Implementation Plan

> Proposed first runtime PR after V0.80 validation.  
> This document is an implementation specification for Hermes/Codex.  
> It does not itself modify runtime, JSON, GDScript, tests, assets, or playable content.

## 1. Product goal

Implement the smallest coherent part of V0.79:

```text
Tuesday J1 handoff correction
-> Wednesday O1 Marie / make room
-> Wednesday O2 Marie arrival trace
-> Wednesday O2 Mathilde arrival
-> offline settling beat
```

The slice must prove four things in runtime:

1. the story can move from one weekday to the next;
2. several episodes can continue inside persistent contact threads;
3. a practical offline action can be represented without fake co-present chat;
4. Player choices can create remembered flags without activating a route.

It must not implement Thursday topology or Friday residue.

---

## 2. Branch and PR boundary

Recommended branch:

```text
work/wednesday-modular-runtime-slice-v0-81
```

Recommended PR title:

```text
runtime: integrate V0.81 Tuesday handoff and Wednesday opening
```

PR type:

```text
small runtime/data vertical slice
```

Expected file count:

```text
approximately 12–16 files
```

The PR may be split further if implementation reveals a hard technical constraint, but it must not expand into Thursday O3–O6.

---

## 3. Required canon sources

Read in this order:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
```

Character sources:

```text
docs/canon/characters/MARIE_CANON_FULL.md
docs/canon/characters/MATHILDE_CANON_FULL.md
docs/canon/characters/PLAYER_CANON_FULL.md
```

Choice source:

```text
docs/canon/CHOICE_DESIGN_CANON.md
```

---

## 4. Runtime files to inspect before editing

```text
game/data/conversations/chapter_01_index.json
game/data/conversations/chapter_01_marie.json
game/data/visual_content/chapter_01_proofs.json
game/data/conversations/chapter_02_index.json
game/data/conversations/chapter_02_*.json
game/data/visual_content/placeholders.json
game/data/state/initial_state.json
game/scripts/core/DataLoader.gd
game/scripts/core/GameState.gd
game/scripts/core/EffectApplier.gd
game/scripts/ui/PhonePrototype.gd
game/scripts/ui/ConversationView.gd
tools/validate_game_data.py
tests/test_godot_prototype_static.py
```

Inspect actual repository state before applying this plan. Do not assume line numbers remain unchanged.

---

# 5. Exact narrative scope

## 5.1 Tuesday J1 handoff correction

Current runtime contradiction to remove:

- Mathilde's bags already in the entrance;
- sports shoes, sport bag, and racket;
- wording suggesting she is already installed;
- `j1_mathilde_bag_domestic_trace` as an unlocked J1 image.

Target J1 handoff:

```text
Mathilde remains indirect only.
She may plan to inspect the La Verrière installation on Wednesday.
She is not yet staying in the apartment.
```

Use the validated V0.69 indirect seed if a Mathilde mention is retained:

```text
Marie : Mathilde veut passer voir l'installation demain.
Marie : Enfin elle dit « voir l'installation ».
Marie : Je pense surtout qu'elle veut juger l'éclairage.
```

Keep:

- Marie + Sandra as the only active J1 threads;
- Tuesday evening timing;
- no active Mathilde thread;
- no route lock;
- J1 final return to Marie.

Do not perform a broad J1 rewrite in V0.81.

The correction is limited to the handoff required by Wednesday continuity.

## 5.2 Wednesday O1

Exact content source:

```text
marie_mathilde_emergency_make_room_01
```

Time:

```text
Wednesday — 12:05–12:35
```

Communication:

```text
REMOTE_ASYNC
Marie at La Verrière or between tasks
Player at work or in transit
Mathilde at damaged apartment
```

Choice node:

```text
M0
```

Three choices:

- proactive participation;
- playful but present;
- passive assent.

## 5.3 Wednesday O2 Marie arrival trace

Exact content source:

```text
Marie thread arrival visual and household update
```

Time:

```text
Wednesday — approximately 18:15–18:22
```

Communication:

```text
TRACE_DELIVERY + REMOTE_ASYNC
Marie and Mathilde at apartment
Player still commuting or completing the practical errand
```

This episode has no fake choice.

It unlocks Mathilde's direct thread.

## 5.4 Wednesday O2 Mathilde arrival

Exact content source:

```text
mathilde_arrival_too_much_luggage_01
```

Time:

```text
Wednesday — approximately 18:22–19:15
```

Choice node:

```text
MT0
```

Three choices:

- practical welcome;
- teasing welcome;
- distant welcome.

After Player returns:

```text
messaging stops
-> boxes / bedding / room logistics continue offline
```

Represent that transition with a semantic `offline_beat` item.

---

# 6. Target active data structure

## 6.1 Active chapter indexes

For V0.81, `DataLoader.CHAPTER_INDEX_PATHS` should actively load only:

```text
res://data/conversations/chapter_01_index.json
res://data/conversations/chapter_02_index.json
```

Do not delete old Chapter 3+ files.

They remain repository history / technical material but are not presented as current continuation.

## 6.2 Active visual bundles

Load:

```text
res://data/visual_content/placeholders.json
res://data/visual_content/chapter_01_proofs.json
res://data/visual_content/chapter_02_proofs.json
```

Do not load old Chapter 4+ proof bundles in the canonical V0.81 slice.

They remain on disk for later reconciliation.

## 6.3 Chapter 1 index metadata

Add or normalize:

```json
{
  "calendar_label": "Mardi",
  "display_label": "Mardi — Les choses qu'on remarque",
  "day_start_time": "18:12",
  "day_end_time": "22:57"
}
```

Keep numeric fields:

```json
"chapter": 1,
"day": 1
```

for compatibility with current loader/context code.

## 6.4 Chapter 2 replacement index

Rewrite active `chapter_02_index.json` around Wednesday only.

Recommended top-level metadata:

```json
{
  "id": "chapter_02_index",
  "chapter": 2,
  "day": 2,
  "calendar_label": "Mercredi",
  "display_label": "Mercredi — Faire de la place",
  "title": "Mercredi — Faire de la place",
  "description": "Mathilde doit quitter temporairement son appartement. Marie et Player font de la place avant son arrivée.",
  "design_goal": "Valider le premier passage modulaire mardi -> mercredi, les fils persistants, les choix M0/MT0 et un offline beat sans activer de route."
}
```

Recommended `moment_flow`:

```json
[
  {
    "moment_label": "midi",
    "time_label": "12:10",
    "transition_text": "Mercredi midi — Marie appelle entre deux tâches après l'urgence de Mathilde.",
    "conversation_ids": ["chapter_02_marie_make_room"]
  },
  {
    "moment_label": "fin de journée",
    "time_label": "18:18",
    "transition_text": "Mercredi fin de journée — Mathilde arrive pendant que Player est encore en trajet.",
    "conversation_ids": ["chapter_02_marie_arrival_trace"]
  },
  {
    "moment_label": "soir",
    "time_label": "18:22",
    "transition_text": "Mercredi soir — Mathilde ouvre son fil avant que Player rentre.",
    "conversation_ids": ["chapter_02_mathilde_arrival"]
  }
]
```

Recommended conversation files:

```text
res://data/conversations/chapter_02_marie_make_room.json
res://data/conversations/chapter_02_marie_arrival_trace.json
res://data/conversations/chapter_02_mathilde_arrival.json
```

Recommended availability:

```json
{
  "initial_conversation_ids": [
    "chapter_02_marie_make_room"
  ],
  "locked_conversation_ids": [
    "chapter_02_marie_arrival_trace",
    "chapter_02_mathilde_arrival"
  ],
  "unlocks": {
    "chapter_02_marie_arrival_trace": {
      "after_conversation_completed": "chapter_02_marie_make_room",
      "time_label": "18:18",
      "pending": true,
      "notification": {
        "title": "Marie",
        "body": "Le bureau n'est plus un bureau."
      }
    },
    "chapter_02_mathilde_arrival": {
      "after_conversation_completed": "chapter_02_marie_arrival_trace",
      "time_label": "18:22",
      "pending": true,
      "notification": {
        "title": "Mathilde",
        "body": "Je tiens à préciser que la photo est à charge."
      }
    }
  }
}
```

No conditional branch unlock is required in V0.81.

---

# 7. Target conversation files

## 7.1 `chapter_02_marie_make_room.json`

Thread:

```json
{
  "id": "thread_marie_private",
  "type": "private",
  "participants": ["ludo", "marie"],
  "display_name": "Marie",
  "profile_content_id": "profile_marie_placeholder"
}
```

Required:

- exact O1 lines from V0.79;
- one segment with M0;
- three choices only;
- Player line contained only in the selected choice bubble;
- no Player sender in `messages` or `next_messages`;
- unique IDs;
- Wednesday time labels in approved range.

Recommended flags:

### M0A

```json
"sets_flags": [
  "opening_make_room_proactive"
]
```

### M0B

```json
"sets_flags": [
  "opening_make_room_playful"
]
```

### M0C

```json
"sets_flags": [
  "opening_make_room_passive"
]
```

No numeric effects.

## 7.2 `chapter_02_marie_arrival_trace.json`

Same Marie thread.

Required content:

- optional `time_separator` presentation item:
  - `MERCREDI — FIN DE JOURNÉE`;
- Marie's arrival lines;
- `mathilde_arrival_room_01` content reference;
- no choice;
- no route effect;
- completion unlocks Mathilde.

The photo must be described as openly taken with Mathilde's knowledge.

## 7.3 `chapter_02_mathilde_arrival.json`

Thread:

```json
{
  "id": "thread_mathilde_private",
  "type": "private",
  "participants": ["ludo", "mathilde"],
  "display_name": "Mathilde",
  "profile_content_id": "profile_mathilde_placeholder"
}
```

Required:

- exact V0.79 arrival lines;
- one MT0 choice node;
- three choices only;
- choice-specific Mathilde follow-up;
- common offline settling transition;
- no sexual language;
- no image sent by Mathilde;
- no route effect above ordinary access.

Recommended flags:

### MT0A

```json
"sets_flags": [
  "mathilde_arrival_practical",
  "mathilde_stay_active",
  "opening_wednesday_complete"
]
```

### MT0B

```json
"sets_flags": [
  "mathilde_arrival_playful",
  "mathilde_stay_active",
  "opening_wednesday_complete"
]
```

### MT0C

```json
"sets_flags": [
  "mathilde_arrival_distant",
  "mathilde_stay_active",
  "opening_wednesday_complete"
]
```

Recommended authored item in each choice's `next_items` after the character reply:

```json
{
  "id": "offline_chapter_02_mathilde_settling",
  "presentation": "offline_beat",
  "time_label": "19:15",
  "text": "Player rentre. Les derniers cartons, le couchage et les règles du foyer se règlent face à face."
}
```

The exact sentence may be lightly adjusted for tone, but it must not narrate sexual tension or a full unseen emotional scene.

---

# 8. Visual bundle

Create:

```text
game/data/visual_content/chapter_02_proofs.json
```

Recommended item:

```json
{
  "id": "mathilde_arrival_room_01",
  "character": "mathilde",
  "tier": 0,
  "type": "photo",
  "source_app": "messages",
  "asset_path": "res://assets/placeholders/mathilde_arrival_room_01.png",
  "context": "Photo pratique de la chambre d'appoint en cours d'installation : valise ouverte, housse, tote bag et chaussures. Mathilde sait que Marie prend la photo pour Player.",
  "tags": [
    "mathilde",
    "arrival",
    "spare_room",
    "household",
    "ordinary",
    "wednesday"
  ],
  "is_proof": false,
  "risk_level": 0,
  "can_delete": true,
  "can_capture": true,
  "can_set_as_wallpaper": false,
  "can_be_discovered_by": [
    "marie",
    "mathilde"
  ]
}
```

No binary image asset is required in V0.81 because the current prototype renders metadata placeholder cards.

Do not reference:

```text
mathilde_j2_couch_innocent_selfie_placeholder
mathilde_j2_arrival_marie_placeholder
j1_mathilde_bag_domestic_trace
```

from active J1/J2 conversations after the patch.

---

# 9. Minimal UI changes

## 9.1 Data-driven day labels

Add index helpers rather than replacing numeric day context.

Recommended `DataLoader.gd` helpers:

```text
get_day_display_label(day_value)
get_day_calendar_label(day_value)
get_day_start_time(day_value)
```

Fallback behavior:

```text
missing display_label -> Jour N
missing calendar_label -> Jour N
missing day_start_time -> current fallback
```

`PhonePrototype._format_day_label` should use the index display label.

## 9.2 Dynamic status-bar time

Current hardcoded `09:41` must become a stored label.

Recommended approach:

- keep a `status_time_label: Label` reference;
- initialize from the selected day's `day_start_time`;
- update to the opened conversation's latest currently available moment time;
- update to an unlock rule's `time_label` when a new later episode appears;
- never show a future locked episode's time.

No live clock timer is required.

## 9.3 Available-episode metadata only

Current moment metadata aggregation includes all moments for a persistent thread, even when later episodes remain locked.

Fix the metadata calculation so it includes only episode IDs currently available for the day.

Expected behavior:

```text
Before Marie O1 completes:
Marie card shows 12:10, not 18:18.

After Marie arrival trace unlocks:
Marie card may show 18:18.
```

## 9.4 Semantic presentation items

Extend `ConversationView.gd` with authored presentation handling.

Minimum supported values:

```text
time_separator
offline_beat
```

Recommended input shape:

```json
{
  "presentation": "offline_beat",
  "time_label": "19:15",
  "text": "..."
}
```

Rendering:

- centered card/note;
- no sender bubble;
- no typing indicator;
- time visible when supplied;
- stored and restored in conversation history;
- visually distinct from debug notes.

Do not expose raw `[debug item]` output for authored beats.

---

# 10. J1 compatibility patch details

## 10.1 `chapter_01_marie.json`

Remove or replace the messages that currently say:

- Mathilde's bags are in the entrance;
- her shoes are near the biscuits;
- she appears already installed.

Remove the active `content_id` reference:

```text
j1_mathilde_bag_domestic_trace
```

Insert the V0.69 indirect installation seed in the La Verrière-color portion or omit Mathilde entirely from J1 if placement would require a broader rewrite.

Preferred seed:

```text
Marie : Mathilde veut passer voir l'installation demain.
Marie : Enfin elle dit « voir l'installation ».
Marie : Je pense surtout qu'elle veut juger l'éclairage.
```

Do not add an active Mathilde thread.

## 10.2 `chapter_01_proofs.json`

Remove `j1_mathilde_bag_domestic_trace` from the active J1 bundle.

The active J1 visual list becomes:

```text
j1_marie_kitchen_soft
j1_sandra_lunch_memory_soft
```

A wider J1 visual/text reconciliation remains out of scope.

## 10.3 `chapter_01_index.json`

Update:

- title/display metadata to Tuesday;
- end-of-day knowledge so Mathilde is indirect through an installation visit, not bags already installed;
- debug expected visual count from three to two;
- any old sport/racket wording.

Keep Marie + Sandra as the only active threads.

---

# 11. State strategy

Use flags only in V0.81.

Do not add numeric effects for:

- desire;
- attachment;
- route scores;
- jealousy;
- couple mode.

Do not set:

```text
dominant_route
secondary_route
relationship_mode
threat
```

The flags record observable past actions, not hidden moral scores.

Recommended active flags:

```text
opening_make_room_proactive
opening_make_room_playful
opening_make_room_passive
mathilde_arrival_practical
mathilde_arrival_playful
mathilde_arrival_distant
mathilde_stay_active
opening_wednesday_complete
```

No condition evaluator is required for this sequential slice.

---

# 12. Legacy runtime policy

Keep old Chapter 3+ files on disk.

Do not load them in `DataLoader.CHAPTER_INDEX_PATHS` during V0.81.

Keep old Chapter 2 conversation files on disk if deletion would make the PR noisy.

They must no longer be referenced by the active Chapter 2 index.

Document in the PR summary:

```text
Legacy files retained for rollback/history but inactive in the canonical loader.
```

Do not edit old J3+ dialogue in V0.81.

---

# 13. Tests to update or add

Update narrowly in:

```text
tests/test_godot_prototype_static.py
```

## 13.1 Loader scope test

Assert active index paths are exactly:

```text
chapter_01_index.json
chapter_02_index.json
```

Assert active visual bundles include Chapter 1 and Chapter 2.

Assert Chapter 3+ indexes remain present on disk but are not active loader paths.

## 13.2 Day-label and clock test

Replace assertions for:

```text
integer-only Jour N labels
hardcoded 09:41
```

with assertions for:

- `display_label` / `calendar_label` fallback;
- stored status-time label;
- data-driven update method;
- Tuesday and Wednesday metadata.

## 13.3 Wednesday index test

Assert:

- display label is Wednesday;
- exact three active conversation files;
- moment times `12:10`, `18:18`, `18:22`;
- sequential unlock chain;
- no Pauline, Nico, Raphaëlle, Sandra foreground in active Wednesday index;
- no couch/selfie visual reference.

## 13.4 J1 handoff test

Assert active J1 data does not contain:

```text
j1_mathilde_bag_domestic_trace
raquette
sac de sport
baskets traînent
s'est installée
```

Assert no active Mathilde conversation in J1.

## 13.5 Choice-shape test

For the three active Wednesday episodes:

- Player lines appear only as choices;
- no choice node exceeds three choices;
- M0 and MT0 each have exactly three posture choices;
- no extra Player bubble in `next_messages`;
- all branch flags are known through creation.

## 13.6 Offline-beat rendering test

Assert:

- `ConversationView.gd` recognizes `offline_beat`;
- no typing indicator is shown for it;
- it uses a centered authored renderer;
- it is preserved in history;
- authored items do not fall into `[debug item]` output.

## 13.7 Visual test

Assert:

- `mathilde_arrival_room_01` exists in Chapter 2 bundle;
- it is non-proof and low risk;
- active Wednesday conversations reference it exactly once;
- deprecated couch visual is not referenced by active data.

## 13.8 Existing legacy tests

Do not rewrite all old Chapter 3/4 content tests unless they fail solely because the loader no longer activates those indexes.

The files may still be statically inspected as legacy artifacts.

---

# 14. Validation commands

Run from repository root:

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 tools/player_choice_text_check.py
python3 tools/player_presence_check.py
python3 tools/simulate_route_paths.py
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Notes:

- `simulate_route_paths.py` remains a legacy regression probe, not current modular route truth;
- it must not be expanded to model V0.79 in this PR;
- if Godot is unavailable in the execution environment, report that honestly and keep all static validation results.

---

# 15. Manual acceptance walkthrough

## 15.1 Tuesday

- only Tuesday/J1 current threads are active;
- Mathilde is not shown as installed;
- no bag/racket J1 image appears;
- day label reads Tuesday.

## 15.2 Select Wednesday

- status time begins around 12:10;
- only Marie is pending;
- O1 displays the water-damage emergency;
- M0 offers exactly three choices;
- selected choice produces one Player bubble and Marie's correct follow-up.

## 15.3 Complete O1

- Marie thread receives a new pending episode at approximately 18:18;
- status/card time changes from midday to end of day;
- Mathilde is still locked.

## 15.4 Open Marie arrival trace

- time separator or transition makes the time jump visible;
- `mathilde_arrival_room_01` appears once;
- no couch image appears;
- completion unlocks Mathilde.

## 15.5 Open Mathilde

- MT0 offers exactly three choices;
- no sexual wording;
- selected reply is shown once;
- `offline_beat` appears centered at approximately 19:15;
- no sender bubble pretends to narrate the face-to-face settling;
- `mathilde_stay_active` and `opening_wednesday_complete` are set.

## 15.6 Navigation

- only Tuesday and Wednesday are selectable as current story days;
- no old J3+ button appears;
- persistent Marie history includes Tuesday and Wednesday episodes correctly;
- Mathilde has one visible direct thread.

---

# 16. Rollback plan

The V0.81 PR should be squash-mergeable and reversible as one commit.

Rollback procedure:

1. revert the V0.81 squash commit;
2. active loader returns to prior indexes;
3. old Chapter 2 files were retained on disk, so no recovery migration is required;
4. no save migration exists because the prototype resets state and V0.81 adds flags only;
5. no binary asset rollback is needed.

Do not delete legacy files in V0.81 specifically to keep rollback simple.

---

# 17. Explicit exclusions

V0.81 must not implement:

- Thursday Raphaëlle O3 beyond the existing Wednesday slice;
- Sandra O3 echo;
- Marie O4 event invitation;
- topology branch selection M1;
- condition-aware unlocks;
- O5A/O5B/O5C;
- O6 return to Marie;
- Pauline O7;
- Nico O8;
- route stages R2+;
- adult images;
- hard secrets;
- couple-mode state machine;
- save migration;
- universal scheduler;
- procedural dialogue;
- deletion of all legacy runtime data.

---

# 18. Hermes/Codex execution prompt

```text
Repository: ludowww/reseau-intime
Task: V0.81 — Tuesday handoff + Wednesday modular runtime vertical slice

Start from the current main after V0.80 merge.
Create branch:
work/wednesday-modular-runtime-slice-v0-81

Read first:
- docs/canon/DOCUMENTATION_READING_ORDER.md
- docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
- docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
- docs/canon/ACT_I_OPENING_SCENE_CARDS.md
- docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
- docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
- docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md

Goal:
Implement only the Tuesday handoff correction and Wednesday O1/O2 vertical slice.

Required runtime result:
- Tuesday J1 no longer shows Mathilde bags/shoes/racket as already installed.
- Wednesday day/index becomes the canonical active Chapter 2.
- O1 Marie make-room scene with M0 three choices.
- O2 Marie arrival trace with mathilde_arrival_room_01.
- O2 Mathilde arrival with MT0 three choices.
- semantic offline_beat after Player returns.
- data-driven Tuesday/Wednesday labels and status time.
- only chapter 01 and rewritten chapter 02 active in DataLoader.
- legacy J3+ files retained but not selectable.
- flags only; no new numeric route scores.

Do not implement Thursday or Friday.
Do not modify character canon.
Do not add adult content.
Do not delete legacy J3+ files.
Do not perform a large refactor.

Run:
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 tools/player_choice_text_check.py
python3 tools/player_presence_check.py
python3 tools/simulate_route_paths.py
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit

Deliver:
- concise changed-file summary
- exact test/validation results
- manual walkthrough result
- confirmation that Thursday/Friday and adult routes were not implemented
- any technical limitation discovered, without expanding scope
```

---

# 19. Acceptance rule

```text
V0.81 succeeds when the prototype can end Tuesday cleanly,
show Wednesday arriving,
let Player make room,
let Mathilde enter the household,
and stop the chat when real co-presence begins.

Nothing more is required from the first vertical slice.
```
