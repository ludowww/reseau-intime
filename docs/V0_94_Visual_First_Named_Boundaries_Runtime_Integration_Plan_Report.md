# V0.94 — Visual-First Named Boundaries Runtime Integration Plan Report

> Documentation-only implementation-planning milestone after locked V0.93.
> Converts the visual-first source pack into a small V0.95–V0.98 runtime sequence.
> No runtime, JSON, GDScript, test, image asset, merge, or tag change is made by this report.

## 1. Baseline

```text
repository: ludowww/reseau-intime
base version: V0.93
base SHA: d84e07ce4c7a93b8e27b2cda35936e7f0ed9c106
base tag: v0.93-visual-first-next-act-i-wave-source-pack
planning branch: work/visual-first-named-boundaries-runtime-plan-v0-94
```

Current runtime endpoint:

```text
Monday evening
first_repetition_wave_complete = true
next_day = null
```

---

## 2. Planning decision

The next wave will not be implemented in one patch.

Approved planning sequence:

```text
V0.95 — Tuesday Marie Visual Opening + Gallery MVP
V0.96 — Wednesday Carry-Over Route + Guaranteed Social Set
V0.97 — Pauline/Nico Visual Risk Continuation
V0.98 — Thursday Dominant Payoff + Guarded Wave Closure
```

The central technical proof is no longer only dialogue selection.

It is:

```text
choice
-> actual image rendering
-> individual unlock
-> gallery persistence
-> route or risk state
-> guarded daily completion
```

---

## 3. Runtime audit conclusions

### Images currently unlock but do not render as photos

Current conversation runtime:

- sees `content_id`;
- displays a metadata placeholder;
- adds the ID to `GameState.unlocked_content`.

It does not display the texture in `asset_path`.

V0.95 must add real texture rendering.

### There is no gallery

Current phone navigation contains Messages, Debug, Speed, and Reset.

V0.95 must add a minimal Gallery that reads existing `unlocked_content` rather than creating another unlock system.

### Chronology can remain adapter-based

Current runtime already injects Monday through `PhonePrototypeV090.gd`.

V0.95–V0.98 will continue this pattern rather than refactoring `DataLoader.gd` globally.

### Existing state systems remain sufficient

```text
TimelineState = chronology
GameState = flags, unlocked content, ledgers
EffectApplier = authored flags and unlocks
```

Only one new small ledger and pure helpers are required.

---

## 4. New runtime components

### Visual day gate

```text
game/scripts/narrative/VisualDayContract.gd
```

Purpose:

- evaluate three required visual slots;
- accept explicit branch alternatives;
- reject duplicate counting;
- return blocking reasons;
- perform no mutation.

### Named-boundaries ledger

```text
story_ledgers.named_boundaries_wave
```

Owns:

```text
primary carry-over source
primary visual route
secondary risk seed
scene lifecycle
obligations
social-hub status
Nico-cycle status
```

It does not duplicate image IDs or first-repetition history.

### Real photo rendering

```text
ConversationViewV095.gd
```

It renders textures from `asset_path`, preserves aspect ratio, supports fallback, and keeps existing thread/history behavior.

### Gallery MVP

```text
PhotoGalleryView.gd
PhotoGalleryView.tscn
```

Initial features:

```text
unlocked photo grid/list
Marie album
full image detail
intensity label
public/private/secret/shared label
locked future Marie slots
return to Messages
```

---

## 5. V0.95 decision

V0.95 implements only Tuesday day 8.

It must include:

```text
3 distinct Marie black-dress assets
actual inline photo rendering
Gallery MVP
M4 action/fantasy choice
one structured obligation
three-slot visual gate
named_boundaries_slice_01_complete
```

V0.95 endpoint:

```text
Tuesday complete
chapter_08 next_day = null
```

V0.96 later unlocks Wednesday.

This deliberately avoids an empty playable day.

V0.95 is not product-lockable if the three photos are missing-file fallbacks or indistinguishable placeholder rectangles.

---

## 6. V0.96 decision

V0.96 implements Wednesday through the guaranteed social set.

It adds:

```text
historical Mathilde/Sandra selector
Mathilde route set or Sandra route set when eligible
three guaranteed Marie/Pauline social images
Mathilde repair date
L'Annexe table deadline / seat incident
one primary visual-route claim maximum
```

Quiet first-wave history remains visually valid because the social set guarantees three images.

Day 9 remains local endpoint until V0.97.

---

## 7. V0.97 decision

V0.97 extends Wednesday with explicit risk opportunities.

Pauline:

```text
public set
-> ask for private alternate
-> Pauline independently sends or withholds
-> primary route or secondary compartment risk
```

Nico:

```text
credible already-unlocked images
-> private erotic selection
-> accept, confront, or refuse
-> one shared-gaze or recontextualization risk maximum
```

Nico does not duplicate image files to inflate the gallery count.

After terminal Pauline/Nico phases, Thursday becomes available.

---

## 8. V0.98 decision

V0.98 implements Thursday.

One dominant female payoff set unlocks:

```text
Marie reconquest
OR Mathilde deliberate domestic access
OR Sandra chosen exposure
OR Pauline double address
```

Each set contains three individually unlockable images.

Marie is the default payoff if no external primary visual route was claimed.

Nico remains a secondary risk modifier.

Raphaëlle may receive an optional teaser but cannot replace the dominant set.

The Marie obligation then resolves as:

```text
PAID
AMENDED
FAILED
```

A pure closure predicate writes only:

```text
named_boundaries_wave_complete
```

Friday remains unavailable.

---

## 9. Visual metadata decision

New optional fields:

```text
visual_family
intensity_tier
visibility
actual_audience
save_rule
forwarding_rule
route_seed
risk_seed
unlock_source
gallery_order
asset_status
```

Player-facing gallery labels translate technical metadata into readable categories.

The runtime must preserve the distinction between:

```text
public
private
secret
shared
unapproved erotic recontextualization
```

---

## 10. Asset lock rule

Prototype assets may validate code.

They do not automatically validate product quality.

Before each visual runtime lock, manually verify:

```text
three visually distinct images
correct woman and outfit
correct route identity
readable body framing at 1280×720
no distortion
correct inline rendering
correct gallery rendering
correct unlock order
```

Metadata without visible reward is not sufficient.

---

## 11. Regression decision

Every V0.95+ runtime milestone must rerun:

```text
V0.90 runtime smoke A–I
V0.92 runtime smoke A–I
current milestone smoke
full static suite
data validation
route simulation
Godot headless boot
1280×720 boot
git diff --check
```

Known `ObjectDB instances leaked at exit` warnings remain separately assessed and are not bundled into this narrative work.

---

## 12. Files created by V0.94

```text
docs/runtime/V0_94_VISUAL_FIRST_NAMED_BOUNDARIES_RUNTIME_INTEGRATION_PLAN.md
docs/V0_94_Visual_First_Named_Boundaries_Runtime_Integration_Plan_Report.md
```

No existing canon doorway or runtime status document is updated before Product Owner validation.

A later documentation-only reconciliation may update:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/characters/CHARACTER_CANON_INDEX.md
```

---

## 13. Explicit exclusions

V0.94 changes no:

- runtime;
- JSON;
- GDScript;
- tests;
- image files;
- active scene;
- save system;
- loader implementation;
- timeline implementation;
- merge or tag.

It does not authorize full V5 intercourse in V0.95.

It does authorize the runtime foundations needed for visible V3/V4 progression.

---

## 14. Product validation checklist

- [ ] Gallery MVP belongs in V0.95.
- [ ] Actual texture rendering belongs in V0.95.
- [ ] V0.95 stops Tuesday locally.
- [ ] Three visual slots gate every new day.
- [ ] Branch alternatives cannot reduce the minimum.
- [ ] One primary visual route is sufficient.
- [ ] One secondary risk is sufficient.
- [ ] Mathilde/Sandra selection remains history-driven.
- [ ] Wednesday social images protect the quiet route.
- [ ] Pauline and Nico risk wait until V0.97.
- [ ] Nico does not create duplicate photo rewards.
- [ ] Thursday has one dominant three-image female payoff.
- [ ] Marie is the default payoff.
- [ ] Raphaëlle is a bonus teaser only.
- [ ] Missing final images block product lock even when code tests pass.
- [ ] Friday remains unavailable.

---

## 15. Final report line

```text
V0.94 turns the V0.93 fantasy promise into an implementable loop:

show the woman,
let Player choose what the image becomes,
keep the image in the gallery,
make the route or risk visible,
and refuse to close the day before the visual reward exists.
```
