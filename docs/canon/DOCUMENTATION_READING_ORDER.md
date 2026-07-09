# Documentation Reading Order — Canon Current

> Canon entry point.  
> Use this file before reading older narrative, character, route, or runtime-planning documentation.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Purpose

The project contains several generations of documentation and recent character refoundations.

Important character details must not remain scattered across addendums.

Current rule:

```text
Write from full canon, not from summaries.
```

---

## 2. Current canon entry points

Read in this order:

1. `docs/canon/NARRATIVE_CANON_STATUS.md`
2. `docs/canon/characters/CHARACTER_CANON_INDEX.md`
3. the relevant full character canon file:
   - `docs/canon/characters/MARIE_CANON_FULL.md`
   - `docs/canon/characters/SANDRA_CANON_FULL.md`
   - `docs/canon/characters/PLAYER_CANON_FULL.md`
   - `docs/canon/characters/MATHILDE_CANON_FULL.md`
   - `docs/canon/characters/PAULINE_CANON_FULL.md`
   - `docs/canon/characters/RAPHAELLE_CANON_FULL.md`
   - `docs/canon/characters/NICO_CANON_FULL.md`
4. `docs/canon/J1_CANON_SOURCE_PACK.md` when working on J1
5. `docs/V0_64_J1_Naturalized_Script_Draft.md` only when exact J1 line text is needed
6. Voice / intensity bibles only as support material
7. Older arc / spine / proof / route documents only if explicitly cross-checked against the canon files above

`docs/canon/CHARACTERS_CANON_CURRENT.md` remains as a doorway, but the full per-character files are the character source-of-truth.

---

## 3. Current rule for old files

Older files are not deleted, but they no longer act as direct truth when they contradict the consolidated canon.

This applies especially to:

- old J1-J10 scenario spine material;
- old character arcs;
- old proof / secret maps after J3;
- old route reachability assumptions;
- runtime JSON produced before the Marie / Sandra / Player refoundations;
- any addendum that has not yet been consolidated.

---

## 4. Current rule for runtime

Existing runtime may be technically valid while narratively outdated.

```text
runtime existing != narrative canon
```

After the character refoundation, any narrative JSON touching J2+ must be reviewed before being treated as current story truth.

J1 must be rebuilt from the current J1 canon source pack, not from older runtime assumptions.

---

## 5. Current rule for Sandra terminology

Do not use the English word `shift` as a primary writing term.

Use:

```text
horaires décalés
poste du matin
poste du soir
poste de nuit
week-end travaillé
fin de poste
```

Meaning:

```text
Sandra sometimes works outside ordinary office hours at SentryCore.
This creates tired evenings, late replies, odd-hour intimacy, and small traces after work.
It is not a gameplay system and not a technical mechanic.
```

If this detail clutters a scene, omit it. Sandra's core remains concrete trace + cautious warmth + soft boundary.

---

## 6. Canon maintenance rule

When a new character profile, day source pack, or narrative audit changes the story, update the relevant full canon file first.

Do not create another isolated addendum unless it is immediately scheduled for consolidation.
