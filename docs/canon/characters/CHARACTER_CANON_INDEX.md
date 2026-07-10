# Character Canon Index — Full Detail

> Canon index for detailed character reference files.  
> These files are the first source for writing scenes.  
> They consolidate validated profiles, voice rules, route intent, and current product decisions.

## 1. Core rule

```text
Write scenes from full character canon files, not summaries.
For sexual escalation, also read the NSFW character route canon.
Older addendums and runtime remain historical/support material if they conflict.
```

## 2. Full character canon files

| Character | Full canon file | Status |
|---|---|---|
| Marie | `docs/canon/characters/MARIE_CANON_FULL.md` | Full concrete current canon |
| Sandra | `docs/canon/characters/SANDRA_CANON_FULL.md` | Full concrete current canon |
| Player | `docs/canon/characters/PLAYER_CANON_FULL.md` | Full concrete current canon |
| Mathilde | `docs/canon/characters/MATHILDE_CANON_FULL.md` | Full concrete + NSFW current canon |
| Pauline | `docs/canon/characters/PAULINE_CANON_FULL.md` | Full concrete + NSFW double-life canon |
| Nico | `docs/canon/characters/NICO_CANON_FULL.md` | Full concrete + NSFW social-mirror / domestic-access / photo-pact canon; read supplemental correction below |
| Raphaëlle | `docs/canon/characters/RAPHAELLE_CANON_FULL.md` | Full concrete + NSFW chosen-transformation / clear-secret canon |

All seven principal characters now have full concrete canon.

## 3. Required supplements and global adult canon

Adult / route escalation canon:

| Scope | Canon file | Status |
|---|---|---|
| NSFW / porno / routes adultes | `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` | Required for sexual escalation, roleplay, tromperie, photos, voyeurism, NTR/cuckold, sharing, trio/quatuor, open arrangements, and dark-route distinctions |

Current character-specific supplement:

```text
docs/canon/characters/NICO_CANON_VOYER_PHOTO_PACT_CORRECTION.md
```

This supplement is current canon and must be read after `NICO_CANON_FULL.md` until a later character-reconciliation pass folds it directly into the full Nico file.

The global NSFW canon now incorporates its main rules:

- Nico's attraction to Mathilde;
- domestic-access envy;
- Player / Nico photo and alibi pact;
- authorized shared gaze vs unapproved circulation;
- severe-capture guardrails.

## 4. Character deprecation maps

```text
docs/canon/characters/MATHILDE_CANON_DEPRECATION_MAP.md
docs/canon/characters/PAULINE_CANON_DEPRECATION_MAP.md
docs/canon/characters/NICO_CANON_DEPRECATION_MAP.md
docs/canon/characters/RAPHAELLE_CANON_DEPRECATION_MAP.md
```

## 5. Supporting-character status

Jeff remains a concrete and important supporting character whose current first source is Sandra's full canon.

| Character | Current source | Status |
|---|---|---|
| Jeff | `docs/canon/characters/SANDRA_CANON_FULL.md` | Concrete supporting canon inside Sandra's profile; standalone pass still needed before final character reconciliation |

Until that pass:

- preserve the six-year relationship with Sandra;
- preserve their shared house;
- preserve his work as a mason;
- preserve his tired, blunt, non-verbal communication;
- allow him to hurt Sandra through repeated small phrases without turning him into a monster;
- do not invent a standalone biography that contradicts Sandra's canon.

## 6. Reading rule

When writing a scene:

1. Read the relevant full character canon file.
2. For Nico, also read `NICO_CANON_VOYER_PHOTO_PACT_CORRECTION.md`.
3. If the scene contains sexual tension, adult escalation, roleplay, photos, voyeurism, cheating, NTR/cuckold, trio/quatuor, sharing, open arrangements, or explicit-route logic, read `NSFW_CHARACTER_ROUTE_CANON.md`.
4. Read `NARRATIVE_CANON_STATUS.md` if the scene touches J2+ or older runtime.
5. Read the character-specific deprecation map when one exists.
6. Read the validated day source pack or modular-window blueprint when one exists.
7. Use old addendums or runtime only to investigate history or recover a deliberately selected technical element.

For Mathilde specifically:

```text
MATHILDE_CANON_FULL.md overrides old photo/canapé,
sport/racket,
long-grey-sweater,
J7,
and early-route assumptions.
```

For Pauline specifically:

```text
PAULINE_CANON_FULL.md restores the current relationship with Bastien,
prior hidden infidelity,
Marie's partial knowledge,
and double-life temptation.

It overrides the single-Pauline first V0.74 draft,
omniscient-photo-controller framing,
constant-halo framing,
playable-vocal assumptions,
and fixed old route order.
```

For Nico specifically:

```text
NICO_CANON_FULL.md
+ NICO_CANON_VOYER_PHOTO_PACT_CORRECTION.md
preserve real attraction to Marie and Mathilde,
domestic-access envy,
friend/rival ambiguity,
direct male desire,
and photo/alibi-pact routes.

They override automatic villain framing,
Marie-as-prize framing,
omniscient Don Juan assumptions,
jealousy-as-permission,
clean unapproved image circulation,
and fixed old jealousy schedules.
```

For Raphaëlle specifically:

```text
RAPHAELLE_CANON_FULL.md preserves office precision,
elegance,
cultures,
serious cosplay,
chosen versions,
rare tender faults,
and clear adult framing.

It overrides therapist framing,
automatically healthy-route assumptions,
abstract clarity without desire,
exotic-sage framing,
cosplay-as-gadget,
and fixed old J2/J5/J8/J10 chronology.
```

## 7. Consolidation and correction policy

New character details must not remain stranded in conversation.

If a later PR validates a detail, it should either:

- update the relevant full canon file directly; or
- create a clearly named temporary correction file and schedule consolidation.

When a character correction changes a route engine, consent rule, old-document interpretation, or ensemble function, the same PR must update every affected general entry point:

- `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md`;
- `docs/canon/DOCUMENTATION_READING_ORDER.md`;
- `docs/canon/NARRATIVE_CANON_STATUS.md`;
- `docs/canon/CHARACTERS_CANON_CURRENT.md`;
- the version report;
- the relevant deprecation map;
- implementation guidance and PR description.

```text
Do not leave the full character file
and the general canon
describing different versions of the same person.
```

## 8. Sandra terminology policy

Do not use the English word `shift` in current writing.

Use concrete French wording:

- `horaires décalés`;
- `poste du matin`;
- `poste du soir`;
- `poste de nuit`;
- `fin de poste`;
- `week-end travaillé`.

This colors Sandra's life rhythm; it is not a gameplay system.
