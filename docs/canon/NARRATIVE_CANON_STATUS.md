# Narrative Canon Status — Current

> Consolidated narrative status after the recent character refoundation.  
> This document clarifies how to read the older runtime, story-state docs, arcs, spine, and proof maps before any new runtime work.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Purpose

The repository contains runtime content and documentation produced in different chronological waves.

The key issue:

```text
Some runtime content exists technically, but was written before the recent Marie / Sandra / Player refoundation.
```

Therefore, existing runtime must not be treated as automatic narrative canon.

---

## 2. Chronology that matters

### Earlier narrative framework and runtime wave

- The J1-J10 scenario framework was created first.
- J5 / J6 runtime data were then rewritten from that earlier framework.
- J7 runtime data were then added from that same narrative era.

These works are technically present in the repository.

But they predate the later character refoundation.

### Later character refoundation wave

The following came later and now prime over older narrative interpretation:

- Sandra Concrete Profile V2 and addenda;
- Marie Concrete Profile V2 and addendum;
- Player Concrete Profile V2;
- V0.62 character voice reconciliation;
- V0.63 documentation cleanup map;
- V0.64 J1 naturalized script draft.

---

## 3. Current canon rule

```text
The character refoundation changes how the story must be read.
Any older narrative or runtime content touching character arcs, scenes, proofs, photos, routes, or relationship progression must be reviewed against the current character canon.
```

This includes:

- day plans;
- scenario spine;
- character arcs;
- proof and secret maps;
- route reachability;
- JSON conversations;
- visual content placeholders;
- tests that encode narrative assumptions;
- story_state summaries.

---

## 4. Current J1 status

J1 active canon is:

- `docs/canon/J1_CANON_SOURCE_PACK.md`
- `docs/V0_64_J1_Naturalized_Script_Draft.md`
- `docs/canon/CHARACTERS_CANON_CURRENT.md`

Current J1 principles:

- Marie + Sandra active;
- Player active through replies / choices;
- Mathilde indirect only;
- no Nico active thread;
- no Pauline active thread;
- no Raphaëlle active thread;
- no group conversation;
- no hard secret system;
- no route lock;
- no explicit escalation;
- final emotional center: Marie / shared life.

J1 runtime must be planned from the canon source pack, not from old runtime assumptions.

---

## 5. Current status of J2+

### J2

Status: **requires review before being treated as current narrative canon**.

Reason:

- Existing J2 material may remain technically useful;
- but character refoundation may change Marie / Sandra / Player framing;
- Mathilde / Raphaëlle / Pauline / Nico pacing also needs re-check.

### J3

Status: **requires review before canon confirmation**.

Any old J3 photo-canapé or social/panel assumptions must remain legacy unless deliberately restored.

### J4

Status: **legacy / suspended until reviewed**.

Do not assume a social/photo/Nico/Pauline-heavy J4 remains valid after character refoundation.

### J5 / J6

Status: **runtime exists, narrative canon suspended**.

Reason:

- J5/J6 were rewritten before the Marie / Sandra / Player refoundation;
- they may contain useful runtime ideas or tools;
- they must not drive future story unless re-audited and either confirmed, rewritten, or retired.

### J7

Status: **runtime exists, narrative canon suspended**.

Reason:

- J7 was added before the recent character refoundation;
- it may no longer fit the new progression if J1-J6 are rebuilt differently;
- it must not be used as a fixed future target.

### J8+

Status: **non-current unless later source pack explicitly validates it**.

---

## 6. Current status of story_state docs

`docs/story_state/GLOBAL_STORY_STATE.md` and `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md` may contain useful operational summaries, but they must be patched after this canon consolidation.

Known issue:

- they may mention future or inconsistent version numbers such as V0.66 / V0.68c;
- they may treat older runtime as active truth;
- they may mix previous conversation numbering with the current PR chronology.

Until patched, they are secondary references, not source-of-truth.

---

## 7. Current status of old narrative docs

### `docs/narrative/CHARACTER_ARCS_J1_J10.md`

Status: **must be rewritten or strongly corrected**.

Reason:

- Marie / Sandra / Player arcs predate the strongest concrete profiles;
- Sandra is still too centered on waiting / later / hiddenness;
- Player lacks enough concrete daily life and passive-delay texture;
- Marie needs more La Verrière / active life / habit-wound framing.

### `docs/narrative/SCENARIO_SPINE_J1_J10.md`

Status: **historical / macro reference only**.

Reason:

- useful for earlier strategy;
- not reliable as current day-by-day truth after character refoundation;
- J5/J6/J7 sections are not current canon.

### `docs/narrative/PROOF_AND_SECRET_MAP.md`

Status: **valid as proof typology, not as day-by-day canon**.

Useful:

- trace douce;
- preuve faible;
- preuve sociale;
- preuve dangereuse;
- photo Sandra J1 as soft trace.

Caution:

- J4/J5 proof examples must be reviewed before use.

---

## 8. What future PRs must do

### Next PR after consolidation

Recommended:

```text
V0.66 — Narrative Refoundation Audit After Character V2
```

Scope:

- patch story_state docs;
- rewrite or supersede character arcs;
- update scenario spine status;
- mark J5/J6/J7 runtime as technical legacy / suspended narrative canon;
- prepare a clean path for J1 runtime planning.

### Runtime planning after that

Recommended:

```text
V0.67 — J1 Runtime Integration Plan
```

Only after the audit confirms the source hierarchy.

---

## 9. Final rule

```text
Do not build the next runtime step on existing runtime merely because it exists.
Build it on current canon.

Existing J5/J6/J7 may inspire, but they do not govern.
```
