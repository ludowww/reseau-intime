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
| Mathilde | `docs/canon/characters/MATHILDE_CANON_FULL.md` | Full concrete + NSFW current canon; supersedes calibration-only profile and old runtime assumptions |
| Pauline | `docs/canon/characters/PAULINE_CANON_FULL.md` | Full concrete + NSFW double-life canon; restores current-partner infidelity while superseding the sanitized single draft and fixed old route schedule |
| Raphaëlle | `docs/canon/characters/RAPHAELLE_CANON_FULL.md` | Current calibration canon; concrete-profile expansion still needed |
| Nico | `docs/canon/characters/NICO_CANON_FULL.md` | Current calibration canon; concrete-profile expansion still needed |

Adult / route escalation canon:

| Scope | Canon file | Status |
|---|---|---|
| NSFW / porno / routes adultes | `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` | Required for sexual escalation, explicit-route planning, tromperie, NTR/cuckold, sharing, trio/quatuor, adult photo logic, and Pauline double-life / informed-consent distinctions |

Character deprecation maps:

```text
docs/canon/characters/MATHILDE_CANON_DEPRECATION_MAP.md
docs/canon/characters/PAULINE_CANON_DEPRECATION_MAP.md
```

## 3. Reading rule

When writing a scene:

1. Read the relevant full character canon file.
2. If the scene contains sexual tension, adult escalation, photos used as arousal, cheating, NTR/cuckold, trio/quatuor, sharing, or explicit-route logic, read `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md`.
3. Read `docs/canon/NARRATIVE_CANON_STATUS.md` if the scene touches J2+ or older runtime.
4. Read the character-specific deprecation map when one exists.
5. Read the day source pack if one exists.
6. Use old addendums or runtime only to investigate history or recover a deliberately selected technical element.

For Mathilde specifically:

```text
MATHILDE_CANON_FULL.md overrides old photo/canapé, sport/racket, long-grey-sweater, J7, and early-route assumptions.
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
and the fixed J4/J5/later route order.
```

## 4. Consolidation and correction policy

New character details must not remain stranded in a new addendum.

If a later PR validates a detail, it should either:

- update the relevant full canon file directly; or
- create a temporary addendum and immediately schedule consolidation.

When a character correction changes a route engine, consent rule, old-document interpretation, or ensemble function, the same PR must also update every affected general entry point:

- `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md`;
- `docs/canon/DOCUMENTATION_READING_ORDER.md`;
- `docs/canon/NARRATIVE_CANON_STATUS.md`;
- `docs/canon/CHARACTERS_CANON_CURRENT.md`;
- the version report;
- the relevant deprecation map.

Do not leave the full character file and general canon describing different versions of the same person.

## 5. Sandra terminology policy

Do not use the English word `shift` in current writing.

Use concrete French wording:

- `horaires décalés`;
- `poste du matin`;
- `poste du soir`;
- `poste de nuit`;
- `fin de poste`;
- `week-end travaillé`.

This colors Sandra's life rhythm; it is not a gameplay system.
