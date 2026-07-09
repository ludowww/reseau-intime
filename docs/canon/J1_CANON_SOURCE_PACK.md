# J1 Canon Source Pack — Current

> Canon source pack for current J1 writing and future runtime planning.  
> Consolidates V0.60 structure, V0.64 naturalization work, V0.69 final line review, the current character canon, and the choice-count canon.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Purpose

This document is the first source to read before planning J1 runtime integration.

It prevents future prompts from scattering across:

- V0.60 plan;
- V0.64 historical draft;
- V0.69 final J1 line source;
- Marie profile;
- Sandra profile;
- Player profile;
- voice bibles;
- addendums.

Exact dialogue lines must now be taken from:

```text
docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md
```

Choice-count rules must be taken from:

```text
docs/canon/CHOICE_DESIGN_CANON.md
```

V0.64 remains useful history, but it is no longer the current exact line source.

---

## 2. J1 title

```text
J1 — Les choses qu'on remarque
```

Working intention:

```text
Marie is the life Player must join.
Sandra is the trace Player can read.
Player is not choosing a route yet.
He is revealing how he pays attention.
```

---

## 3. Active / inactive characters

### Active

- Marie
- Sandra
- Player

### Indirect only

- Mathilde, mentioned through Marie if needed

### Absent from active runtime J1

- Nico
- Pauline
- Raphaëlle
- group conversation

---

## 4. Hard constraints

J1 must not include:

- route lock;
- explicit escalation;
- heavy betrayal;
- hard secret system;
- Nico active thread;
- Pauline active thread;
- Raphaëlle active thread;
- group thread;
- new global system;
- complex proof mechanics;
- adult explicit content;
- more than three runtime choices per node unless a later plan explicitly justifies an exception.

J1 conflict is attention, not allegiance.

---

## 5. Scene order

### Scene 1 — Marie / Player opening domestic warmth

Function:

- establish couple warmth;
- make Marie lively before any wound;
- give Player a small concrete action.

Anchors:

- tomatoes;
- cheese / dinner;
- missing bread;
- couch;
- small walk.

Runtime choice target: 3 choices.

Authoring variants may include:

- present;
- joking but present;
- flat;
- delayed by work.

Before runtime integration, collapse to three choices, for example:

```text
1. present
2. joking but present
3. flat / delayed
```

### Scene 2 — Marie / Player La Verrière color beat

Function:

- show Marie's outside life;
- make her active and social;
- avoid reducing her to couple tension.

Anchors:

- La Verrière;
- event logistics;
- posters / logos / provider uncertainty;
- Élodie as work-color witness.

Optional Mathilde seed:

- Mathilde wants to see an installation;
- she judges lighting;
- no active Mathilde thread.

### Scene 3 — Sandra / Player trace re-entry

Function:

- reintroduce Sandra through a defensible trace;
- avoid direct seduction;
- let Player read something small, not perfectly.

Anchors:

- old blurry lunch photo;
- printed photo after work;
- SentryCore;
- ticket fantôme / missing button;
- hot chocolate;
- tired end-of-day tone.

Terminology:

- use `fin de poste`, `poste du soir`, `poste du matin`, or `horaires décalés` if needed;
- do not use the English word `shift` in final writing.

Runtime choice target: 3 choices.

Authoring variants may include:

- safe warmth;
- precise observation;
- playful but light;
- distant / cautious.

Before runtime integration, collapse to three choices, for example:

```text
1. safe warmth
2. precise observation
3. playful or cautious
```

### Scene 4 — Marie / Player evening presence check

Function:

- bring Marie back after Sandra;
- keep attention as the conflict;
- ask for presence through action.

Anchors:

- buying bread;
- putting shoes on;
- ten-minute walk;
- soft pressure;
- Player returns, dodges, or stays distant.

Runtime choice target: 3 choices.

Authoring variants may include:

- active return;
- awkward but sincere;
- joke again;
- still distant.

Before runtime integration, collapse to three choices, for example:

```text
1. active return
2. awkward but sincere
3. joke / distant
```

### Scene 5 — Sandra / Player soft boundary

Function:

- close Sandra gently;
- keep her present but not demanding;
- avoid route activation.

Anchors:

- early morning / tiredness if useful;
- blurry photo that stays blurry;
- harmless version / consequence denied;
- goodnight.

Earned optional warmth:

- `mon cher Player` only if precise-observation branch earned it.

### Scene 6 — Marie / Player end-of-day close

Function:

- end on Marie / shared life;
- show that ordinary presence matters;
- keep J1 soft but meaningful.

Anchors:

- bread recovered;
- dinner saved;
- walk helped;
- tomatoes / cheese;
- `message reçu` -> `message à prouver`;
- Player cuts cheese / participates.

---

## 6. Visual / trace plan

Preferred J1 visual:

```text
j1_sandra_lunch_photo_blurry
```

Function:

- soft trace;
- old lunch memory;
- Sandra partly present but not explicit subject;
- no proof of betrayal;
- no erotic framing;
- not a route lock.

Optional domestic trace, only if very cheap:

```text
j1_marie_dinner_trace
```

Function:

- tomatoes / cheese / bread / shoes;
- ordinary couple life;
- not a proof.

If scope is tight, use only the Sandra trace.

---

## 7. Choice design

Default J1 runtime choice count:

```text
3 choices per choice node
```

Choices should be low-intensity and color attention, not routes.

Drafts may show four authoring variants, but runtime integration must collapse them to three choices unless a later plan explicitly justifies an exception.

Good choice effects:

- Player is warmer with Marie;
- Player is flat but not cruel;
- Player notices Sandra more precisely;
- Sandra is a bit warmer or stays cautious;
- Marie notices presence or distance.

Forbidden choice effects:

- route lock;
- secret system;
- explicit betrayal;
- immediate adult escalation;
- introducing Nico / Pauline / Raphaëlle;
- making Sandra available;
- making Marie suspicious too early;
- integrating 4+ choices without explicit exception.

---

## 8. Voice constraints

### Marie

- alive before hurt;
- social and domestic;
- asks for participation, not surveillance;
- light emojis allowed: `😅`, `🙂`;
- no jealousy on J1;
- no Nico / Pauline pressure.

### Sandra

- concrete trace first;
- cautious warmth;
- one `haha` maximum unless branch strongly earns another;
- `officiellement` used sparingly;
- no Jeff exposition on J1;
- no romance-reading exposition on J1;
- no direct confession;
- no English `shift` wording.

### Player

- short replies;
- banal replies allowed;
- not always witty;
- precise reading possible but not default;
- if a reply sounds too clever, flatten it.

---

## 9. Runtime planning notes for Hermes later

When a future runtime integration plan is written, Hermes should be instructed to:

- use `docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md` as exact line source;
- use `docs/canon/CHOICE_DESIGN_CANON.md` for choice count;
- collapse J1 authoring variants to three runtime choices per node;
- inspect existing J1 data before patching;
- replace or rewrite J1 only within the agreed scope;
- avoid touching J2+ unless explicitly asked;
- avoid new systems;
- preserve existing validation commands;
- add or update tests only if paths/indexes/visual content require it;
- keep the implementation data-first.

No runtime task should be launched directly from this source pack. It needs a separate runtime integration plan.

---

## 10. Acceptance criteria for J1

J1 is successful if:

- Marie feels desirable, living, and central before any wound;
- Player gets small but real responses;
- Sandra returns through a trace, not seduction;
- Mathilde is indirect only;
- Nico / Pauline / Raphaëlle are absent;
- the final beat returns to Marie and shared life;
- no route is locked;
- no old J5/J6/J7 assumptions leak into J1;
- choice nodes use three runtime choices unless explicitly excepted;
- the scene feels like a real day, not a character sheet demonstration.

---

## 11. Final rule

```text
J1 is not about choosing Sandra over Marie.
J1 is about whether Player can still join Marie while noticing that Sandra leaves a trace.
Three runtime choices are enough for J1.
```
