# Narrative Canon Status — Current

> Consolidated narrative status after V0.65–V0.74 canon work.  
> This document explains how to read runtime, story-state docs, arcs, spine, proof maps, and character profiles before new narrative or runtime work.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Core rule

```text
Current canon overrides older narrative interpretation.
Existing runtime is not automatic narrative canon.
```

Any older content touching character arcs, scenes, proofs, photos, routes, relationship progression, or adult escalation must be reviewed against:

- full character canon;
- NSFW route canon;
- current choice canon;
- current day source pack;
- character-specific deprecation maps.

## 2. Current canon stack

Read:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/CHOICE_DESIGN_CANON.md
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

Also read the character-specific deprecation map when one exists:

```text
docs/canon/characters/MATHILDE_CANON_DEPRECATION_MAP.md
docs/canon/characters/PAULINE_CANON_DEPRECATION_MAP.md
```

## 3. Character-profile status

### Full concrete canon

- Marie
- Sandra
- Player
- Mathilde
- Pauline

Mathilde's V0.73 canon supersedes the earlier calibration-only profile and old runtime assumptions.

Current Mathilde direction:

- 28 years old;
- legal-protection case manager;
- temporary stay with Marie / Player after water damage;
- near-sister family bond with Marie;
- naturally sexy domestic style;
- mini-shorts, crop tops, fitted clothing;
- ordinary sensuality distinct from deliberate seduction;
- desire to be desired and taken seriously;
- domestic taboo / image control / Player gaze / Marie loyalty NSFW engine;
- modular scene pools;
- route consequences and adult agency.

Pauline's revised V0.74 canon supersedes both the calibration-only profile and the first sanitized V0.74 draft.

Current Pauline direction:

- 32 years old and explicitly adult;
- retail client adviser in a local mutual bank;
- currently in a five-year relationship with Bastien;
- lives with Bastien in a shared rented apartment;
- has already cheated on Bastien during that current relationship;
- the brief affair ended before the game, but Bastien does not know;
- Marie knows the affair crossed a physical line;
- Marie kept the confidence but did not approve or grant future permission;
- Pauline remains vulnerable to repeating the same architecture of secrecy;
- close friend of Marie for around eight years, with a deep but breakable bond;
- culturally Catholic community background without religious-repression framing;
- parish choir as a real weekly life anchor;
- controlled, fitted clothing and composed public image;
- public reliability and private transgression are both real;
- double life / compartmentalization is her primary dramatic function;
- hidden desire is managed through alternate versions, alibis, proof, and reciprocal implication;
- Bastien and Marie remain active consequences on dangerous routes;
- modular scene pools replace fixed-day escalation;
- no playable choir voice message.

Pauline's ensemble distinction is:

```text
She does not ask Player to choose her.
She makes not choosing feel practical, intelligent, and temporarily harmless.
```

### Concrete-profile expansion still needed

- Raphaëlle
- Nico

Their current files remain usable calibration canon, but major biography should not be invented as hard truth without a profile pass.

## 4. Current J1 status

J1 active sources:

```text
docs/canon/J1_CANON_SOURCE_PACK.md
docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md
docs/canon/CHOICE_DESIGN_CANON.md
full Marie / Sandra / Player canon
```

Current J1 rules:

- Marie + Sandra active;
- Player active through replies / choices;
- Mathilde indirect only;
- no Nico, Pauline, or Raphaëlle active thread;
- no group conversation;
- no hard secret system;
- no route lock;
- no explicit escalation;
- maximum three choices per node;
- final emotional center: Marie / shared life.

Pauline remains absent from playable J1.

The following Pauline facts still exist in background canon:

- she is with Bastien;
- she has cheated on him;
- Bastien does not know;
- Marie knows part of it.

V0.64 remains historical and is no longer the current exact-line source.

## 5. Current J2+ status

### J2

Status: **requires a new source pack / review before canon confirmation**.

Existing material may be technically useful, but pacing and character entry must be rebuilt from current canon.

### J3

Status: **requires a new source pack / review before canon confirmation**.

For Mathilde:

- old photo/canapé is deprecated;
- spider / spare-room may be used as one early foundation;
- the active premise should use the temporary stay and current domestic canon;
- no early route lock;
- Mathilde's fitted sensual style is ordinary at first, not automatic seduction.

### J4

Status: **legacy / suspended until reviewed**.

Do not assume an old social/photo/Nico/Pauline-heavy structure remains valid.

For Pauline specifically:

- an old invitation scene does not define her current first active entry;
- a social or practical pretext remains compatible if rebuilt from Marie's trust, Bastien's existence, and modular conditions;
- no private Player route is already active because old runtime contains one;
- the restored current-partner infidelity is background canon even though the old J4 schedule is suspended.

### J5 / J6

Status: **runtime exists; narrative canon suspended**.

May contain useful implementation or isolated ideas, but must not drive future story without re-audit.

For Pauline specifically:

- an old `last photo` or similar scene does not define her current image progression;
- adult escalation requires selected intent, explicit limits, reciprocal risk, and awareness of both existing couples;
- a photo alone is not route activation or consent;
- a compatible old confrontation or proof engine may be rebuilt in a modular window.

### J7

Status: **runtime exists; narrative canon suspended**.

For Mathilde specifically, J7 does not define:

- current clothing canon;
- current route state;
- current long arc;
- required scene order.

For Pauline, any old `less theoretical`, silence-test, or later escalation remains historical as a fixed sequence and does not establish current route state.

### J8+

Status: **non-current unless a later source pack explicitly validates it**.

## 6. Story-state documentation

`docs/story_state/GLOBAL_STORY_STATE.md` and `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md` were reconciled by V0.68.

They remain operational summaries, not a replacement for full canon.

If they conflict with V0.69+ J1 sources, V0.73 Mathilde canon, or revised V0.74 Pauline canon, the newer canon wins.

## 7. Old narrative docs

### `docs/narrative/CHARACTER_ARCS_J1_J10.md`

Status: **legacy / historical problem map**.

Do not use it as direct scene or route source.

### `docs/narrative/SCENARIO_SPINE_J1_J10.md`

Status: **historical / macro reference only**.

Do not use its J5/J6/J7 sections as current truth.

### Old dedicated Pauline arc

Status: **identity pillars partially restored; mandatory schedule suspended**.

Retained pillars:

- current-partner infidelity;
- double face;
- Marie's partial knowledge;
- proof and control;
- temptation through private complicity;
- the exposed exposer;
- Pauline understanding Player's temptation because she has lived it.

Not retained as canon:

- fixed J4–J10 ordering;
- automatic orchestration of every social event;
- omniscient proof collection;
- automatic chantage escalation;
- guaranteed route beats.

### `docs/narrative/PROOF_AND_SECRET_MAP.md`

Status: **typology useful; day-by-day examples suspended**.

For Pauline, current proof logic must preserve:

```text
current hidden betrayal
+ selected private version
+ plausible deniability
+ explicit rule
+ reciprocal risk
+ consequence for Bastien and Marie
```

She cannot remain a one-way controller of other people's exposure.

## 8. Mathilde deprecation summary

Current canon overrides:

- old photo/canapé foundation;
- sport/racket identity as core;
- active `mathilde_seed` in J1;
- long grey sweater as recurring signature;
- old J7 as narrative destination;
- automatic Marie–Mathilde sexual group assumptions.

Compatible only after current-canon reframing:

- spider / spare-room foundation;
- legal humor;
- outfit and image tension;
- family trust and guilt;
- domestic proximity.

## 9. Pauline deprecation summary

Current canon restores:

- current relationship with Bastien;
- prior unconfessed infidelity during that relationship;
- Marie knowing part of the truth;
- double life / compartmentalization;
- proof control grounded in lived betrayal;
- sour temptation based on `nothing has to change yet`.

Current canon overrides or suspends:

- Pauline as single by default;
- ex-boyfriend-only wound;
- indestructible friendship with Marie;
- omniscient social or photo-controller framing;
- Pauline only distributing or interpreting other people's images;
- permanent `official / unofficial` rhythm;
- constant halo / church jokes;
- religious-repression or virgin-corruption framing;
- playable choir voice-message assumptions;
- fixed old J4 invitation / J5 photo / later route sequence;
- early route locking;
- consequence-free betrayal of Marie or Bastien;
- automatic group-sex or consensual cuckold assumptions.

Compatible only after current-canon reframing:

- legitimate social or practical relay through Marie;
- scenes with Bastien and both couples visible;
- group-photo competence;
- public virtue / private contradiction;
- choir and community life;
- fast dry Messenger complicity;
- alternate image versions;
- alibis and reciprocal proof;
- later trio, sharing, cuckold, or group material through explicit informed adult negotiation.

## 10. Adult route rule

`Réseau Intime` may become pornographic when routes escalate.

For Mathilde, adult escalation must come from:

```text
ordinary sensuality
-> Player's changed gaze
-> Mathilde notices
-> deliberate image / clothing / proximity choice
-> acknowledged desire
-> adult decision and consequence
```

A mini-short or crop top alone is not consent or route activation.

For Pauline, adult escalation must come from:

```text
current couple and prior hidden infidelity
-> recognition of Player's denied desire
-> legitimate private channel
-> double-addressed private version
-> plausible deniability
-> reciprocal implication
-> acknowledged double life
-> adult decision and consequence
```

An alternate photo, dry joke, or private reply alone is not consent or route activation.

Pauline may lose composure, timing, polish, or emotional control.

She does not lose the right to decide.

Bastien's ignorance never becomes consent.

A later negotiated cuckold, sharing, open, trio, or group frame must be established separately and cannot retroactively erase betrayal.

## 11. Choice rule

Default runtime count:

```text
3 choices per node
```

Four or more choices require explicit written justification.

## 12. Final rule

```text
Build the next story step from current canon, not inherited runtime.
Keep identity pillars when they differentiate a character.
Discard old schedules when they force linearity.
Characters stay deep.
Routes may become pornographic.
Consequences remain human.
```
