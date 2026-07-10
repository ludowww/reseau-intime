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

Pauline's V0.74 canon supersedes the earlier calibration-only profile and fixed old J4/J5 route assumptions.

Current Pauline direction:

- 32 years old and explicitly adult;
- retail client adviser in a local mutual bank;
- lives alone in a rented two-room apartment;
- trusted friend of Marie for around eight years;
- culturally Catholic community background without religious-repression framing;
- parish choir as a real weekly life anchor;
- controlled, fitted clothing and composed public image;
- previous relationship wound around losing authorship of her private self;
- deep desire to be trusted after being seen;
- image selection rather than accidental sensuality;
- public trust / selected private channel / reciprocal risk / Marie loyalty NSFW engine;
- modular scene pools rather than fixed-day escalation;
- reciprocal exposure and social consequences;
- no playable choir voice message.

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
- a social or practical pretext remains compatible only if rebuilt from Marie's trust and the current modular logic;
- no private route is already active because old runtime contains one.

### J5 / J6

Status: **runtime exists; narrative canon suspended**.

May contain useful implementation or isolated ideas, but must not drive future story without re-audit.

For Pauline specifically:

- an old `last photo` or similar scene does not define her current image progression;
- adult escalation requires selected intent, explicit limits, and reciprocal risk;
- a photo alone is not route activation or consent.

### J7

Status: **runtime exists; narrative canon suspended**.

For Mathilde specifically, J7 does not define:

- current clothing canon;
- current route state;
- current long arc;
- required scene order.

The long-grey-sweater framing and any fixed route assumptions are non-primary.

For Pauline, any old `less theoretical` or later escalation remains historical and does not establish current route state.

### J8+

Status: **non-current unless a later source pack explicitly validates it**.

## 6. Story-state documentation

`docs/story_state/GLOBAL_STORY_STATE.md` and `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md` were reconciled by V0.68.

They remain operational summaries, not a replacement for full canon.

If they conflict with V0.69+ J1 sources, V0.73 Mathilde canon, or V0.74 Pauline canon, the newer canon wins.

## 7. Old narrative docs

### `docs/narrative/CHARACTER_ARCS_J1_J10.md`

Status: **legacy / historical problem map**.

Do not use it as direct scene or route source.

### `docs/narrative/SCENARIO_SPINE_J1_J10.md`

Status: **historical / macro reference only**.

Do not use its J5/J6/J7 sections as current truth.

### `docs/narrative/PROOF_AND_SECRET_MAP.md`

Status: **typology useful; day-by-day examples suspended**.

Use current character and adult-photo logic before restoring any proof.

For Pauline, proof logic must preserve:

```text
selected image
+ explicit rule
+ reciprocal risk
+ consequence
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

Current canon overrides:

- omniscient social or photo-controller framing;
- Pauline only distributing or interpreting other people's images;
- permanent `official / unofficial` rhythm;
- constant halo / church jokes;
- religious-repression or virgin-corruption framing;
- playable choir voice-message assumptions;
- fixed old J4 invitation / J5 photo / later route sequence;
- early route locking;
- consequence-free betrayal of Marie;
- automatic group-sex organizer assumptions.

Compatible only after current-canon reframing:

- legitimate social or practical relay through Marie;
- group-photo competence;
- public virtue / private contradiction;
- choir and community life;
- fast dry Messenger complicity;
- alternate image versions;
- image control that becomes reciprocal exposure;
- later trio or group material through explicit adult negotiation.

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
public trust
-> legitimate private channel
-> privately selected version
-> reciprocal implication
-> acknowledged desire
-> adult decision and consequence
```

An alternate photo, dry joke, or private reply alone is not consent or route activation.

Pauline may lose composure, timing, polish, or emotional control.

She does not lose the right to decide.

## 11. Choice rule

Default runtime count:

```text
3 choices per node
```

Four or more choices require explicit written justification.

## 12. Final rule

```text
Build the next story step from current canon, not inherited runtime.
Characters stay deep.
Routes may become pornographic.
Old material remains usable only after revalidation.
```
