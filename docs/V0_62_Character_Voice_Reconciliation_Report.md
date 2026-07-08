# V0.62 — Character Voice Reconciliation Report

> Documentation-only reconciliation report.  
> Clarifies how the reworked Marie, Sandra, and Player concrete profiles should coexist with the older voice bibles, color addendums, and post-etalon corrections.  
> No runtime, narrative JSON, tests, assets, or playable content are changed.

## 1. Purpose

Recent work added or refined the following source documents:

- `docs/Sandra_Concrete_Profile_V2.md`
- `docs/Sandra_Concrete_Profile_V2_Details_Addendum.md`
- `docs/Sandra_Concrete_Profile_V2_Final_Choices_Addendum.md`
- `docs/Marie_Concrete_Profile_V2.md`
- `docs/Marie_Concrete_Profile_V2_Details_Addendum.md`
- `docs/Player_Concrete_Profile_V2.md`
- `docs/V0_60_J1_Reworked_Script_Plan.md`
- `docs/V0_61_J1_Reworked_Script_Draft.md`

These documents make Marie, Sandra, and Player more concrete than the earlier voice bibles.

This report reconciles them with:

- `docs/Character_Playable_Voice_Cards.md`
- `docs/Character_Voice_Color_Addendum.md`
- `docs/Character_Voice_Messenger_Intensity_Bible.md`
- `docs/Character_Voice_Post_Etalons_Addendum.md`
- `docs/Sandra_Player_Address_Formula_Addendum.md`

The goal is to avoid future writing conflicts before J1 is naturalized and later integrated into runtime data.

---

## 2. Global rule

For Marie, Sandra, and Player, the concrete V2 profiles now provide the **primary writing truth**.

The older voice documents remain valid, but they should be read as:

- voice foundations;
- color palettes;
- rhythm and intensity guardrails;
- anti-pattern checklists;
- calibration material.

They should not override newer concrete profile choices.

```text
Concrete profile = who the character is now.
Voice bible = how the character should sound.
Color addendum = what texture can be used.
Post-etalon addendum = what to avoid when a scene becomes too clean or too patterned.
```

---

## 3. Source hierarchy for Marie / Sandra / Player

### Priority 1 — Current concrete truth

Use first when writing scenes:

- `docs/Marie_Concrete_Profile_V2.md`
- `docs/Marie_Concrete_Profile_V2_Details_Addendum.md`
- `docs/Sandra_Concrete_Profile_V2.md`
- `docs/Sandra_Concrete_Profile_V2_Details_Addendum.md`
- `docs/Sandra_Concrete_Profile_V2_Final_Choices_Addendum.md`
- `docs/Player_Concrete_Profile_V2.md`

### Priority 2 — Current day-level writing truth

Use for J1 specifically:

- `docs/V0_60_J1_Reworked_Script_Plan.md`
- `docs/V0_61_J1_Reworked_Script_Draft.md`

V0.61 is still a draft and should receive a naturalization pass before runtime conversion.

### Priority 3 — Voice and rhythm foundation

Use as guardrails, not as complete character profiles:

- `docs/Character_Playable_Voice_Cards.md`
- `docs/Character_Voice_Messenger_Intensity_Bible.md`

### Priority 4 — Secondary color and anti-pattern layer

Use to enrich or correct scenes:

- `docs/Character_Voice_Color_Addendum.md`
- `docs/Character_Voice_Post_Etalons_Addendum.md`
- `docs/Sandra_Player_Address_Formula_Addendum.md`

### Priority 5 — Macro route context

Use for broad direction only:

- `docs/V0_57_Route_Character_Rework_Blueprint.md`
- `docs/V0_59_Reworked_J1_J9_Beat_Plan.md`

They are not direct script sources when a newer day plan or source pack exists.

---

## 4. Marie reconciliation

### Current Marie truth

Marie is now defined primarily by:

- living center of the couple;
- 31 years old;
- five years with Player;
- three years living together;
- no marriage, no children;
- work at `La Verrière` as communications and small-events coordinator;
- domestic anchors: tomatoes, bread, couch, series, groceries, walks;
- personal anchors: black dress, gold earrings, entrance mirror, overfull bag, playlist, lipstick, shoes near the door;
- social anchors: Pauline, Mathilde, Nico, Sandra, Élodie;
- family pattern: often expected to carry the mood;
- wound: fear of being loved as a habit;
- repair mode: music + mirror + movement;
- desire: to be actively chosen.

### Older docs still valid

`Character_Playable_Voice_Cards.md` remains valid for Marie's core voice:

- alive;
- sociable;
- funny;
- active;
- tender and piquant;
- not only fragile;
- not only the woman who monitors Player.

`Character_Voice_Messenger_Intensity_Bible.md` remains valid for:

- Marie as dramatic center;
- couple state as filter for all routes;
- gradual intensity;
- emojis and Messenger rhythm;
- photos as narrative facts.

`Character_Voice_Post_Etalons_Addendum.md` remains valid for:

- secondary palette;
- tomatoes / bread / burrata;
- walks;
- social plans;
- ordinary life material;
- rule that Marie must make Player want to live with her, not only fear losing her.

### Reconciliation rule

When writing Marie, do not reduce her to old high-pressure lines such as:

- `pose ton téléphone`;
- `regarde-moi`;
- `tu es ailleurs`.

Prefer concrete action:

- dinner;
- walking;
- shoes near the door;
- La Verrière anecdote;
- music;
- mirror;
- social plan;
- small ordinary test of presence.

### J1 implication

V0.61 correctly uses Marie as living couple anchor.

V0.62 naturalization should keep:

- tomatoes / bread / dinner;
- walk;
- La Verrière;
- light notice of Player absence.

But it should trim some overly neat punchlines so Marie feels less like a perfect dialogue engine.

---

## 5. Sandra reconciliation

### Current Sandra truth

Sandra is now defined primarily by:

- concrete traces rather than vague light;
- work on SentryCore, a software incident platform;
- first-line tickets;
- rotating shifts / odd-hour intimacy;
- boyfriend Jeff, 35, mason;
- six-year relationship, three-year shared house;
- stable but emotionally underfed couple;
- withdrawal after conflict;
- refuge: couch, bedroom, plaid, hot chocolate, reading, scrapbooking, decoration;
- family anchor: Maison des Tilleuls;
- paper romances and impossible-love motifs;
- group withdrawal vs talkative confidence;
- old Player/Sandra memory before Marie;
- trace-based scene engine.

### Older docs still valid

`Character_Playable_Voice_Cards.md` remains valid for Sandra's voice:

- soft;
- prudent;
- complicit;
- `haha` as disguised yes / embarrassment / door ajar;
- photo floue / memory / gentle distance;
- possessives such as `mon cher Player`, used rarely.

`Character_Voice_Color_Addendum.md` remains valid for:

- nature / light / photo as secondary texture;
- `haha` function;
- possessive address formulas;
- late-distance revelation route guardrails.

But nature and light are no longer enough by themselves.

They should be grounded in a concrete trace:

- shift;
- ticket;
- printed photo;
- hot chocolate;
- paper book;
- family house;
- old lunch;
- object kept.

### Reconciliation rule

Do not write Sandra as merely:

```text
soft light + nature + vague nostalgia
```

Write her as:

```text
concrete trace + false reasonableness + hidden feeling + soft boundary
```

### J1 implication

V0.61 correctly uses:

- old blurry lunch photo;
- shift ending;
- SentryCore;
- ticket fantôme;
- hot chocolate;
- `haha`;
- no Jeff yet;
- no romance novels yet;
- no heavy confession.

This is aligned with Sandra V2.

The next pass should only watch that `officiellement / officieusement` and `haha` do not become automatic.

---

## 6. Player reconciliation

### Current Player truth

Player is now defined primarily by:

- age range around 32–34;
- five-year couple with Marie;
- three-year shared apartment;
- functional project / product operations coordinator in a software or digital-services company;
- work fatigue: meetings, emails, dashboards, browser tabs, cold coffee;
- ordinary anchors: forgotten bread, couch, walks, books, simple cooking;
- occasional chess player;
- humor as defense;
- avoidance through passive delay;
- tendency to observe instead of participate;
- real love for Marie, but stability has made him passive;
- ability to read Sandra's traces, but not perfectly.

### Older docs still valid

`Character_Playable_Voice_Cards.md` remains valid for:

- short replies;
- awkward irony;
- banal lines;
- half-truths;
- failed jokes;
- imperfect but active responses.

`Character_Voice_Post_Etalons_Addendum.md` remains especially important for Player:

- Player needs habits, flaws, small wins, traces, and reasons to write first;
- Player must be defined enough to live, but open enough to be played;
- Player should not be too brilliant.

### Reconciliation rule

For Player, concrete profile does not mean fixed personality.

It means stable playable texture.

Player can be:

- banal;
- late;
- evasive;
- awkward;
- observant;
- funny by accident;
- too precise once in a while;
- wrong in small human ways.

### J1 implication

V0.61 correctly gives Player:

- flat choices;
- delayed choices;
- warm participation;
- precise Sandra reading;
- return to Marie.

But the next pass must trim some overly neat replies.

Primary V0.63/V0.62-naturalization correction:

```text
Remove 10-20% of Player cleverness.
Leave more ordinary messages.
Keep him active, but less polished.
```

---

## 7. How to read the older voice bibles after V0.62

### `Character_Playable_Voice_Cards.md`

Status: **still valid**.

Use it for:

- base voices;
- Messenger rhythm;
- recognizable speech patterns;
- character-level guardrails.

Do not use it as a complete concrete biography for Marie, Sandra, or Player anymore.

### `Character_Voice_Color_Addendum.md`

Status: **still valid as palette**.

Use it for:

- secondary colors;
- private codes;
- vulnerability modes;
- rare tools such as Sandra's possessives or `petit vicieux`.

Do not use it to flatten new concrete profiles.

Example:

- Sandra light / nature = allowed texture;
- Sandra SentryCore / Jeff / Maison des Tilleuls / shifts = current concrete core.

### `Character_Voice_Messenger_Intensity_Bible.md`

Status: **still valid as rhythm and intensity bible**.

Use it for:

- Marie / Player as dramatic center;
- route intensity progression;
- photos as narrative facts;
- emojis as emotional grammar;
- Messenger pacing;
- route-specific intensity guardrails.

Important for V0.61/V0.63:

```text
Add low-intensity emojis where useful.
Do not over-literarize Messenger exchanges.
```

### `Character_Voice_Post_Etalons_Addendum.md`

Status: **still valid as correction layer**.

Use it before validating any scene.

Especially:

- remove 20% cleverness if too clean;
- leave ordinary messages;
- avoid using all signature tools at once;
- avoid repeated author phrases;
- ensure secondary themes exist;
- keep photos / traces functional.

---

## 8. V0.61 compliance summary

V0.61 is structurally aligned with the reconciled hierarchy.

### Compliant

- Marie is central and alive.
- Sandra re-enters through a trace.
- Player has active but imperfect response options.
- Mathilde is indirect only.
- Nico / Pauline / Raphaëlle do not compete with J1.
- No strong route lock.
- No explicit escalation.
- Final emotional return is Marie / shared life.

### Needs naturalization before runtime

- Add a few low-level emojis where they help Messenger tone.
- Reduce Player cleverness.
- Trim a few Marie punchlines.
- Keep Sandra `haha` / `officiellement` dosage under control.
- Make some responses shorter and less polished.

This is a texture pass, not a structural rewrite.

---

## 9. Recommended next version

After this reconciliation, the next recommended PR is:

```text
V0.63 — J1 Naturalization & Voice Compliance Pass
```

Scope:

- update `docs/V0_61_J1_Reworked_Script_Draft.md` or add a V0.63 revised draft;
- apply the reconciled hierarchy;
- preserve J1 structure;
- improve Messenger naturalness;
- add low-intensity emojis sparingly;
- trim overly clean lines;
- keep documentation-only.

No runtime integration should happen before this pass is validated.

---

## 10. Final rule

```text
Marie V2 tells what life Player may fail to join.
Sandra V2 tells what trace Player may read too precisely.
Player V2 tells why he can notice details and still miss the moment.

The older voice bibles remain the soundboard.
The concrete profiles are now the character truth.
```
