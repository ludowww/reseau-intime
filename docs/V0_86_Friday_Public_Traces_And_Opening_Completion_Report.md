# V0.86 — Friday Public Traces & Opening Completion Report

> Runtime/data implementation of the final V0.79 opening windows.  
> Adds Friday public traces, ordinary Pauline/Nico access, household residue, and an authored opening-close beat.  
> Does not add R2, adult content, hard secrets, private image breaches, or a later day.

## 1. Baseline

```text
Base version: V0.85
Base commit: 0c1ee8545c92c37c7daab61d606e2273b8ef8905
Branch: work/friday-public-traces-opening-completion-v0-86
```

Primary canon:

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/canon/characters/PAULINE_CANON_FULL.md
docs/canon/characters/NICO_CANON_FULL.md
```

Implementation plan:

```text
docs/runtime/V0_86_FRIDAY_PUBLIC_TRACES_IMPLEMENTATION_PLAN.md
```

---

## 2. Implemented chronology

```text
Friday 08:35
O7 — Pauline public group-photo relay

Friday 14:05
O8 — Nico saved-seat follow-up

Friday 18:05
Marie + Mathilde household echoes

Friday 18:25
Authored offline household close
-> opening_band_complete
```

Friday remains locked until the mandatory Thursday Marie return and Thursday day completion.

The active day chain is now:

```text
Tuesday -> Wednesday -> Thursday -> Friday
```

Friday has no configured next day.

---

## 3. Pauline — legitimate social access

New active file:

```text
game/data/conversations/chapter_04_pauline_public_photo_relay.json
```

Thread:

```text
thread_pauline_private
```

Delivery:

```text
TRACE_DELIVERY + REMOTE_ASYNC
```

Pauline relays three authorized versions because Marie is driving and asked her to send them.

The scene establishes:

- Pauline's practical image competence;
- her dry public voice;
- Marie as event owner;
- Bastien as visible social reality;
- a known image origin and intended audience;
- no private compartment.

### P0

Exactly three choices:

```text
practical selection
 dry joke
 defer to Marie
```

All branches write flags only and establish:

```text
pauline_r1_established
laverriere_public_group_photo_trace_exists
```

A/B select the public second version.

C preserves Marie as final decision owner.

No branch creates:

- an alternate private crop;
- a one-view image;
- reciprocal proof;
- secret audience;
- adult image meaning.

---

## 4. Authorized public-photo set

New active bundle:

```text
game/data/visual_content/chapter_04_opening_proofs.json
```

Active item:

```text
laverriere_public_group_photo_set_01
```

Metadata locks:

- Pauline used her compact remote shutter;
- three ordinary event versions exist;
- Marie, Pauline, Bastien, and Élodie are visible;
- Nico may appear before moving to L'Annexe;
- Player appears only if his Thursday topology/timing placed him there;
- Mathilde is absent because she stayed home;
- intended audience is the photographed group and La Verrière archive/public post;
- `risk_level = 0`;
- no wallpaper reward;
- no private/body recrop;
- no adult function.

The existing legacy Chapter 4 visual bundle remains inactive.

---

## 5. Nico — ordinary friendship access

New active file:

```text
game/data/conversations/chapter_04_nico_saved_seat_followup.json
```

Thread:

```text
thread_nico_private
```

Delivery:

```text
REMOTE_ASYNC
```

The first two Nico messages read Thursday history:

```text
joined Marie early
stayed home
worked then arrived / amended
missed after promising
```

Exactly one opening variant renders.

### N0

Exactly three visible choices in every topology state:

```text
honest
playful
ask about Marie
```

The file contains four authored choice entries only because the honest line has one joined and one non-joined wording. Conditions guarantee that only one honest entry is visible.

All N0 branches write flags only and establish:

```text
nico_r1_established
nico_saved_seat_resolved
```

The `ask about Marie` choice preserves Nico's social-mirror role and returns Player's attention to Marie.

### Mathilde knowledge echo

Nico may ask whether Mathilde is really staying.

The answer establishes:

```text
nico_knows_mathilde_stay
```

His response stays practical and ordinary:

```text
prises électriques
chaussures
```

It does not activate attraction commentary, domestic envy, image requests, rivalry, or any adult/shared-gaze frame.

---

## 6. Household residue

New active files:

```text
game/data/conversations/chapter_04_marie_household_report.json
game/data/conversations/chapter_04_mathilde_bathroom_correction.json
```

Threads remain separate:

```text
thread_marie_private
thread_mathilde_private
```

At `18:05`, both episodes unlock in the same phase.

Marie produces the visible notification.

Mathilde unlocks silently so two banners do not compete.

Neither episode has a choice or route write.

This is not a mandatory group chat.

The phone is justified because the characters are still physically separated.

---

## 7. Final household close

Friday ends with a conversation-free authored phase using the V0.85 timeline support.

```text
18:25
Player retrouve Marie et Mathilde.
La salle de bain est libre.
Le chargeur est retrouvé.
Le bureau n'est plus tout à fait un bureau.
Le nouveau rythme tient pour ce soir.
```

Writes:

```text
household_rhythm_confirmed
opening_band_complete
```

The beat:

- contains no route choice;
- happens offline because the household is co-present;
- appears once in the read-only Friday archive;
- completes Friday only after both household echoes are complete;
- closes the opening on ordinary life rather than temptation.

---

## 8. Runtime/data files

### Added

```text
docs/runtime/V0_86_FRIDAY_PUBLIC_TRACES_IMPLEMENTATION_PLAN.md
docs/V0_86_Friday_Public_Traces_And_Opening_Completion_Report.md
game/data/conversations/chapter_04_modular_index.json
game/data/conversations/chapter_04_pauline_public_photo_relay.json
game/data/conversations/chapter_04_nico_saved_seat_followup.json
game/data/conversations/chapter_04_marie_household_report.json
game/data/conversations/chapter_04_mathilde_bathroom_correction.json
game/data/visual_content/chapter_04_opening_proofs.json
tests/test_v086_friday_opening_static.py
```

### Updated

```text
game/data/conversations/chapter_03_modular_index.json
game/scripts/core/DataLoader.gd
tests/test_v084_temporal_flow_static.py
```

General documentation is synchronized in the same PR.

---

## 9. Loader and legacy policy

Active indexes:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
chapter_04_modular_index.json
```

Active current visual bundles include:

```text
chapter_04_opening_proofs.json
```

Legacy files remain on disk and inactive:

```text
chapter_04_index.json
chapter_04_proofs.json
legacy Chapter 4 conversations
```

No destructive migration is performed.

---

## 10. Final opening state

```text
Marie/Player:
  couple_mode: HABITUAL_WARMTH
  relationship_frame: ASSUMED_EXCLUSIVE

Mathilde:
  stay_active: true
  route_stage: R1
  deliberate_intent: false

Sandra:
  route_stage: soft trace / cooled ordinary continuity
  new_image_after_J1: false

Raphaëlle:
  route_stage: R1
  personal_access: false

Pauline:
  route_stage: R1
  private_compartment: false
  Bastien_visible: true

Nico:
  route_stage: R1
  social_mirror_seed: possible
  dangerous_image_exchange: false

traces:
  laverriere_public_group_photo_set: authorized public/social

household_rhythm_confirmed: true
opening_band_complete: true
hard_secrets: none
adult_frames: none
routes_R2_plus: none
```

---

## 11. Tests

New module:

```text
tests/test_v086_friday_opening_static.py
```

Coverage includes:

- active/legacy Chapter 4 separation;
- Thursday-to-Friday day chain;
- Friday phase order and timestamps;
- Pauline P0 exactly three choices;
- public visual origin/audience and Bastien visibility;
- Mathilde absence from the event image;
- Nico topology-specific openings;
- exactly three visible N0 choices in every topology state;
- ordinary Mathilde knowledge only;
- separate choice-free Marie/Mathilde echoes;
- final `opening_band_complete` beat;
- flags-only state;
- no Player auto messages;
- absence of private/adult escalation.

The V0.84 temporal suite is updated for the four-day active chain.

---

## 12. Validation required

The GitHub connector cannot execute repository or Godot commands.

Before merge, run:

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

## 13. Manual walkthrough

1. Friday remains hidden before Thursday O6.
2. Thursday completion transitions to `VENDREDI — MATIN`.
3. Pauline opens at 08:35.
4. One authorized group-photo set appears.
5. Bastien remains visible in the visual context.
6. P0 shows exactly three public-selection choices.
7. Nico opens at 14:05 with the correct Thursday-history variant.
8. N0 shows exactly three choices.
9. The Mathilde-stay echo remains ordinary.
10. Marie and Mathilde unlock together at 18:05 in separate threads.
11. Both echoes are required before the final close.
12. The 18:25 offline beat writes `opening_band_complete`.
13. Friday becomes a read-only archive with the close recorded once.
14. No later day appears.

---

## 14. Explicit exclusions

V0.86 contains no:

- Pauline private crop or alternate audience;
- reciprocal proof;
- secret compartment;
- Nico body commentary;
- Nico image request;
- cover/alibi arrangement;
- domestic-envy activation;
- voyeuristic pact;
- rivalry state;
- NTR/cuckold framing;
- R2;
- adult content;
- hard secret;
- save migration;
- universal scheduler;
- deletion of legacy Chapter 4.

---

## 15. Next step

V0.86 completes the concrete V0.79 opening.

The next work should return to documentation before expanding runtime:

```text
V0.87 — Next Act I Windows Source Pack
```

That pack should define the first repetition/private-attention windows after every principal character has received ordinary access.

---

## 16. Final rule

```text
The opening is complete when every principal character first exists as a person,
not when every dangerous fantasy is already available.

Friday preserves image origin,
friendship,
Bastien's reality,
and the enlarged household.
```
