# V0.94 — Visual-First Named Boundaries Runtime Integration Plan

> Documentation-first runtime plan for the locked V0.93 visual-first Act I source pack.
> This document authorizes no runtime, JSON, GDScript, test, image asset, merge, or tag change by itself.
> Runtime implementation begins only after Product Owner validation.

## 1. Authority and locked baseline

Repository:

```text
ludowww/reseau-intime
```

Locked baseline:

```text
version: V0.93 — Visual-First Next Act I Wave Source Pack
main / origin/main: d84e07ce4c7a93b8e27b2cda35936e7f0ed9c106
tag: v0.93-visual-first-next-act-i-wave-source-pack
engine: Godot 4.6.x
```

Current playable runtime:

```text
Tuesday day 1
-> Wednesday day 2
-> Thursday day 3
-> Friday day 4
-> Saturday day 5
-> Sunday day 6
-> Monday day 7
```

Current endpoint:

```text
Monday evening
first_repetition_wave_complete = true
chapter_07_modular_index.json next_day = null
```

Read first:

```text
docs/canon/ACT_I_NAMED_BOUNDARIES_WAVE_SOURCE_PACK.md
docs/canon/ACT_I_NAMED_BOUNDARIES_WAVE_SCENE_CARDS.md
docs/canon/ACT_I_NAMED_BOUNDARIES_WAVE_TEMPORAL_DELIVERY_MAP.md
docs/canon/ACT_I_NAMED_BOUNDARIES_VISUAL_ESCALATION_ADDENDUM.md
docs/V0_93_Next_Act_I_Wave_Source_Pack_Report.md
docs/V0_93_Visual_First_Pornographic_Reorientation_Report.md
```

V0.93 is the product and narrative authority.

V0.94 decides the smallest safe runtime sequence that can prove its visual-first loop.

---

## 2. Product/runtime decision

The implementation sequence is:

```text
V0.95 — Tuesday Marie Visual Opening + Gallery MVP
V0.96 — Wednesday Carry-Over Route + Guaranteed Social Set
V0.97 — Pauline/Nico Visual Risk Continuation
V0.98 — Thursday Dominant Payoff + Guarded Wave Closure
```

The implementation must prove:

```text
messages create anticipation
-> images render as actual photos
-> images unlock individually
-> gallery preserves them
-> choices visibly change visual access
-> one primary route and one secondary risk remain bounded
-> day closure rejects an incomplete visual minimum
```

The first implementation must not add all three days at once.

The first runtime proof is V0.95 only.

---

## 3. Hard implementation invariants

### 3.1 Daily image minimum

Every new playable day requires:

```text
3 distinct female-focused image unlocks minimum
```

A day may not complete until its visual contract is satisfied.

A branch may change which image fills a visual slot.

A branch may not reduce the day below three images.

### 3.2 Individual gallery entries

Each frame is one visual-content item with one stable content ID.

A three-photo set must therefore contain three items.

Do not count:

- one composite containing three thumbnails;
- a decor image;
- an object without a woman;
- a metadata-only card;
- a duplicate asset registered under several IDs.

### 3.3 One primary visual route

The new wave may claim at most one:

```text
primary_visual_route
```

Current possible values:

```text
""
marie_reconquest
mathilde_deliberate_visual
sandra_chosen_exposure
pauline_double_address
```

Nico is not a female visual-payoff owner.

Nico writes a secondary risk seed.

Raphaëlle remains a teaser and does not claim the V0.93 dominant payoff.

### 3.4 One secondary risk

The wave may claim at most one:

```text
secondary_risk_seed
```

Current values:

```text
""
pauline_private_compartment_risk
nico_unapproved_recontextualization_risk
nico_shared_gaze_opportunity
```

A clean Marie, Mathilde, Sandra, or Pauline primary route may coexist with one secondary risk.

### 3.5 Historical state is immutable

Do not reset, compact, transfer, or rewrite:

```text
story_ledgers.first_repetition
```

The new wave may read:

- historical foreground characters;
- historical scene statuses;
- Mathilde charged owner;
- Marie evidence.

It writes into a new ledger.

### 3.6 No automatic route consent

Visual access and erotic escalation remain authored route facts.

The runtime must distinguish:

```text
public image
private chosen image
secret image
shared-gaze image
unapproved erotic recontextualization
```

Do not represent all five states with one generic `unlocked` flag.

The image metadata and route flags preserve the difference.

---

## 4. Current runtime audit

## 4.1 Data loading

`DataLoader.gd` currently loads active chapter indexes day 1 through day 6 directly.

Day 7 is injected by `PhonePrototypeV090.gd` through:

```text
MONDAY_INDEX_PATH
_ensure_v090_chapter_loaded()
```

The V0.95–V0.98 plan continues the adapter-local loading pattern.

Reason:

- it avoids a broad loader refactor;
- it preserves current static-foundation tests;
- each milestone adds only the day and visual bundles it owns;
- a later cleanup may normalize the active arrays after the full wave is locked.

V0.95 should not rewrite the loader architecture merely to add Tuesday.

## 4.2 Timeline ownership

`TimelineState.gd` already owns:

```text
unlocked and completed days
current phase by day
completed and skipped phases
expired conversations
completed episodes
optional-opened state
internal day logs
```

It remains chronology owner.

It must not own:

- image-route identity;
- visual audience;
- route-risk meaning;
- new-wave obligations.

## 4.3 Narrative state ownership

`GameState.gd` already owns:

```text
flags
unlocked_content
story_ledgers
context
reset state
```

It is the correct owner for:

- the new named-boundaries ledger;
- primary visual route;
- secondary risk seed;
- structured obligations;
- gallery unlock IDs through existing `unlocked_content`.

## 4.4 Choice and unlock application

`EffectApplier.gd` already applies:

```text
sets_flags
unlocks_content
```

No arbitrary nested-ledger mutation language should be added.

Authored choices continue to write flat facts and image unlocks.

Adapter code interprets those facts into the small structured ledger only when required.

## 4.5 Current image rendering gap

`ConversationView.gd` currently:

- reads `content_id`;
- creates a metadata placeholder card;
- shows content ID, tags, and risk;
- adds the item to `GameState.unlocked_content`.

It does not render the texture from `asset_path`.

This is incompatible with a visual-first product lock.

V0.95 must add actual texture rendering with fallback behavior.

## 4.6 Current gallery gap

The phone navigation currently contains:

```text
Messages
Debug
Speed
Reset
```

There is no gallery view.

`unlocked_content` exists, but the player cannot browse unlocked photos as a collection.

V0.95 must add a Gallery MVP.

---

## 5. Visual-content metadata contract

Existing fields remain valid:

```text
id
character
tier
type
source_app
asset_path
context
tags
is_proof
risk_level
can_delete
can_capture
can_set_as_wallpaper
can_be_discovered_by
origin
intended_audience
```

V0.95 adds optional visual-first metadata:

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

Recommended values:

### `intensity_tier`

```text
V1_ELEGANT
V2_SEXY
V3_PROVOCATIVE
V4_EROTIC
V5_PORNOGRAPHIC
```

### `visibility`

```text
PUBLIC
PRIVATE
SECRET
SHARED
RISK_RECONTEXTUALIZED
```

### `save_rule`

```text
ALLOWED
DISALLOWED
CONDITIONAL
NOT_YET_DECIDED
```

### `forwarding_rule`

```text
ALLOWED_NAMED_AUDIENCE
DISALLOWED
CONDITIONAL
UNAPPROVED
```

### `asset_status`

```text
PROTOTYPE
REVIEW
FINAL
```

The runtime displays only player-facing labels.

It does not expose raw metadata keys.

---

## 6. Daily visual-contract schema

Each new chapter index includes one small data block:

```json
"daily_visual_contract": {
  "minimum_unlocks": 3,
  "slots": [
    {
      "id": "slot_01",
      "any_content_ids": ["content_a"]
    },
    {
      "id": "slot_02",
      "any_content_ids": ["content_b", "content_b_alt"]
    },
    {
      "id": "slot_03",
      "any_content_ids": ["content_c"]
    }
  ]
}
```

Rules:

- each slot requires at least one unlocked content ID;
- the number of satisfied slots must be at least `minimum_unlocks`;
- duplicate content IDs cannot satisfy several slots;
- unknown content IDs fail validation;
- non-photo content cannot satisfy a visual slot;
- route alternatives are listed explicitly in `any_content_ids`;
- no generic expression language is added.

A small pure helper should evaluate the contract:

```text
game/scripts/narrative/VisualDayContract.gd
```

Suggested API:

```gdscript
evaluate(contract: Dictionary, unlocked_content: Array, visual_by_id: Dictionary) -> Dictionary
```

Return:

```text
satisfied
satisfied_slot_ids
missing_slot_ids
counted_content_ids
blocking_reasons
```

The helper has no autoload access and performs no mutation.

---

## 7. New named-boundaries ledger

Add to `GameState.gd`:

```text
NAMED_BOUNDARIES_LEDGER_ID := "named_boundaries_wave"
```

Defaults:

```json
{
  "window_ordinal": 0,
  "primary_carryover_source": "",
  "primary_visual_route": "",
  "secondary_risk_seed": "",
  "scene_status": {},
  "obligations": {},
  "social_hub_status": "",
  "nico_cycle_status": ""
}
```

Do not duplicate:

- unlocked image IDs;
- image metadata;
- first-repetition foreground history;
- Mathilde charged owner.

Those remain owned by `unlocked_content`, visual data, and `first_repetition`.

### 7.1 Primary route claim

A primary route may be claimed only when empty.

Claim priority is chronological, not numerical:

```text
Mathilde charged visual choice
or Sandra chosen-extra-image choice
or Pauline chosen private alternate
or Marie default reconquest at Thursday payoff
```

The runtime does not add route points.

The first valid authored primary claim wins.

If no external visual route claims primary access by Thursday:

```text
primary_visual_route = marie_reconquest
```

provided the Marie return remains playable.

### 7.2 Secondary risk claim

The first valid authored risk claim wins.

A second risk opportunity may still appear as dialogue but cannot write another active risk seed in this wave.

The response must remain honest:

- it may be declined;
- it may become a non-persistent flirt;
- it may be deferred;
- it may not silently overwrite the first risk.

---

## 8. Actual image rendering

Create:

```text
game/scripts/ui/ConversationViewV095.gd
```

It extends:

```text
ConversationViewV086A.gd
```

Update:

```text
game/scenes/smartphone/ConversationView.tscn
```

The adapter overrides the visual-card rendering path.

Required behavior:

1. resolve content metadata through `DataLoader.get_visual_content(content_id)`;
2. read `asset_path`;
3. load the texture when it exists;
4. render a bounded `TextureRect` preserving aspect ratio;
5. show a concise image caption or visibility badge when authored;
6. add the content ID to `GameState.unlocked_content` exactly once;
7. preserve history and restore behavior;
8. fall back to the existing metadata placeholder when the file is missing or invalid;
9. never crash because an art asset is absent;
10. never count a fallback placeholder as product-validated photography.

The fallback is a technical safety net.

It is not an acceptable final V0.95 visual QA result.

### 8.1 Image dimensions

Recommended message image area at 1280×720:

```text
minimum visible width: 300 px
maximum visible width: 520 px
maximum visible height: 420 px
```

The player must be able to distinguish body framing and visual progression without opening the gallery.

### 8.2 Full-view action

Clicking or activating an image should open the same content in the Gallery detail view.

Keyboard activation must work.

No native tooltip is required.

---

## 9. Gallery MVP

Create:

```text
game/scenes/smartphone/PhotoGalleryView.tscn
game/scripts/ui/PhotoGalleryView.gd
```

V0.95 Gallery MVP requirements:

```text
Gallery navigation button
unlocked-photo list or grid
character name
thumbnail
intensity label in player-facing language
public / private / secret / shared label
full image detail
back to messages
locked future slots for Marie only
```

The gallery reads:

```text
GameState.current_state.unlocked_content
DataLoader.visual_content_by_id
```

It does not maintain a second unlock list.

### 9.1 Player-facing labels

Examples:

```text
Élégante
Sexy
Provocante
Érotique
Pornographique

Publique
Privée
Secrète
Partagée
À risque
```

Do not show:

```text
V3_PROVOCATIVE
RISK_RECONTEXTUALIZED
route_seed
risk_seed
```

### 9.2 Locked future slots

V0.95 should show a small Marie progression hint:

```text
Robe noire
Suite privée
Lingerie
Reconnexion adulte
```

Only the first set is unlockable in V0.95.

Locked slots communicate future reward without exposing exact technical conditions.

Do not build every character album in V0.95.

The Gallery MVP expands by milestone.

### 9.3 Phone integration

`PhonePrototypeV095.gd` adds a `Galerie` navigation action.

It may reuse the existing right-hand content area:

```text
Messages selected -> ConversationView visible
Gallery selected -> PhotoGalleryView visible
```

The left phone shell remains unchanged beyond one navigation button.

No full smartphone redesign is planned.

---

## 10. V0.95 — Tuesday Marie Visual Opening + Gallery MVP

## 10.1 Runtime boundary

V0.95 implements only day 8.

It ends Tuesday with:

```text
named_boundaries_slice_01_complete = true
chapter_08_modular_index.json next_day = null
```

V0.96 later changes day 8 `next_day` to 9.

This avoids unlocking an empty Wednesday.

### 10.2 Day loading

Create:

```text
game/scripts/ui/PhonePrototypeV095.gd
```

It extends:

```text
PhonePrototypeV092.gd
```

It ensures loaded:

```text
chapter_08_modular_index.json
chapter_08 visual bundle
```

Modify:

```text
chapter_07_modular_index.json next_day: null -> 8
```

The V0.95 adapter must already be loaded before the day-7 completion path resolves.

The day-8 index remains endpoint-local with `next_day = null`.

### 10.3 Tuesday files

Expected new data files:

```text
game/data/conversations/chapter_08_modular_index.json
game/data/conversations/chapter_08_marie_black_dress.json
game/data/visual_content/chapter_08_named_boundaries_visuals.json
```

Expected image assets:

```text
game/assets/visual_content/v0_95/marie_tuesday_black_dress_mirror_01.png
game/assets/visual_content/v0_95/marie_tuesday_black_dress_turn_02.png
game/assets/visual_content/v0_95/marie_tuesday_black_dress_close_03.png
```

Optional fourth variant:

```text
marie_tuesday_selected_look_04.png
```

### 10.4 Tuesday phase order

```text
tuesday_marie_black_dress_open
tuesday_marie_black_dress_turn
tuesday_marie_real_plan_choice
tuesday_visual_contract_close
tuesday_named_boundaries_slice_close
```

The first three phases may live in one persistent Marie conversation split into segments.

### 10.5 M4 choices

Exactly three actions:

```text
M4A join Marie at La Verrière and leave with her
M4B take responsibility for the L'Annexe table and commit to arrival
M4C reserve Thursday private couple continuation
```

Each choice writes:

- one topology flag;
- one structured obligation;
- one visual-interest fact;
- optional fourth-image unlock;
- no immediate adult permission.

### 10.6 Tuesday visual gate

The daily contract requires:

```text
marie_tuesday_black_dress_mirror_01
marie_tuesday_black_dress_turn_02
marie_tuesday_black_dress_close_03
```

The day-completion adapter must call `VisualDayContract.evaluate()`.

If blocked:

- day remains active;
- a developer error is logged;
- no visible technical warning is shown to the player;
- no later day unlocks.

### 10.7 V0.95 static tests

Create:

```text
tests/test_v095_marie_visual_opening_static.py
```

Required assertions:

- day 7 points to day 8;
- day 8 is loaded by V095 adapter;
- day 8 ends locally;
- exactly three M4 choices;
- M4 choices are action/fantasy distinct;
- three required image IDs exist;
- three image asset paths are distinct;
- each item has one female character and visual metadata;
- visual contract has three slots;
- no decor item satisfies a slot;
- Gallery scene and script exist;
- ConversationView scene uses V095 adapter;
- Phone scene uses V095 adapter;
- first-repetition ledger is not reset;
- Friday/day9 is unavailable.

### 10.8 V0.95 runtime smoke

Create:

```text
game/tests/V095RuntimeSmokeScenarioDriver.gd
game/tests/V095RuntimeSmokeTest.tscn
tools/test_v095_runtime_smoke.sh
```

Scenarios:

```text
A — M4A: three images unlock, obligation scheduled, day closable
B — M4B: three images unlock, table obligation scheduled
C — M4C: three images unlock, Thursday obligation scheduled
D — gallery contains exactly the unlocked Tuesday images
E — missing visual slot blocks day completion
F — duplicate unlock does not count twice
G — missing texture falls back without crash but fails product-asset assertion
H — reset clears Tuesday unlocks and new ledger
I — first-repetition ledger remains unchanged
```

The smoke may use prototype assets.

Product lock additionally requires manual visual QA with actual distinct images.

---

## 11. V0.96 — Wednesday Carry-Over Route + Guaranteed Social Set

## 11.1 Runtime boundary

V0.96 adds day 9 through the end of the base L'Annexe social set.

It changes:

```text
chapter_08_modular_index.json next_day: null -> 9
```

Day 9 remains local endpoint:

```text
next_day = null
```

V0.97 later extends day 9 with Pauline/Nico risk phases.

## 11.2 Data files

Expected new files:

```text
game/data/conversations/chapter_09_modular_index.json
game/data/conversations/chapter_09_mathilde_visual_boundary.json
game/data/conversations/chapter_09_sandra_visual_boundary.json
game/data/conversations/chapter_09_marie_pauline_social_set.json
game/data/visual_content/chapter_09_named_boundaries_visuals.json
game/scripts/narrative/NamedBoundariesSelector.gd
game/scripts/ui/PhonePrototypeV096.gd
```

The existing legacy `chapter_09_index.json` remains legacy.

The new active file name must be `chapter_09_modular_index.json` and must not reuse inactive legacy content by inheritance.

## 11.3 Carry-over selector

Pure helper:

```text
select_carryover(first_repetition_ledger: Dictionary, flags: Array) -> Dictionary
```

Priority:

```text
Mathilde charged owner
-> Mathilde

else most recent resolved external foreground = Sandra
-> Sandra

else resolved Mathilde
-> Mathilde

else
-> none
```

Return:

```text
selected_character
selected_scene_id
blocking_reasons
```

No mutation.

## 11.4 Wednesday guaranteed images

Always unlock:

```text
marie_wednesday_lannexe_social_01
pauline_wednesday_green_dress_02
marie_pauline_wednesday_duo_03
```

These satisfy the daily minimum even when the carry-over route is absent.

## 11.5 Mathilde route set

Potential items:

```text
mathilde_wednesday_homewear_mirror_01
mathilde_wednesday_outfit_choice_02
mathilde_wednesday_deliberate_pose_03
mathilde_wednesday_deliberate_pose_cold_alt_03
```

Choice results:

```text
encourage deliberate provocation
-> third provocative image
-> claim primary route if empty

distance
-> composed alternate image
-> no primary claim

deny
-> colder public alternate
-> access cooled
```

A denial does not remove Wednesday's three guaranteed social images.

## 11.6 Sandra route set

Potential items:

```text
sandra_wednesday_fitted_outfit_01
sandra_wednesday_mirror_hesitation_02
sandra_wednesday_private_extra_03
sandra_wednesday_composed_close_alt_03
```

Choice results:

```text
ask for real meeting / extra image
-> private extra
-> claim primary route if empty

preserve rare contact
-> composed private-but-bounded alternate

minimize
-> cooler closing image or no route bonus beyond guaranteed social set
```

## 11.7 Concrete world changes

Mathilde branch must include:

```text
repair date received
end of temporary stay becomes visible
```

Social hub must include:

```text
good table held until 20:45
one seat miscounted
Bastien already ordered
```

These are runtime facts, not only documentation notes.

## 11.8 V0.96 smoke matrix

```text
A — no carry-over, social 3 unlock, day closable
B — Mathilde owner selects Mathilde
C — Sandra most recent selects Sandra
D — both resolved + Mathilde owner selects Mathilde
E — Mathilde charged choice claims primary
F — Sandra extra-image choice claims primary
G — existing primary blocks second primary overwrite
H — social image slot alternatives remain valid
I — first-repetition ledger unchanged
```

---

## 12. V0.97 — Pauline/Nico Visual Risk Continuation

## 12.1 Runtime boundary

V0.97 extends the existing Wednesday day 9 after the social set.

It adds:

```text
Pauline private-alternate opportunity
Nico quiet-truth / image-risk opportunity
Wednesday risk close
```

It then changes:

```text
chapter_09_modular_index.json next_day: null -> 10
```

## 12.2 Pauline opportunity

Pauline may offer or withhold:

```text
pauline_wednesday_private_crop_04
pauline_wednesday_double_address_05
```

The opportunity exists only through authored social context.

Three choices:

```text
keep public set public
ask whether another version exists
refuse a private compartment
```

If Player asks and Pauline independently sends:

- claim `pauline_double_address` as primary only if primary is empty;
- otherwise the moment may become `pauline_private_compartment_risk` if secondary risk is empty;
- no overwrite occurs;
- Bastien remains uninformed, which is risk, not consent.

## 12.3 Nico risk opportunity

Nico uses credible already-unlocked images.

He does not create a magical archive.

Three choices:

```text
force Nico to name his own desire
accept a sexualized selection
forbid women becoming currency between them
```

Possible writes:

```text
nico_desire_named
nico_unapproved_recontextualization_risk
nico_shared_gaze_opportunity
nico_gaze_boundary_set
```

Nico does not claim the female primary route.

He may claim one secondary risk seed.

## 12.4 Recontextualization representation

Do not duplicate the original image file merely to count another photo.

The gallery may display a risk badge or separate contextual record linked to the original content ID.

The underlying image remains one image.

V0.97 does not inflate the daily minimum through duplicate registrations.

## 12.5 V0.97 smoke matrix

```text
A — keep public blocks private Pauline unlock
B — ask + Pauline sends private crop
C — Pauline primary claim when empty
D — Pauline becomes secondary risk when another primary exists
E — Nico sexualized selection claims first secondary risk
F — second risk cannot overwrite
G — Nico boundary creates no risk
H — images used by Nico already exist and have credible origin
I — day 10 unlocks only after risk phases terminal
```

---

## 13. V0.98 — Thursday Dominant Payoff + Guarded Closure

## 13.1 Runtime boundary

V0.98 adds day 10 and closes the named-boundaries wave.

Day 10 remains endpoint:

```text
next_day = null
```

## 13.2 Dominant route selection

Pure selector function:

```text
select_thursday_payoff(named_ledger: Dictionary, flags: Array) -> Dictionary
```

Priority:

```text
primary_visual_route if valid
else marie_reconquest
```

No random selection.

No numeric affinity comparison.

## 13.3 Route payoff sets

### Marie

```text
marie_thursday_private_dress_01
marie_thursday_lingerie_tease_02
marie_thursday_reconquest_private_03
```

### Mathilde

```text
mathilde_thursday_private_homewear_01
mathilde_thursday_underwear_choice_02
mathilde_thursday_for_your_eyes_03
```

### Sandra

```text
sandra_thursday_evening_dress_01
sandra_thursday_satin_private_02
sandra_thursday_chosen_exposure_03
```

### Pauline

```text
pauline_thursday_public_green_dress_01
pauline_thursday_private_crop_02
pauline_thursday_double_address_03
```

Each set has three individually unlockable items.

Only one main set unlocks per run.

## 13.4 Raphaëlle teaser

Optional bonus set:

```text
raphaelle_thursday_office_full_01
raphaelle_thursday_workshop_fit_02
raphaelle_thursday_partial_costume_03
```

The teaser:

- does not claim primary route;
- does not replace the dominant three-photo set;
- does not delay Marie consequence;
- must lead to a later dedicated Raphaëlle wave within a reasonable roadmap.

## 13.5 Marie consequence

After the visual payoff, the M4 obligation resolves:

```text
PAID
AMENDED
FAILED
```

Marie remains active in every outcome.

A failed promise does not remove the already-earned route payoff retroactively.

It changes future consequence and couple evidence.

## 13.6 Guarded closure

Create pure helper:

```text
game/scripts/narrative/NamedBoundariesClosure.gd
```

Closure requires:

```text
first_repetition_wave_complete
named_boundaries_slice_01_complete
Wednesday base slice complete
Wednesday risk slice complete
M4 obligation terminal
carry-over scene terminal or absent
social hub terminal
Nico cycle terminal or explicitly deferred
primary visual route valid or Marie fallback valid
secondary risk count <= 1
Thursday daily visual contract satisfied
Marie consequence terminal
```

Allowed obligation terminal states:

```text
PAID
AMENDED
FAILED
```

Closure writes only:

```text
named_boundaries_wave_complete
```

It preserves:

- first-repetition ledger;
- named-boundaries ledger;
- primary route;
- secondary risk;
- image unlock history;
- route-specific visibility metadata.

## 13.7 V0.98 smoke matrix

```text
A — Marie default payoff
B — Mathilde payoff
C — Sandra payoff
D — Pauline payoff
E — Nico risk + Marie primary coexist
F — Raphaëlle teaser does not replace primary set
G — missing one Thursday slot blocks closure
H — unresolved obligation blocks closure
I — repeated closure is idempotent
J — Friday remains unavailable
```

---

## 14. Planned file scope by milestone

## 14.1 V0.95 expected new files

```text
game/data/conversations/chapter_08_modular_index.json
game/data/conversations/chapter_08_marie_black_dress.json
game/data/visual_content/chapter_08_named_boundaries_visuals.json
game/scripts/narrative/VisualDayContract.gd
game/scripts/ui/ConversationViewV095.gd
game/scripts/ui/PhonePrototypeV095.gd
game/scripts/ui/PhotoGalleryView.gd
game/scenes/smartphone/PhotoGalleryView.tscn
game/tests/V095RuntimeSmokeScenarioDriver.gd
game/tests/V095RuntimeSmokeTest.tscn
tests/test_v095_marie_visual_opening_static.py
tools/test_v095_runtime_smoke.sh
three or four Marie image assets
```

Expected modified files:

```text
game/data/conversations/chapter_07_modular_index.json
game/data/state/initial_state.json
game/scripts/core/GameState.gd
game/scenes/smartphone/ConversationView.tscn
game/scenes/smartphone/PhonePrototype.tscn
```

A change to `DataLoader.gd`, `TimelineState.gd`, or `EffectApplier.gd` requires explicit justification.

## 14.2 V0.96 expected scope

```text
chapter_08 next-day handoff
chapter_09 modular index
Mathilde/Sandra/social conversations
chapter_09 visual bundle
NamedBoundariesSelector.gd
PhonePrototypeV096.gd
V096 static and smoke tests
social + Mathilde + Sandra asset families
```

## 14.3 V0.97 expected scope

```text
chapter_09 Pauline/Nico continuation episodes
Pauline private visual variants
PhonePrototypeV097.gd
V097 static and smoke tests
no new base gallery architecture
```

## 14.4 V0.98 expected scope

```text
chapter_10 modular index
Thursday payoff conversations
chapter_10 visual bundle
NamedBoundariesClosure.gd
PhonePrototypeV098.gd
V098 static and smoke tests
Marie/Mathilde/Sandra/Pauline payoff assets
optional Raphaëlle teaser assets
```

---

## 15. Asset-production boundary

Code can be validated with prototype assets.

A visual milestone cannot be product-locked solely with colored rectangles or metadata cards.

Each milestone requires manual image QA:

```text
woman clearly recognizable
outfit and framing match character identity
three images are visibly distinct
image order shows progression
no accidental duplicate
no unreadable crop at 1280×720
no aspect-ratio distortion
correct gallery character and intensity labels
```

V0.95 lock requirement:

```text
three distinct Marie black-dress images visible inline and in Gallery
```

V0.96 lock requirement:

```text
three distinct social images
plus route-set assets for every implemented carry-over branch
```

V0.98 lock requirement:

```text
three distinct assets for every implemented dominant payoff family
```

Do not lock a route whose metadata exists but whose promised visual reward is only a missing-file fallback.

---

## 16. Backward-compatibility contract

The new adapters must preserve:

- persistent threads;
- no repeated messages;
- no mixed histories between contacts;
- same-thread continuation;
- cross-thread notification behavior;
- accelerated clock;
- archived days read-only;
- explicit Player messages;
- no visible offline exposition;
- V0.90 smoke behavior;
- V0.92 closure behavior;
- current reset behavior.

Required regression runs after each runtime slice:

```text
bash tools/test_v090_runtime_smoke.sh
bash tools/test_v092_runtime_smoke.sh
```

V0.95 onward must add the current milestone smoke.

---

## 17. Validation strategy

Each implementation milestone runs:

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest <milestone static tests> -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
bash tools/test_v090_runtime_smoke.sh
bash tools/test_v092_runtime_smoke.sh
bash tools/test_<milestone>_runtime_smoke.sh
```

Additional visual static checks:

- asset path exists;
- each slot references a known content ID;
- no duplicate asset path within one set;
- daily minimum equals at least three;
- every counted item has one principal woman;
- intensity tier is valid;
- visibility is valid;
- gallery order is unique within one visual family;
- route alternatives do not leave an empty slot.

Manual QA remains mandatory.

---

## 18. Explicit non-goals

V0.94 does not authorize:

- runtime changes;
- JSON changes;
- image generation or final art creation;
- a complete gallery redesign;
- video content;
- animation inside photos;
- explicit V5 sex in V0.95;
- all character routes in one playthrough;
- numeric affection scoring;
- a random scheduler;
- a general nested-state scripting language;
- a save-system rewrite;
- a global DataLoader refactor;
- a global TimelineState refactor;
- ObjectDB leak cleanup;
- Friday/day11 content;
- merge, tag, or lock.

---

## 19. Product validation checklist

- [ ] V0.95 includes Gallery MVP, not only inline placeholders.
- [ ] V0.95 renders actual textures from `asset_path`.
- [ ] Tuesday cannot complete below three unlocked images.
- [ ] Visual slots support branch alternatives without a generic DSL.
- [ ] A new named-boundaries ledger is separate from first repetition.
- [ ] One primary route and one secondary risk are enforced.
- [ ] V0.95 ends locally on Tuesday rather than unlocking empty Wednesday.
- [ ] V0.96 guarantees three social images on quiet history.
- [ ] Mathilde and Sandra have distinct route-set behavior.
- [ ] Pauline private access and Nico risk are added only in V0.97.
- [ ] Nico recontextualization does not duplicate assets to inflate counts.
- [ ] Thursday selects one dominant female route set.
- [ ] Raphaëlle teaser cannot replace the dominant set.
- [ ] Closure checks the Thursday visual contract.
- [ ] Friday remains unavailable.
- [ ] Every implemented route has actual visual assets before lock.
- [ ] V0.90 and V0.92 smokes remain mandatory regressions.

---

## 20. Final implementation rule

```text
V0.95 proves that a message choice can unlock a real photo,
that the photo remains in a gallery,
and that a day cannot close before the visual reward exists.

V0.96 proves that history selects a distinct woman and fantasy.
V0.97 proves that visual access can become risky.
V0.98 proves that one chosen route receives a dominant erotic payoff
and that the wave closes without losing its history.

Do not implement the pornography as metadata only.
The visual reward must be visible, distinct, persistent, and route-specific.
```
