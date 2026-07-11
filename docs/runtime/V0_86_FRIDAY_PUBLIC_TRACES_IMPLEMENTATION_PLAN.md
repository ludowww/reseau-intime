# V0.86 — Friday Public Traces & Opening Completion Plan

> Runtime implementation plan for the final V0.79 opening band.  
> Builds directly on the validated V0.85 Tuesday–Thursday runtime.  
> Documentation first: this file defines the exact Friday boundary before data/runtime files are added.

## 1. Goal

Complete the authored V0.79 opening through:

```text
Friday morning
-> Pauline / authorized public group-photo relay

Friday afternoon
-> Nico / saved-seat friendship follow-up

Friday late afternoon
-> Marie + Mathilde household echoes

Friday early evening
-> short offline household close
-> opening band complete
```

V0.86 must establish Pauline and Nico at `R1 Ordinary Access` only.

It must not activate:

- Pauline's private compartment;
- Nico's voyeurism or domestic envy;
- any photo pact or alibi;
- a private crop;
- a secret;
- R2;
- adult content.

---

## 2. Required canon

Read:

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
  O7 — Pauline public group-photo relay
  O8 — Nico saved-seat follow-up
  Household breather after O8

docs/canon/ACT_I_OPENING_SCENE_CARDS.md
  Card 12 — Pauline
  Card 13 — Nico
  Echo cards — Household breather

docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
  Friday morning / afternoon / late afternoon

docs/canon/characters/PAULINE_CANON_FULL.md
docs/canon/characters/NICO_CANON_FULL.md
```

Runtime baseline:

```text
V0.85
commit 0c1ee8545c92c37c7daab61d606e2273b8ef8905
```

---

## 3. Branch and PR

```text
branch: work/friday-public-traces-opening-completion-v0-86
PR title: runtime: complete V0.86 Friday opening traces
```

Keep the PR short and data-first.

No general timeline refactor is required.

---

## 4. Active day chain

Update Thursday:

```text
chapter_03_modular_index.json
next_day: 4
```

Create:

```text
game/data/conversations/chapter_04_modular_index.json
```

Active chain:

```text
Tuesday -> Wednesday -> Thursday -> Friday
```

Friday starts locked and becomes current only after the mandatory Thursday Marie return and Thursday day-end transition.

Friday has no next day in V0.86.

---

## 5. Friday phases

Recommended exact implementation times remain inside the approved canon ranges.

```text
08:35 — friday_pauline_public_relay
14:05 — friday_nico_followup
18:05 — friday_household_echoes
18:25 — friday_opening_close
```

### Phase 1 — Pauline

```text
required: chapter_04_pauline_public_photo_relay
communication: TRACE_DELIVERY + REMOTE_ASYNC
```

### Phase 2 — Nico

```text
required: chapter_04_nico_saved_seat_followup
communication: REMOTE_ASYNC
```

### Phase 3 — Household echoes

```text
required:
- chapter_04_marie_household_report
- chapter_04_mathilde_bathroom_correction
```

The contacts may be opened in either order because they belong to the same `18:05` phase.

Marie may produce the notification. Mathilde should unlock silently to avoid two simultaneous banners.

### Phase 4 — Opening close

Use the V0.85 `authored_beat` support.

```text
18:25
Player returns to the enlarged household.
No speech about routes or desire.
The new ordinary rhythm is confirmed.
```

Writes:

```text
household_rhythm_confirmed
opening_band_complete
```

Only after this beat may Friday complete.

---

## 6. Pauline conversation

Create:

```text
game/data/conversations/chapter_04_pauline_public_photo_relay.json
```

Thread:

```text
thread_pauline_private
```

Scene:

```text
pauline_public_group_photo_relay_01
```

Required lines and P0 come from V0.79.

Meaningful choice node:

```text
P0 — exactly three choices
```

Postures:

```text
practical selection
 dry joke
 defer to Marie
```

Recommended flags:

```text
pauline_public_selection_practical
pauline_public_selection_dry
pauline_public_selection_deferred_to_marie
pauline_r1_established
laverriere_public_group_photo_selected
```

A/B may also write:

```text
laverriere_public_photo_2_selected
```

C preserves Marie as decision owner.

No numeric effects.

---

## 7. Public visual

Create:

```text
game/data/visual_content/chapter_04_opening_proofs.json
```

Only active item:

```text
laverriere_public_group_photo_set_01
```

Required metadata meaning:

- created with Pauline's remote shutter;
- three authorized event versions;
- Marie, Pauline, Bastien, Élodie and possibly Nico visible;
- Player visible only if he reached the photo context;
- Mathilde absent because she remained home;
- intended audience is the photographed group and La Verrière archive/public post;
- risk 0 / ordinary social image;
- no body crop;
- no private alternate;
- no adult function;
- no forwarding permission beyond event/public context.

No binary asset is required while the prototype uses metadata cards.

---

## 8. Nico conversation

Create:

```text
game/data/conversations/chapter_04_nico_saved_seat_followup.json
```

Thread:

```text
thread_nico_private
```

Scene:

```text
nico_saved_seat_followup_01
```

Opening variant reads prior Thursday state:

```text
opening_topology_join_marie
opening_topology_stay_home
work_promise_kept
work_promise_amended
work_promise_missed
```

Exactly one opening variant must render.

Meaningful choice node:

```text
N0 — exactly three visible choices
```

Postures:

```text
honest
playful
ask about Marie
```

Recommended flags:

```text
nico_friendship_honest
nico_friendship_playful
nico_social_mirror_seed
nico_r1_established
nico_saved_seat_resolved
```

After N0, one short guided knowledge echo may establish:

```text
nico_knows_mathilde_stay
```

The echo remains ordinary:

```text
Courage pour les prises électriques.
Et pour les chaussures, visiblement.
```

It must not contain:

- a body comment;
- attraction language;
- domestic envy;
- a photo request;
- an alibi;
- a voyeur pact;
- rivalry;
- NTR/cuckold framing.

---

## 9. Household echoes

Create:

```text
game/data/conversations/chapter_04_marie_household_report.json
game/data/conversations/chapter_04_mathilde_bathroom_correction.json
```

Threads:

```text
thread_marie_private
thread_mathilde_private
```

No choice is required.

Marie:

```text
Rapport du foyer.
Mathilde a pris la salle de bain vingt-sept minutes.
Nous sommes officiellement trois adultes très organisés.
```

Mathilde:

```text
Marie dramatise.
Vingt-deux minutes maximum.
Et il y avait une urgence capillaire.
```

These are separate private echoes, not a fake visible group chat.

They write no route state.

---

## 10. Active loader changes

Update `DataLoader.gd`:

```text
CHAPTER_INDEX_PATHS
+ chapter_04_modular_index.json

VISUAL_CONTENT_PATHS
+ chapter_04_opening_proofs.json
```

Keep legacy:

```text
chapter_04_index.json
chapter_04_proofs.json
```

inactive and on disk.

No new phone or conversation adapter should be necessary.

---

## 11. Friday end state

After the final authored beat:

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Mathilde = R1 Ordinary Access, stay active
Raphaëlle = R1 Ordinary Work Access
Sandra = soft trace / optional echo resolved or expired
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access
public group-photo trace = exists
household rhythm = confirmed
opening band = complete
hard secrets = none
adult frames = none
routes R2+ = none
```

---

## 12. Tests

Add:

```text
tests/test_v086_friday_opening_static.py
```

Cover:

- active loader includes Friday modular index and current visual bundle;
- legacy Chapter 4 remains inactive;
- Thursday `next_day = 4`;
- Friday starts `LOCKED`;
- exact phase order and times;
- P0 exactly three choices and flags only;
- visual origin, Bastien visibility, Mathilde absence and risk 0;
- N0 exactly three visible choices for every topology state;
- exactly one Nico opening variant per topology;
- Mathilde knowledge echo remains ordinary;
- household echoes are separate threads with no choices;
- final authored beat sets `opening_band_complete`;
- Friday has no next day;
- no R2, private crop, photo pact, alibi, voyeurism, NTR/cuckold or adult content.

Update V0.84 temporal tests for the four-day chain.

---

## 13. Validation

```bash
python3 tools/validate_game_data.py

python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  tests.test_v085_j1_reconciliation_static \
  tests.test_v086_friday_opening_static \
  -v

python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_04_pauline_public_photo_relay.json \
  game/data/conversations/chapter_04_nico_saved_seat_followup.json \
  game/data/conversations/chapter_04_marie_household_report.json \
  game/data/conversations/chapter_04_mathilde_bathroom_correction.json

python3 tools/player_presence_check.py \
  game/data/conversations/chapter_04_pauline_public_photo_relay.json \
  game/data/conversations/chapter_04_nico_saved_seat_followup.json

git diff --check

godot --headless --path game --quit

godot --headless --path game --resolution 1280x720 --quit
```

---

## 14. Manual walkthrough

1. Friday is hidden until Thursday O6 and day completion.
2. Thursday end card transitions to `VENDREDI — MATIN`.
3. Pauline opens at 08:35 with one authorized public set.
4. Bastien remains visible in the visual context.
5. P0 shows exactly three choices.
6. No private crop or one-view version appears.
7. Nico opens at 14:05 with the correct topology-specific first lines.
8. N0 shows exactly three choices.
9. Nico may learn Mathilde is staying, without sexualizing it.
10. Marie and Mathilde unlock together at 18:05 in separate threads.
11. Both short echoes complete before the final household beat.
12. The 18:25 offline close sets `opening_band_complete`.
13. Friday archives read-only and shows the offline close once.
14. No later day appears.

---

## 15. Explicit exclusions

V0.86 must not add:

- Pauline private crop;
- Pauline reciprocal proof;
- Pauline secret compartment;
- Nico body comments;
- Nico photo request;
- Nico alibi;
- Nico domestic envy;
- voyeurism activation;
- NTR/cuckold framing;
- R2;
- adult content;
- hard secrets;
- save migration;
- a universal scheduler;
- deletion of legacy Chapter 4.

---

## 16. Final rule

```text
Friday does not begin the dangerous routes.

It proves that Pauline and Nico exist first as ordinary people,
that public images have a known origin and audience,
and that the opening closes on the enlarged household rather than temptation.
```
