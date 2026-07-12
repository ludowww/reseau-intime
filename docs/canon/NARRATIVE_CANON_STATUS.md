# Narrative Canon Status — Current

> Narrative and implementation status after V0.86 Friday completion and V0.86a smartphone-time polish.  
> Runtime is playable from Tuesday through Friday with chronological access.  
> The concrete V0.79 opening band ends at `opening_band_complete`.

## 1. Core rule

```text
V0.78 defines modular story movement.
V0.79 defines the Tuesday–Friday opening content.
V0.80 defines phased runtime integration.
V0.81 implements Wednesday.
V0.82 implements Thursday topology and Marie return.
V0.83 defines authoritative temporal flow and the J1 replacement.
V0.84 makes temporal flow authoritative in runtime.
V0.85 replaces active Tuesday with the reconciled J1.
V0.86 implements Friday public traces and closes the opening band.
V0.86a makes elapsed time and notifications behave like a smartphone.
Legacy runtime is not automatic narrative canon.
```

## 2. Current source stack

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
docs/canon/J1_RUNTIME_RECONCILIATION_SCENE_CARDS.md
docs/V0_85_J1_Canon_Runtime_Reconciliation_Report.md
docs/runtime/V0_86_FRIDAY_PUBLIC_TRACES_IMPLEMENTATION_PLAN.md
docs/V0_86_Friday_Public_Traces_And_Opening_Completion_Report.md
docs/runtime/V0_86A_TEMPORAL_UX_NOTIFICATION_POLISH_PLAN.md
docs/V0_86A_Temporal_UX_Notification_Polish_Report.md
```

Read the relevant full character canon before changing a character scene.

---

## 3. Current playable access

```text
launch
-> Tuesday active
-> Wednesday locked
-> Thursday locked
-> Friday locked
```

Day progression is experienced through the active conversation UI:

```text
last message remains visible
-> contact goes offline
-> 2-second pause
-> fixed conversation clock advances for 4 seconds
-> next message notification appears
```

The clock may cross midnight. There is no active blank end-card/start-card landing page containing only a weekday, moment label, or timestamp.

Completed days remain read-only archives.

---

## 4. Current day sequence

### Tuesday — canonical J1

```text
18:12 Marie remote opening + M1
19:15 / 19:35 shared activity outside the phone
22:57 Sandra soft trace + S1
23:25 / 23:28 final return toward Marie/shared life
Tuesday complete
```

Guarantees:

- bread is still a future action when Player chooses;
- M1 has three comparable presence postures;
- all bubble times remain Tuesday and monotonic;
- Mathilde is indirect only;
- Sandra shares one imperfect image and closes the exchange herself;
- no numeric route effect;
- Tuesday ends on Marie/shared life.

### Wednesday — household change

```text
12:10 Marie / make room
-> 18:18 Marie / arrival trace
-> 18:22 Mathilde / arrival
-> installation continues outside the phone
-> Wednesday complete
```

Result:

```text
Mathilde stay = active
Mathilde = R1 Ordinary Access
sexual intention = not established
```

### Thursday — movement and topology

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> Sandra complete or expired
-> 16:05 Marie required
-> one O5 topology branch
-> 22:10 Marie return required
-> Thursday complete
```

Guarantees:

- Raphaëlle reaches R1 through work;
- exactly one topology is selected;
- every topology returns to Marie;
- no later Friday opportunity can replace O6;
- couple remains `HABITUAL_WARMTH`.

### Friday — traces and residue

```text
08:35 Pauline public group-photo relay + P0
14:05 Nico saved-seat follow-up + N0
18:05 Marie + Mathilde household echoes
18:25 internal household continuity close
-> opening_band_complete
```

Guarantees:

- Pauline reaches R1 through legitimate image competence;
- Bastien remains visible;
- the image origin and audience are explicit;
- no private alternate exists;
- Nico reaches R1 as a real friend and social mirror;
- Nico may know Mathilde is staying without sexualizing it;
- no image request, cover arrangement, rivalry, or dangerous frame opens;
- the opening closes on ordinary household life.

---

## 5. Current temporal and smartphone state

Day lifecycle:

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Phase lifecycle:

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Current runtime sources:

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/PhonePrototypeV085.gd
game/scripts/ui/PhonePrototypeV086A.gd
game/scripts/ui/ConversationViewV084.gd
game/scripts/ui/ConversationViewV086A.gd
```

The active conversation has a fixed status strip above the contact name:

```text
time                         Wi‑Fi / battery
contact
presence status
```

The temporary left prototype panel keeps no duplicate visible status strip.

Core rule:

```text
Time labels describe chronology.
Timeline state controls access.
The smartphone clock makes elapsed time perceptible.
```

---

## 6. Offline activity policy

Authored offline phases currently include internal continuity for:

- Tuesday dinner/walk;
- Tuesday final return toward Marie;
- Wednesday settling;
- Friday household close.

They may still select variants, apply flags, preserve order, and retain internal debug/day-log data.

They are not player-facing exposition. The active runtime displays no:

- full-screen offline card;
- centered offline-beat explanation;
- `Moments hors ligne` archive section;
- replayable clue describing Player’s off-screen actions.

The player infers activity through elapsed time, later dialogue, objects, knowledge, and consequences.

---

## 7. Friday image status

Active trace:

```text
laverriere_public_group_photo_set_01
```

Origin:

```text
Pauline compact remote shutter
```

Intended audience:

```text
photographed group
+ La Verrière archive/public post
```

Visible/social context includes:

- Marie;
- Pauline;
- Bastien;
- Élodie;
- possibly Nico;
- Player only when Thursday timing placed him there;
- not Mathilde.

The trace is ordinary, authorized, risk 0, and has no adult function.

A public image is not permission for a new private crop or private forwarding context.

---

## 8. Choice/state status

Meaningful opening nodes include:

```text
Tuesday: M1, S1
Wednesday: M0, MT0
Thursday: R0, M1, MA0/MH0/RW0
Friday: P0, N0
```

All foreground choice nodes remain at three choices.

V0.86 writes observable flags only, including:

```text
pauline_r1_established
laverriere_public_group_photo_trace_exists
nico_r1_established
nico_saved_seat_resolved
nico_knows_mathilde_stay
household_rhythm_confirmed
opening_band_complete
```

No Friday affection, desire, jealousy, adult-consent, or route score is written.

---

## 9. Current character and route status

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

Sandra = soft trace / cooled ordinary continuity
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access

Pauline private compartment = false
Nico dangerous shared-gaze frame = false
hard secrets = none
adult frames = none
routes R2+ = none
opening_band_complete = true
```

V0.86 completes ordinary access. It does not activate the later NSFW engines.

---

## 10. Archive behavior

Completed days are read-only.

Archive access:

- creates no pending marker or notification;
- offers no new choice;
- applies no effect;
- does not change current day, phase, or status time;
- cannot reactivate expired content;
- filters persistent-thread history by source episode/day;
- does not expose internal offline day-log entries.

---

## 11. Legacy status

Legacy files remain on disk but inactive unless explicitly referenced by a modular index.

Examples:

```text
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_01_sandra.json
game/data/conversations/chapter_04_index.json
game/data/visual_content/chapter_04_proofs.json
```

Do not treat their chapter number as authority over current modular files.

---

## 12. Validation status

V0.86 and V0.86a have dedicated static coverage in:

```text
tests/test_v086_friday_opening_static.py
tests/test_v086a_temporal_ux_static.py
```

Executable validation and both Godot headless boots must be confirmed locally before merge.

---

## 13. Roadmap

```text
V0.86 — Friday public traces and opening completion
V0.86a — Smartphone time and notification polish
V0.87 — Next Act I Windows Source Pack
```

V0.87 returns to documentation before new runtime expansion. It defines the first repeated/private-attention windows after ordinary access.

---

## 14. Final rule

```text
The playable opening ends Friday evening.
Every principal character first appears through an ordinary, defensible context.
Time is felt through the messaging interface, not explained by blank cards or offline logs.
No dangerous route may skip the next documentation pass.
```