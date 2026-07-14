# Act I Named Boundaries Wave Temporal Delivery Map — V0.93

> Reconciled delivery map for the visual-first V0.93 wave.
> Defines chronology, photo cadence, scene ordering, expiry, gallery unlocks, and closure.
> Documentation only: no runtime, JSON, tests, or final assets are created here.

## 1. Entry and endpoint

Entry:

```text
Monday evening complete
first_repetition_wave_complete = true
```

Calendar:

```text
day 8 = Tuesday
day 9 = Wednesday
day 10 = Thursday
```

Endpoint:

```text
Thursday evening
named_boundaries_wave_complete
next_day = null
```

No later Friday unlock is authorized in V0.93.

---

## 2. Daily visual rule

Every active day must unlock at least:

```text
3 female-focused gallery images
```

Budget:

```text
Tuesday: 3 guaranteed Marie images + 0–1 bonus
Wednesday: 3 guaranteed social images + optional 3-image Mathilde or Sandra set
Thursday: 3 guaranteed dominant route-payoff images + optional Raphaëlle teaser
```

V0.93 minimum:

```text
9 images
```

Target:

```text
12–18 with route variants
```

No day completion may occur before its minimum three unlocks are terminally resolved.

`terminally resolved` means:

- unlocked;
- or replaced by a validated branch-specific image from the same daily visual budget.

A photo cannot silently disappear because Player chose a less erotic branch. The route may change which image unlocks, but the daily minimum remains.

---

## 3. Global delivery rules

### Persistent threads

Use existing character threads.

Do not create a new thread for each week or image set.

### Manual Player messages

Every Player message remains choice-driven.

No automatic Player compliment, request, apology, or sexual escalation.

### Image timing

A visual set should be delivered as:

```text
image
short reaction
image
choice or hesitation
image / conditional image
```

Do not dump all images before the player can react unless the set itself is intentionally presented as a gallery selection.

### Co-present action

La Verrière, L'Annexe, dinner, walks, and shared-room scenes remain mostly off-phone.

Use phone delivery only for:

- setup;
- photo sending;
- logistics;
- delayed private follow-up;
- route-specific visual unlock.

### Silent internal phases

Silent phases may:

- select a route;
- schedule obligations;
- unlock a gallery set;
- close the wave.

They may not create visible exposition about state systems.

---

# 4. Day 8 — Tuesday visual opening

## 4.1 Day start

Recommended time:

```text
18:05
```

Marie is at home or in a private changing space after work.

She is preparing Wednesday's black-dress look.

## 4.2 Phase D8-1 — Marie image 1

Recommended phase id:

```text
tuesday_marie_black_dress_open
```

Time:

```text
18:05
```

Unlock:

```text
marie_tuesday_black_dress_mirror_01
```

Delivery:

```text
Marie sends the full-body mirror image.
One short line asks for a real reaction.
```

## 4.3 Phase D8-2 — Marie image 2

Recommended phase id:

```text
tuesday_marie_black_dress_turn
```

Time:

```text
18:07
```

Unlock:

```text
marie_tuesday_black_dress_turn_02
```

Delivery:

- Marie rejects a neutral `both are nice` answer;
- the second image visibly emphasizes another part of the fantasy;
- the player understands that Marie is actively presenting herself.

## 4.4 Phase D8-3 — Marie image 3 and M4

Recommended phase id:

```text
tuesday_marie_real_plan_choice
```

Time:

```text
18:09–18:14
```

Unlock before or inside M4:

```text
marie_tuesday_black_dress_close_03
```

The M4 node follows immediately.

Possible bonus:

```text
marie_tuesday_selected_look_04
```

The bonus depends on M4 but is not needed for the daily minimum.

## 4.5 Tuesday obligation results

### M4A

```text
Wednesday La Verrière presence scheduled
```

### M4B

```text
L'Annexe table responsibility + 20:45 arrival scheduled
```

### M4C

```text
Thursday private couple continuation scheduled
```

## 4.6 Tuesday close

Requirements:

```text
3 Marie images unlocked
M4 resolved
one obligation scheduled
Wednesday unlocked
```

No other Tuesday route foreground.

---

# 5. Day 9 — Wednesday carry-over route

## 5.1 Route selection

Recommended phase id:

```text
wednesday_carryover_visual_route_select
```

Selection order:

```text
urgent aftermath
-> Mathilde charged owner
-> most recent resolved historical foreground
-> earlier resolved historical foreground
-> none
```

Outputs:

```text
mathilde route set
sandra route set
none
```

The selection remains invisible to the player.

## 5.2 Mathilde route delivery

Preferred time:

```text
08:05–08:22
```

Recommended phases:

```text
wednesday_mathilde_repair_date
wednesday_mathilde_image_01
wednesday_mathilde_image_02
wednesday_mathilde_mt2
wednesday_mathilde_image_03_resolution
```

Sequence:

1. Mathilde receives the repair date;
2. image 1: fitted homewear mirror;
3. practical outfit discussion;
4. image 2: going-out look;
5. MT2 choice;
6. image 3 unlocks privately, remains public-only, or is withheld according to choice.

Daily route-set guarantee when Mathilde is selected:

```text
3 Mathilde gallery slots resolve
```

If MT2B or MT2C blocks the private image, the third resolved slot becomes:

```text
mathilde_wednesday_public_final_03
```

This preserves the three-image daily minimum without pretending the erotic route advanced.

## 5.3 Sandra route delivery

Preferred time:

```text
12:35–12:58
```

Alternative:

```text
18:05 after end of post
```

Recommended phases:

```text
wednesday_sandra_trace_open
wednesday_sandra_image_01
wednesday_sandra_image_02
wednesday_sandra_s3
wednesday_sandra_image_03_resolution
```

Sequence:

1. concrete café or outfit trigger;
2. image 1: safe elegant frame;
3. Sandra minimizes;
4. image 2: mirror hesitation;
5. S3 choice;
6. image 3 private extra or a safer withheld/public replacement.

If the route cools, the third resolved slot can be:

```text
sandra_wednesday_safe_final_03
```

The gallery still shows a visual progression but not private access.

## 5.4 Quiet historical path

No private Mathilde or Sandra scene is created.

Wednesday's required three photos still arrive through the social hub.

---

# 6. Day 9 — Wednesday La Verrière and L'Annexe

## 6.1 La Verrière payment phase

Recommended time:

```text
18:35–19:15
```

### M4A

Player arrives before closing.

Obligation:

```text
PAID or FAILED
```

### M4B

Player handles the table and later arrival.

The table must be confirmed before Nico's deadline.

### M4C

Player is not expected.

Marie remains free to move without him.

## 6.2 Social-hub incident

Recommended phase id:

```text
wednesday_lannexe_visual_hub
```

Time:

```text
19:40–22:45
```

Incident:

```text
Nico holds the good table until 20:45.
A late booking is waiting.
Pauline counted one seat too few.
Bastien has ordered food before everyone is seated.
```

Player's action changes the physical situation.

## 6.3 Guaranteed social images

Recommended delivery:

### Image 1

```text
marie_wednesday_lannexe_social_01
```

Time:

```text
20:05
```

Marie appears sexy, active, and socially at ease.

### Image 2

```text
pauline_wednesday_green_dress_02
```

Time:

```text
20:12
```

Pauline appears controlled, elegant, and body-conscious.

### Image 3

```text
marie_pauline_wednesday_duo_03
```

Time:

```text
20:18
```

The duo image creates comparison and route fantasy.

All three have a legitimate public/social origin.

## 6.4 M4B deadline

```text
amendment deadline = 20:15
arrival target = 20:45
```

Outcomes:

```text
PAID
AMENDED
FAILED
```

If Player misses without accepted amendment:

- the table may be released;
- Marie continues;
- no frozen waiting scene;
- Thursday consequence sharpens.

## 6.5 Pauline P2 follow-up

Recommended time:

```text
22:48–23:05
```

Delivery:

```text
REMOTE_ASYNC after the group images exist
```

P2 choice decides:

```text
public version only
private alternate opportunity
private compartment refused
```

No private Pauline crop unlocks before Pauline independently chooses to send it.

---

# 7. W17 — Nico desire and image selection

## 7.1 Attended path

Preferred time:

```text
23:10–23:30 Wednesday
```

Delivery:

```text
brief co-present exchange after the room thins
or short remote follow-up after Player leaves
```

Only one delivery variant per run.

## 7.2 Absent path

Preferred time:

```text
11:45 Thursday
```

Nico may mention:

- the empty seat;
- the public images;
- which frame he looked at twice;
- Player's choice to stay away.

He may not invent private knowledge.

## 7.3 N2 selection outcomes

### N2A

```text
Nico desire named
no private selection yet
```

### N2B

```text
private erotic selection created
secondary risk seed = nico_recontextualization
```

Gallery overlay:

```text
nico_selection_marie_social_01
nico_selection_pauline_social_02
nico_selection_route_woman_03
```

These selected views do not replace Thursday's female-photo minimum.

### N2C

```text
women-not-currency boundary set
no private selection
```

---

# 8. Day 10 — Thursday dominant visual payoff

## 8.1 Route resolution

Recommended internal phase:

```text
thursday_primary_visual_route_select
```

Selection reads:

- M4 outcome;
- Mathilde or Sandra carry-over result;
- Pauline P2;
- Nico N2;
- current route cooling;
- existing visual advancement.

Selection principle:

```text
one primary route payoff
+ optional secondary risk overlay
```

## 8.2 Marie payoff delivery

Preferred time:

```text
19:15–20:15
```

Sequence:

```text
marie_thursday_private_dress_01
-> Player reaction
marie_thursday_lingerie_tease_02
-> private continuation choice or result
marie_thursday_reconquest_private_03
```

The shared dinner or sex-adjacent continuation occurs off-phone.

## 8.3 Mathilde payoff delivery

Preferred time:

```text
18:40–20:00
```

Sequence:

```text
mathilde_thursday_private_homewear_01
mathilde_thursday_underwear_choice_02
mathilde_thursday_for_your_eyes_03
```

The trigger may be:

- packing before returning home;
- one last outfit choice;
- a private message while Marie is elsewhere;
- the approaching end of the stay.

The images are deliberate, not accidental clothing.

## 8.4 Sandra payoff delivery

Preferred time:

```text
21:15–22:10
```

Sequence:

```text
sandra_thursday_evening_dress_01
sandra_thursday_satin_private_02
sandra_thursday_chosen_exposure_03
```

Sandra controls timing and may delay the final frame.

The scene must not become an image flood.

## 8.5 Pauline payoff delivery

Preferred time:

```text
22:20–22:55
```

Sequence:

```text
pauline_thursday_public_green_dress_01
pauline_thursday_private_crop_02
pauline_thursday_double_address_03
```

The third image must clearly show that Pauline intended a second private meaning.

Bastien remains an off-screen consequence even when not present in the chat.

## 8.6 Raphaëlle teaser

Optional additional delivery:

```text
raphaelle_thursday_office_full_01
raphaelle_thursday_workshop_fit_02
raphaelle_thursday_partial_costume_03
```

This set should use a legitimate work/creative trigger.

It cannot replace the main route payoff unless Raphaëlle is explicitly selected as the primary route in a later approved revision.

---

# 9. Thursday Marie obligation return

Recommended phase id:

```text
thursday_marie_real_plan_return
```

The Marie obligation remains due even when another woman receives the dominant payoff.

Outcomes:

```text
PAID
AMENDED
FAILED
```

### Paid

- Marie reads action, not explanation;
- active-reconnection evidence;
- Marie route payoff may dominate if selected.

### Amended

- new concrete action required;
- no endless postponement.

### Failed

- Marie continues her evening;
- drift evidence;
- another route payoff remains possible;
- future couple consequence preserved.

---

# 10. Wave closure

Recommended phase id:

```text
thursday_named_boundaries_visual_wave_close
```

Closure predicate:

```text
Tuesday 3-image minimum resolved
Wednesday 3-image minimum resolved
Thursday 3-image minimum resolved
M4 obligation terminal
carry-over scene terminal or absent
social hub terminal
Pauline opportunity terminal or absent
Nico scene terminal or deferred
primary visual payoff terminal
no unowned SCHEDULED / DUE obligation
```

Recommended completion fact:

```text
named_boundaries_wave_complete
```

The close must:

- remain silent;
- be idempotent;
- preserve historical ledgers;
- preserve visual unlocks;
- preserve risk markers;
- unlock no later day.

---

# 11. Daily validation matrix

## Tuesday

```text
A: M4A -> 3 Marie images + joined obligation
B: M4B -> 3 Marie images + precise-arrival obligation
C: M4C -> 3 Marie images + private-Thursday obligation
```

## Wednesday

```text
D: quiet history -> 3 social images
E: Mathilde selected -> 3 Mathilde + 3 social images
F: Sandra selected -> 3 Sandra + 3 social images
G: route cooled -> third route slot replaced by safer branch image, not removed
```

## Thursday

```text
H: Marie payoff -> 3 Marie images
I: Mathilde payoff -> 3 Mathilde images
J: Sandra payoff -> 3 Sandra images
K: Pauline payoff -> 3 Pauline images
L: Nico risk overlay -> female payoff still present + selection overlay
M: optional Raphaëlle teaser -> additional 3-image set
```

## Closure blockers

```text
N: any day has fewer than 3 resolved female images -> block
O: M4 obligation pending -> block
P: primary payoff unresolved -> block
Q: later Friday unlocked -> fail
```

---

# 12. Runtime slicing recommendation

```text
V0.95 Tuesday Marie black-dress set + M4
V0.96 Wednesday Mathilde/Sandra carry-over sets
V0.97 social set + Pauline opportunity + Nico selection
V0.98 Thursday route payoff + guarded closure
```

Each slice should include:

- static visual-count tests;
- gallery-unlock tests;
- isolated runtime smoke scenarios;
- choice-to-image mapping tests;
- legacy smoke non-regression;
- Godot headless boot;
- `git diff --check`.

---

# 13. Final temporal rule

```text
Tuesday shows Marie and creates the promise.
Wednesday shows the route temptation and the social comparison.
Nico turns the public image into a possible private risk.
Thursday pays the chosen fantasy with a route-specific visual set.

The wave closes only after the player has seen something new every day.
```
