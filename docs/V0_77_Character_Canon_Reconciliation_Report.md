# V0.77 — Character Canon Reconciliation Report

> Documentation-only reconciliation pass.  
> No runtime, narrative JSON, tests, assets, or playable content are changed.

## 1. Scope

V0.77 stabilizes the character-documentation architecture after the full concrete passes for Mathilde, Pauline, Nico, and Raphaëlle.

The pass does not add a new character biography.

It resolves two documentation debts:

1. Nico's validated voyeurism / Mathilde attraction / photo-pact correction still existed as a separate mandatory supplement even though its content had already been consolidated into the full Nico canon.
2. Jeff was still described in several general entry points as a principal-style profile that needed completion, despite the Product Owner decision that he is not an independent story engine.

## 2. Files updated

- `docs/canon/characters/CHARACTER_CANON_INDEX.md`
- `docs/canon/CHARACTERS_CANON_CURRENT.md`
- `docs/canon/DOCUMENTATION_READING_ORDER.md`
- `docs/canon/NARRATIVE_CANON_STATUS.md`

## 3. File added

- `docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md`

## 4. Temporary files removed

- `docs/canon/characters/NICO_CANON_VOYER_PHOTO_PACT_CORRECTION.md`
- `docs/V0_75_Nico_Voyeur_Photo_Pact_Correction_Report.md`

Their current canon content remains preserved in:

```text
docs/canon/characters/NICO_CANON_FULL.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
docs/canon/characters/NICO_CANON_DEPRECATION_MAP.md
```

No Nico narrative decision is removed.

## 5. Nico consolidation result

`NICO_CANON_FULL.md` is now the single complete Nico source of truth.

It contains:

- real attraction to Marie;
- real attraction to Mathilde;
- jealousy of Player's domestic access;
- voyeuristic curiosity;
- Player / Nico shared gaze;
- photo exchange;
- reciprocal image offers;
- mutual alibis and debt;
- public, private, and adult image origins;
- authorized shared gaze;
- unapproved sexual recontextualization or circulation;
- severe non-consensual capture guardrails;
- character-specific consequences;
- modular scene engines and route families.

The official reading order no longer requires a Nico supplement.

```text
one principal character
= one full primary source
```

The global NSFW canon remains required for adult-route rules.

## 6. Supporting-character policy

V0.77 establishes four documentation levels:

- principal character;
- supporting character;
- recurring minor character;
- functional extra.

A supporting character is not an unfinished principal character.

They need enough truth to:

- make a principal character's life credible;
- avoid caricature;
- carry history and consequence;
- preserve knowledge, consent, privacy, and relationship stakes;
- support modular scenes.

They do not automatically need:

- a full standalone profile;
- an independent route;
- an affection system;
- dedicated scene pools;
- independent endings;
- equal documentation mass.

A standalone file becomes justified only if the character gains material independent narrative weight, such as:

- a playable or sustained adult route;
- a multi-scene independent arc;
- interaction with several principal routes;
- independent knowledge / secret / consent tracking;
- recurring direct participation in adult group content;
- a distinct runtime state model;
- explicit promotion by the Product Owner.

## 7. Jeff decision

Jeff is officially a supporting character anchored to Sandra.

Current first source:

```text
docs/canon/characters/SANDRA_CANON_FULL.md
```

Current locked decision:

- no standalone Jeff profile is planned at the current scope;
- he is not a playable route;
- he is not an independent answer to the central couple crisis;
- he is not required to carry a separate modular scene architecture;
- he remains human and concrete enough for Sandra's relationship, house, fatigue, betrayal, departure, or renegotiation to have weight;
- he must not become a monster merely to justify Sandra;
- he must not receive enough narrative mass to displace Sandra;
- future details are added only when a validated Sandra scene or consequence requires them.

```text
Jeff must be concrete enough that Sandra's choices matter.
He does not need to become another protagonist.
```

The same proportional principle applies to Bastien, Maud, Nora, Julie, Clara, Sophie, Malik, and other supporting anchors unless their role changes materially.

## 8. Principal-character completion state

All seven principal characters now have full concrete canon:

```text
Marie
Sandra
Player
Mathilde
Pauline
Nico
Raphaëlle
```

No principal character remains calibration-only.

## 9. General canon synchronization

The four principal entry points now agree on:

- the seven-character principal ensemble;
- Nico's single full source of truth;
- the absence of a required Nico supplement;
- Jeff's support status;
- proportional support documentation;
- the removal of the proposed standalone Jeff milestone;
- the next major documentation milestone.

The reading order now explicitly places:

```text
SUPPORTING_CHARACTER_CANON_POLICY.md
```

before old route, proof, and runtime material whenever a support character appears or is affected.

## 10. Historical-document policy

Older version reports remain historical records of their own pass.

If an older report proposes:

- a separate Nico correction source;
- a standalone Jeff profile;
- an outdated roadmap;

the V0.77 current-canon entry points supersede that recommendation.

Historical reports do not override:

- `DOCUMENTATION_READING_ORDER.md`;
- `NARRATIVE_CANON_STATUS.md`;
- `CHARACTER_CANON_INDEX.md`;
- `CHARACTERS_CANON_CURRENT.md`;
- current full character files.

## 11. Runtime impact

None.

V0.77 changes no:

- Godot scene;
- GDScript;
- narrative JSON;
- choice node;
- route variable;
- inbox thread;
- asset;
- test;
- playable line.

J1 remains unchanged.

The default choice rule remains:

```text
3 choices per runtime node
```

## 12. Implementation guidance

Before implementing future scenes:

- write principal characters from full canon;
- use the global NSFW canon for adult content;
- use the support policy for Jeff and other support anchors;
- do not create independent support-character state without validation;
- do not inherit old fixed-day route assumptions;
- validate the modular narrative window first;
- update documentation before runtime.

## 13. Roadmap

The standalone Jeff milestone is removed.

Current next step:

```text
V0.78 — Modular Narrative Arc Blueprint
```

V0.78 must define:

- main narrative spine;
- acts;
- couple states;
- narrative windows;
- modular scene pools;
- appearance conditions;
- consequences;
- inter-character interactions;
- route emergence;
- replayability;
- psychological-coherence rules.

It does not yet write J2.

## 14. Final rule

```text
Principal characters receive complete canon.
Supporting characters receive proportional truth.
Temporary corrections are consolidated.
Old schedules do not drive new runtime.

The character foundation is now stable enough
for the modular narrative architecture pass.
```
