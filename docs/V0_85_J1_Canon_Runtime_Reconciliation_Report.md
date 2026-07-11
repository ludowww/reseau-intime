# V0.85 — J1 Canon Runtime Reconciliation Report

> Runtime replacement of the active Tuesday content.  
> V0.85 does not expand the story beyond Thursday and does not alter Wednesday or Thursday narrative meaning.

## 1. Purpose

V0.84 made chronological access authoritative but intentionally left Tuesday on filtered legacy conversations.

V0.85 replaces that temporary content with a concise J1 aligned to:

```text
V0.69 exact-line intent
V0.70 three-choice design
V0.78 modular architecture
V0.83 temporal/J1 reconciliation canon
```

The active day now follows:

```text
18:12 Marie remote opening + M1
19:15 / 19:35 dinner and walk offline
22:57 Sandra soft trace + S1
23:25 / 23:28 final Marie/shared-life return
Tuesday complete -> Wednesday
```

## 2. Baseline and branch

```text
Base version: V0.84
Base commit: dd1509ce02ad16341ff246e6d209ae623f29a8a7
Branch: work/j1-canon-runtime-reconciliation-v0-85
```

## 3. New active conversations

```text
game/data/conversations/chapter_01_marie_opening.json
game/data/conversations/chapter_01_sandra_trace.json
```

The active Tuesday index no longer references:

```text
chapter_01_marie.json
chapter_01_sandra.json
```

Those files remain untouched as legacy data for rollback and historical comparison.

No `conversation_filters` are used by the active Tuesday story.

## 4. Marie opening

The opening is remote and chronologically grounded:

- Marie is at La Verrière or leaving it;
- Player is still elsewhere;
- bread is requested before it is obtained;
- the short walk is proposed before Player asks whether the couple is in crisis;
- no co-present Messenger exchange occurs.

M1 has exactly three postures:

```text
present
playful-present
delayed/flat
```

The Player replies are explicit future actions:

```text
Je prends le pain et on marche.
```

They no longer claim credit for bread before the bakery trip and no longer propose a couch interaction from an incompatible physical location.

Flags only:

```text
j1_marie_present
j1_marie_playful_present
j1_marie_delayed_flat
j1_shared_evening_due
```

No trust, neglect, attention, truth, desire, or route score is written.

## 5. La Verrière and Mathilde seeds

Marie briefly establishes:

- Thursday's small La Verrière event;
- the reversed logos;
- the unreliable caterer;
- Élodie's accurate reading of Marie;
- Mathilde's planned installation visit and lighting opinion.

Mathilde remains indirect only:

- no active thread;
- no bag, shoe, racket, charger, or already-installed trace;
- no sexual intention;
- Wednesday's water-damage emergency remains coherent.

## 6. Shared evening offline beat

The second Tuesday phase contains no conversation card.

### Present/playful variant

```text
19:15
Player returns with bread.
Dinner and the ten-minute walk happen face to face.
The phone remains in his pocket.
```

### Delayed variant

```text
19:35
Player arrives later but still brings the bread.
Marie notices both the delay and the follow-through.
```

The V0.85 phone adapter selects the correct authored variant from the M1 flag, displays it through the temporal overlay, applies its flags once, records it in the read-only day log, completes the phase, and advances to Sandra.

## 7. Sandra soft trace

Sandra appears at 22:57 through one old lunch photograph:

```text
two glasses
one corner of the table
Sandra blurred at the edge
```

The active visual metadata no longer describes a lake or nature walk.

S1 has exactly three postures:

```text
safe warmth
precise observation
cautious reading
```

Flags only:

```text
j1_sandra_safe_warmth
j1_sandra_precise_observation
j1_sandra_cautious
j1_sandra_trace_complete
```

Sandra closes the window herself because she works early the next day.

The active exchange contains no:

- `On est mercredi` contradiction;
- 24:xx timestamp;
- lake/nature expansion;
- romance-novel exposition;
- deep `absent de moi-même` confession;
- `Moi aussi, ça m'avait manqué / Toi` escalation;
- attachment or priority score.

## 8. Final Marie/shared-life return

Tuesday cannot complete after Sandra alone.

A mandatory final offline phase returns the emotional center to Marie.

### Present/playful close

```text
23:25
Message à prouver.
Coupe le fromage.
```

### Delayed close

```text
23:28
Ne promets pas mieux.
Fais un petit truc vrai.
```

Both variants:

- occur face to face;
- contain no new choice;
- put the phone away;
- set `j1_day_complete`;
- allow the V0.84 day transition to unlock Wednesday only afterward.

## 9. Timeline support

New adapter:

```text
game/scripts/ui/PhonePrototypeV085.gd
```

It extends V0.84 and adds only conversation-free authored phases.

New `TimelineState` support:

```text
day_log_entries_by_day
record_day_log_entry
get_day_log_entries
```

Authored beats are:

- selected by current flags;
- displayed once;
- recorded once;
- restored in the completed-day archive under `Moments hors ligne`;
- non-interactive in archives;
- cleared on reset.

No timeline refactor or save migration is added.

## 10. Visual status

The active J1 references only:

```text
j1_sandra_lunch_memory_soft
```

Its current metadata is:

- ordinary private trace;
- selected by Sandra for Player;
- risk 0;
- not a proof;
- not a wallpaper reward;
- no adult function.

The existing Marie kitchen and Mathilde bag metadata remain in the bundle as explicitly marked legacy items, but active J1 references neither.

## 11. Choice and pacing audit

```text
meaningful three-choice nodes = 2
M1 choices = 3
S1 choices = 3
numeric narrative effects = 0
hard secrets = 0
adult frames = 0
```

The remaining single-response interactions are compact guided replies. The legacy pattern of dozens of one-option clicks is no longer active.

## 12. Files changed

Runtime/data:

```text
game/data/conversations/chapter_01_modular_index.json
game/data/conversations/chapter_01_marie_opening.json
game/data/conversations/chapter_01_sandra_trace.json
game/data/visual_content/chapter_01_proofs.json
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV085.gd
game/scenes/smartphone/PhonePrototype.tscn
```

Tests:

```text
tests/test_v081_wednesday_static.py
tests/test_v084_temporal_flow_static.py
tests/test_v085_j1_reconciliation_static.py
```

General documentation is synchronized in the same PR.

## 13. Explicit exclusions

V0.85 does not:

- change Wednesday dialogue or state;
- change Thursday topology or O6 meaning;
- add Friday;
- add Pauline or Nico;
- add R2 or adult content;
- delete legacy J1 files;
- remove every old state key globally;
- add save migration;
- replace the V0.84 timeline engine.

## 14. Validation required before merge

The GitHub connector cannot execute Python or Godot against the branch. No executable result is claimed yet.

Run:

```bash
python3 tools/validate_game_data.py

python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  tests.test_v085_j1_reconciliation_static \
  -v

python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_01_marie_opening.json \
  game/data/conversations/chapter_01_sandra_trace.json

python3 tools/player_presence_check.py \
  game/data/conversations/chapter_01_marie_opening.json \
  game/data/conversations/chapter_01_sandra_trace.json

git diff --check

godot --headless --path game --quit

godot --headless --path game --resolution 1280x720 --quit
```

## 15. Manual walkthrough

1. Launch: Tuesday only.
2. Marie opens at 18:12 with dinner, bread, and walk.
3. Confirm Player has not yet obtained the bread.
4. M1 shows exactly three coherent presence postures.
5. Confirm La Verrière and indirect Mathilde seeds remain concise.
6. Confirm the shared-evening offline card follows and no Messenger exchange occurs while co-present.
7. Sandra opens at 22:57 with one blurry lunch image.
8. S1 shows exactly three trace-reading postures.
9. Confirm every Sandra bubble remains Tuesday and before midnight.
10. Confirm no lake, novel, deep absence confession, or route escalation.
11. Complete Sandra's soft boundary.
12. Confirm the mandatory final Marie offline card.
13. Confirm Tuesday end / Wednesday start interstitial only after that card.
14. Reopen Tuesday archive and confirm both offline moments appear once, read-only.
15. Confirm Wednesday and Thursday content remain unchanged.

## 16. Next step

After V0.85 validation and merge:

```text
V0.86 — Friday Public Traces & Opening Completion
```

## 17. Final rule

```text
J1 now contains one couple request, one external trace, and two real returns to shared life.
It ends on Marie before time is allowed to become Wednesday.
```
