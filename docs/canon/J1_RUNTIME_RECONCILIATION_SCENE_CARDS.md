# J1 Runtime Reconciliation Scene Cards — V0.83

> Structured scene cards for the reconciled active Tuesday runtime.  
> Companion to `J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md`.  
> Documentation only.

## 1. Timeline map

| Phase | Time | Content | Class | Required |
|---|---:|---|---|---|
| `tuesday_marie_opening` | 18:12 | `j1_marie_dinner_walk_01` | foreground / couple anchor | yes |
| `tuesday_shared_evening` | ~19:15 | `j1_shared_evening_offline_01` | offline consequence | yes |
| `tuesday_sandra_trace` | 22:57 | `j1_sandra_old_lunch_trace_01` | foreground / soft trace | yes |
| `tuesday_marie_final_return` | ~23:25 | `j1_marie_final_shared_life_01` | final couple consequence | yes |

No optional phase exists in reconciled J1.

---

# 2. Card — Marie opening

```yaml
scene_id: j1_marie_dinner_walk_01
working_title: Bread and ten minutes outside
scene_class: foreground couple anchor
primary_function: establish ordinary warmth and test concrete presence
primary_relationship: Player / Marie
principal_character: Marie
```

## Scope

```yaml
act_range: Act 0
route_stage_range: couple baseline
intensity_tier: ordinary
calendar_anchor: Tuesday
time_band: EARLY_EVENING
approximate_clock_range: 18:12–18:35
communication_mode: REMOTE_ASYNC
foreground_cost: 1
```

## Physical context

- Marie is at La Verrière or returning from it;
- Player is leaving work, commuting, or elsewhere;
- they are not co-present;
- the phone is justified by distance and practical coordination.

## Canon dependencies

```text
MARIE_CANON_FULL.md
PLAYER_CANON_FULL.md
CHOICE_DESIGN_CANON.md
DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
```

## Requirements

- Tuesday is active;
- no external route active;
- Player and Marie remain together;
- no mandatory consequence due.

## Exclusions

- Mathilde already installed;
- Sandra already active in the day;
- co-present Messenger dialogue;
- adult content;
- numeric route effects.

## Stable engine

```text
ordinary dinner problem
-> Marie asks for bread and a short walk
-> Player chooses quality of presence
-> Marie's La Verrière life becomes visible
-> Mathilde remains an indirect family seed
-> shared evening becomes due
```

## Choice contract

```yaml
choice_node: M1
primary_decision_axis: how Player joins the ordinary shared evening
choice_count: 3
choices:
  present:
    flags:
      - j1_marie_present
      - j1_shared_evening_due
  playful_present:
    flags:
      - j1_marie_playful_present
      - j1_shared_evening_due
  delayed_flat:
    flags:
      - j1_marie_delayed_flat
      - j1_shared_evening_due
```

## Agency

Marie:

- wants dinner, a walk, and Player's attention;
- keeps her own La Verrière life;
- does not declare a crisis;
- does not make another character the reason for the request;
- still expects the shared evening to happen after a weak answer.

## Exit

```yaml
exit_state:
  - one presence posture known
  - shared evening due
  - Thursday event seeded
  - Mathilde indirect only
consequence_due: immediate next phase
cooldown: scene never repeats
fallback: mandatory function-equivalent Marie opening
```

---

# 3. Card — Shared evening offline

```yaml
scene_id: j1_shared_evening_offline_01
working_title: Phone in the pocket
scene_class: offline consequence
primary_function: pay Marie's practical invitation in real shared life
primary_relationship: Player / Marie
principal_character: Marie
```

## Scope

```yaml
calendar_anchor: Tuesday
time_band: EVENING
approximate_clock_range: 19:15–20:15
communication_mode: OFFLINE_BEAT
foreground_cost: timeline beat
```

## Requirements

- Marie opening complete;
- `j1_shared_evening_due` true;
- one M1 posture flag true.

## Exclusions

- Messenger bubbles;
- new choice;
- Sandra trace before completion;
- route state increase.

## Engine

```text
Player returns
-> dinner happens
-> short walk happens
-> selected posture changes tone
-> phone remains out of the interaction
-> late-night Sandra window becomes possible
```

## Variants

### Present/playful

- Player arrives with bread;
- dinner and walk occur without a relaunch;
- write `j1_marie_return_active`.

### Delayed/flat

- Player arrives later but follows through;
- Marie notices both delay and effort;
- write `j1_marie_return_delayed`.

Common write:

```text
j1_shared_evening_completed
```

## Exit

```yaml
exit_state:
  - dinner and walk happened
  - Player and Marie remain together
  - Sandra late trace may become current later
consequence_due: none immediate
next_phase: tuesday_sandra_trace
```

---

# 4. Card — Sandra trace

```yaml
scene_id: j1_sandra_old_lunch_trace_01
working_title: Two glasses and a blurred edge
scene_class: foreground trace
primary_function: reintroduce Sandra softly through one concrete image
primary_relationship: Player / Sandra
principal_character: Sandra
```

## Scope

```yaml
act_range: Act 0
route_stage_range: R0 -> soft trace seed
intensity_tier: ordinary / soft private attention
calendar_anchor: Tuesday
time_band: NIGHT
approximate_clock_range: 22:57–23:15
communication_mode: REMOTE_ASYNC
foreground_cost: 1
```

## Physical context

- Sandra is at home after work;
- Player is physically elsewhere or using his phone privately;
- no co-present issue;
- the message is justified by the discovered photograph.

## Requirements

- shared evening complete;
- Sandra trace not already shown;
- no later Tuesday phase active.

## Exclusions

- lake/nature memory;
- romance-novel exposition;
- deep couple confession by Player;
- `Moi aussi, ça m'avait manqué` / `Toi` escalation;
- second image;
- numeric attachment effects;
- route R2.

## Stable engine

```text
old lunch image found after work
-> Sandra admits she likes the imperfect trace
-> Player reads warmly, precisely, or cautiously
-> Sandra names a soft boundary and leaves
-> final Marie return becomes due
```

## Choice contract

```yaml
choice_node: S1
primary_decision_axis: how precisely Player reads Sandra's trace
choice_count: 3
choices:
  safe_warmth:
    flags:
      - j1_sandra_safe_warmth
  precise_observation:
    flags:
      - j1_sandra_precise_observation
  cautious:
    flags:
      - j1_sandra_cautious
```

Common completion flag:

```text
j1_sandra_trace_complete
```

## Trace record

```yaml
trace_id: j1_sandra_lunch_memory_soft
origin: old lunch photo printed/found by Sandra
creator: ordinary prior photo context
holder: Sandra, then Player through message
intended_audience: Player only
consent_level: chosen ordinary private sharing
adult_function: none
risk: low
```

## Agency

Sandra:

- chooses to send one imperfect image;
- can stop the exchange;
- does not wait for pressure;
- keeps work and sleep obligations;
- leaves before the trace becomes a declaration.

## Exit

```yaml
exit_state:
  - Sandra soft trace seed exists
  - no route activation
  - Player remains in shared home life
consequence_due: final Marie/shared-life beat
next_phase: tuesday_marie_final_return
```

---

# 5. Card — Final Marie return

```yaml
scene_id: j1_marie_final_shared_life_01
working_title: Message to prove
scene_class: mandatory final consequence
primary_function: return emotional center to Marie/shared life
primary_relationship: Player / Marie
principal_character: Marie
```

## Scope

```yaml
calendar_anchor: Tuesday
time_band: NIGHT
approximate_clock_range: 23:25–23:35
communication_mode: OFFLINE_BEAT
foreground_cost: final timeline beat
```

## Requirements

- Sandra trace complete;
- shared evening complete;
- one M1 posture flag known;
- Player and Marie physically co-present.

## Exclusions

- Messenger transcript;
- another route opportunity;
- new choice;
- forgiveness button;
- day completion before rendering.

## Engine

```text
Player puts phone down
-> Marie is still part of the same evening
-> prior presence posture colors one short offline exchange
-> shared-life object closes the day
-> Tuesday completes
```

## Variants

### Present/playful

- Marie thanks Player for the walk;
- `Message à prouver`;
- cheese knife / phone put away;
- write `j1_marie_final_return_present`.

### Delayed/flat

- Marie names distance without a crisis speech;
- asks for one small true act rather than a promise;
- cheese knife / phone put away;
- write `j1_marie_final_return_delayed`.

Common write:

```text
j1_day_complete
```

## Exit

```yaml
exit_state:
  - couple remains HABITUAL_WARMTH
  - Sandra remains soft trace only
  - Tuesday COMPLETE
consequence_due: day transition
next_day: Wednesday
```

---

# 6. Choice and state audit

```text
meaningful choice nodes = 2
choices per node = 3
numeric route effects = 0
hard secrets = 0
adult frames = 0
```

---

# 7. Final rule

```text
J1 contains one couple request, one external trace, and two real returns to shared life.
No transcript inflation is needed to make the evening meaningful.
```
