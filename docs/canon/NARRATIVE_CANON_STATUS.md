# Narrative Canon Status — Current

> Current narrative and implementation status after locked V0.93 and the V0.94 runtime-integration planning pass.
> Runtime is playable from Tuesday through Monday at locked V0.92.
> V0.93 and V0.94 are documentation-only and define the next visual-first adult wave and its implementation order.

## 1. Version authority

```text
V0.78 = modular story architecture
V0.79 / V0.83 = opening narrative and reconciled J1
V0.84–V0.86a = authoritative day flow, opening runtime, and phone-time UX
V0.87 = first post-opening repetition narrative source
V0.88 = first-repetition integration plan
V0.89 = Saturday/Sunday first slice runtime
V0.90 = Monday Sandra second slice runtime
V0.91 = first-repetition closure blueprint
V0.92 = locked first-repetition wave closure runtime
V0.93 = locked next visual-first wave source pack
V0.94 = current runtime-integration plan for V0.95–V0.98
```

Legacy runtime is not automatic canon.
Documented scenes are not playable until integrated.

---

## 2. Locked baseline

```text
version: V0.93 — Visual-First Next Act I Wave Source Pack
main / origin/main: d84e07ce4c7a93b8e27b2cda35936e7f0ed9c106
tag: v0.93-visual-first-next-act-i-wave-source-pack
engine: Godot 4.6.x
```

V0.93 changes documentation only.
The current executable runtime remains the locked V0.92 behavior contained by that baseline.

---

## 3. Current playable chronology

```text
day 1 Tuesday — Marie / Sandra opening
day 2 Wednesday — Mathilde enters the household
day 3 Thursday — Raphaëlle, Sandra, Marie topology and return
day 4 Friday — Pauline public trace, Nico friendship, opening close
day 5 Saturday — Marie shared hour
day 6 Sunday — Mathilde opportunity and Marie return
day 7 Monday — Sandra opportunity, Marie return, wave closure
```

Current endpoint:

```text
Monday evening
chapter_07_modular_index.json next_day = null
opening_band_complete = true
first_repetition_slice_01_complete = true
first_repetition_slice_02_complete = true
first_repetition_wave_complete = true
```

Completed days remain read-only archives.

---

## 4. Current runtime relationship state

```text
Marie / Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

Mathilde = R1 or R2 Charged Access
Sandra = R1
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access
Raphaëlle = R1 Ordinary Work Access

hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
```

Historical first-repetition state remains in:

```text
story_ledgers.first_repetition
```

It is not reset by the next wave.

---

## 5. Current runtime capabilities and gaps

Already implemented:

```text
persistent character threads
guided and three-choice replies
day and phase chronology
optional expiry and silent defer
compact cross-thread notifications
same-thread continuation
structured first-repetition ledger
individual content unlock IDs
placeholder visual cards
read-only day archives
```

Not yet implemented:

```text
actual photo texture rendering from asset_path
player-facing photo gallery
three-photo daily contract
named-boundaries ledger
primary visual route claim
secondary visual-risk claim
Tuesday day 8
Wednesday day 9
Thursday day 10
```

---

## 6. V0.93 next-wave product truth

Act placement:

```text
Act I S5 — A boundary becomes explicit
```

Revised dramatic question:

```text
Which woman deliberately changes what she shows,
which fantasy does Player encourage,
and what risk is he willing to create?
```

The wave covers:

```text
next Tuesday through Thursday evening
```

Hard visual contract:

```text
3 female-focused photos minimum per day
9 images minimum across the wave
12–18 target including route variants
one primary female visual progression maximum
one secondary Pauline/Nico risk maximum
at least one V3 provocative set or first V4 erotic teaser
```

Pornographic content is the visible destination of routes.
V0.93 need not contain full V5 intercourse, but every major route must clearly signal its future adult payoff.

---

## 7. Character route promises documented by V0.93

### Marie

```text
black-dress visibility
public desirability
private couple continuation
lingerie / erotic reconquest
future couple porn or shared-gaze fantasy
```

### Mathilde

```text
domestic sexy presentation
deliberate pose for Player
underwear / lingerie in Marie's apartment
hidden taboo, discovery, confession, or future shared-home sex
```

### Sandra

```text
elegant private image
hesitant mirror image
chosen extra exposure
satin / lingerie / later private nudity and secret sex
```

### Pauline

```text
public green-dress version
private alternate crop
double-addressed image
future secret proof, alibi, and double-life pornography
```

### Nico

```text
sexualized selection of legitimate images
male complicity
shared-gaze opportunity
unapproved recontextualization risk
future consented sharing, cuckold/NTR fantasy, or betrayal
```

### Raphaëlle

```text
elegant office version
fitted workshop version
partial costume transformation
future roleplay and power-exchange pornography
```

These are documented future accesses, not current runtime unlocks.

---

## 8. V0.94 implementation authority

Approved sequence:

```text
V0.95 — Tuesday Marie Visual Opening + Gallery MVP
V0.96 — Wednesday Carry-Over Route + Guaranteed Social Set
V0.97 — Pauline/Nico Visual Risk Continuation
V0.98 — Thursday Dominant Payoff + Guarded Wave Closure
```

### V0.95 boundary

Must implement only:

```text
day 8 Tuesday
three distinct real Marie black-dress images
actual inline texture rendering
Gallery MVP reading GameState.unlocked_content
M4 action/fantasy choice
one structured obligation
story_ledgers.named_boundaries_wave
VisualDayContract three-slot gate
named_boundaries_slice_01_complete
```

V0.95 local endpoint:

```text
chapter_08_modular_index.json next_day = null
```

V0.96 later unlocks Wednesday.

### V0.96 boundary

```text
historical Mathilde/Sandra selector
three-image Mathilde or Sandra route set when eligible
three guaranteed Marie/Pauline social images
Mathilde repair date
L'Annexe table/seat incident
one primary visual route claim maximum
```

### V0.97 boundary

```text
Pauline private-alternate opportunity
Nico erotic selection from credible already-unlocked images
one secondary risk maximum
Thursday unlock after terminal phases
```

### V0.98 boundary

```text
one dominant three-image female payoff
Marie fallback if no external primary route
Marie obligation paid / amended / failed
pure guarded closure
named_boundaries_wave_complete
Friday remains unavailable
```

---

## 9. State ownership

```text
TimelineState = chronology
GameState = flags, unlocked content, story ledgers
EffectApplier = authored flags and unlocks
visual-content data = image identity, audience, intensity, route and risk metadata
```

New ledger:

```text
story_ledgers.named_boundaries_wave
```

Owns:

```text
primary_carryover_source
primary_visual_route
secondary_risk_seed
scene lifecycle
obligations
social hub status
Nico cycle status
```

Does not duplicate:

```text
image unlock IDs
image metadata
first-repetition history
Mathilde charged owner
```

---

## 10. Visual runtime contract

Each new day index uses:

```text
daily_visual_contract
```

Rules:

```text
three explicit visual slots minimum
one unlocked content ID satisfies one slot
branch alternatives listed explicitly
duplicate IDs cannot satisfy several slots
unknown or non-photo content blocks completion
fallback metadata cards do not count as product-valid photography
```

V0.95 adds:

```text
ConversationViewV095.gd
PhotoGalleryView.gd
PhotoGalleryView.tscn
VisualDayContract.gd
PhonePrototypeV095.gd
```

The gallery reads `GameState.unlocked_content`; it does not maintain a second collection state.

---

## 11. Current exclusions

V0.94 does not authorize:

- runtime changes on the planning branch;
- all three new days in one patch;
- Wednesday content in V0.95;
- Pauline or Nico risk in V0.95;
- Thursday payoff in V0.95;
- a full smartphone redesign;
- a global `DataLoader` refactor;
- a `TimelineState` rewrite;
- save-system work;
- duplicate images used to inflate the daily count;
- placeholders treated as final visual QA;
- Friday after the new wave;
- multiple dominant female payoff routes in one run.

---

## 12. Final current rule

```text
V0.92 answers what is playable.
V0.93 answers what the next adult visual wave must deliver.
V0.94 answers how to integrate it safely.
V0.95 is the next authorized runtime target after V0.94 locks.
```
