# V0.63 — Documentation Cleanup & Legacy Status Map

> Documentation-only cleanup map.  
> Purpose: classify older documentation after the V0.57 route rework, V0.59 macro beat plan, V0.62 voice reconciliation, and recent Marie / Sandra / Player concrete profiles.  
> No runtime, narrative JSON, tests, assets, or playable content are changed.  
> No files are deleted in this pass.

## 1. Purpose

The documentation now contains several generations of narrative planning.

Some older documents still contain useful principles, but several are no longer safe as direct writing or runtime-integration sources.

This map exists to prevent future confusion.

It answers:

- Which documents are current source-of-truth?
- Which documents remain useful as voice, palette, rhythm, or anti-pattern references?
- Which older documents are historical or partially compatible?
- Which older day plans must not be used directly for J1/J2/J3+ writing without checking newer docs?

```text
Do not delete narrative history too early.
First classify it.
Then decide later what should be archived, rewritten, or removed.
```

---

## 2. Global reading hierarchy

### Tier A — Current active writing truth

Use first for current writing decisions.

| Document | Status | Use |
|---|---|---|
| `docs/V0_57_Route_Character_Rework_Blueprint.md` | Current macro blueprint | Route / character rework foundation |
| `docs/V0_59_Reworked_J1_J9_Beat_Plan.md` | Current macro beat direction | J1→J9 macro direction, not direct day integration |
| `docs/V0_62_Character_Voice_Reconciliation_Report.md` | Current voice hierarchy | Resolves concrete profiles vs older bibles |
| `docs/Marie_Concrete_Profile_V2.md` | Current Marie source | Marie character truth |
| `docs/Marie_Concrete_Profile_V2_Details_Addendum.md` | Current Marie details | Marie concrete anchors / J1-J2 writing |
| `docs/Sandra_Concrete_Profile_V2.md` | Current Sandra source | Sandra character truth |
| `docs/Sandra_Concrete_Profile_V2_Details_Addendum.md` | Current Sandra details | Work / couple / refuge / social behavior |
| `docs/Sandra_Concrete_Profile_V2_Final_Choices_Addendum.md` | Current Sandra final choices | Jeff / Maison des Tilleuls / SentryCore / readings |
| `docs/Player_Concrete_Profile_V2.md` | Current Player source | Player concrete playable texture |
| `docs/V0_60_J1_Reworked_Script_Plan.md` | Current J1 plan | J1 structure before runtime |
| `docs/V0_61_J1_Reworked_Script_Draft.md` | Draft J1 content | Plain-text draft, needs naturalization before runtime |

### Tier B — Active guardrails / calibration

Still valid, but not complete source-of-truth for Marie / Sandra / Player biographies.

| Document | Status | Use |
|---|---|---|
| `docs/Character_Playable_Voice_Cards.md` | Active voice cards | Base voices, Messenger rhythm, guardrails |
| `docs/Character_Voice_Messenger_Intensity_Bible.md` | Active intensity bible | Messenger pacing, emojis, photos, route intensity |
| `docs/Character_Voice_Color_Addendum.md` | Active palette | Secondary colors, private codes, texture |
| `docs/Character_Voice_Post_Etalons_Addendum.md` | Active correction layer | Anti-patterns, naturalization, secondary palettes |
| `docs/Sandra_Player_Address_Formula_Addendum.md` | Active narrow addendum | Sandra / Player address formulas |

### Tier C — Active state summaries / continuity aids

Useful summaries, but must be checked against the newest source packs and PRs.

| Document | Status | Use |
|---|---|---|
| `docs/story_state/GLOBAL_STORY_STATE.md` | Active summary | Current story state snapshot, may need refresh after source-pack merges |
| `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md` | Active summary | Continuity matrix, check against new concrete profiles |
| `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md` | Active rhythm guide | Pacing and density principles |
| `docs/narrative/PROOF_AND_SECRET_MAP.md` | Active proof guide | Trace / proof / secret handling |

---

## 3. Older documents requiring caution

These documents may still contain useful ideas, but they must not override V0.57+ / V0.59+ / V0.62+ or the concrete character profiles.

| Document | Status | Use allowed | Source that primes over it | Action |
|---|---|---|---|---|
| `docs/03_ROUTE_ARCHITECTURE.md` | Partially compatible | Macro architecture references only | V0.57, V0.59, V0.62 | Add caution banner in later pass if not already present |
| `docs/16_ROUTE_REACHABILITY_MATRIX.md` | Partially compatible | Historical reachability / route thinking | V0.57, V0.59 | Do not use for current route locks without review |
| `docs/17_VERTICAL_SLICE_BEAT_SHEET.md` | Partially compatible / historical | Older slice reference | V0.59, V0.60, V0.61 | Do not use for current J1 runtime |
| `docs/19_DAY_2_REVEALS_AND_SCENE_FLOW.md` | Partially compatible / older day plan | Historical J2 ideas only | future V0.6x J2 source pack | Do not integrate directly |
| `docs/20_DAY_3_PARTY_PIVOT_PLAN.md` | Partially compatible / older day plan | Historical J3 ideas only | future V0.6x J3 source pack | Do not integrate directly |
| `docs/21_DAY_4_FIRST_PROOF_PLAN.md` | Partially compatible / older day plan | Historical J4 proof ideas | future V0.6x J4 source pack | Do not integrate directly |
| `docs/narrative/SCENARIO_SPINE_J1_J10.md` | Partially compatible | Broad spine ideas only | V0.57, V0.59, new day source packs | Do not use as direct day script source |
| `docs/narrative/CHARACTER_ARCS_J1_J10.md` | Partially compatible | Older arc direction | concrete profiles V2, V0.62 | Reconcile before using for Marie/Sandra/Player |
| `docs/narrative/J5_J6_REWRITE_PLAN.md` | Partially compatible / historical | Future J5-J6 inspiration only | V0.59 and future J5-J6 packs | Review before use |
| `docs/V0_56_Narrative_Continuity_Audit_J1_J9.md` | Historical audit | Audit context only | V0.57+ and V0.59+ | Keep as history |
| `docs/V0_58_Documentation_Reconciliation_Report.md` | Historical reconciliation | Useful prior cleanup context | V0.62 / V0.63 | Superseded for current doc status |

---

## 4. Documents that should not drive current J1 work

For J1 specifically, the following must **not** be used as direct script/runtime sources:

- any older J1/J2/J3 plan predating V0.60;
- `docs/17_VERTICAL_SLICE_BEAT_SHEET.md`;
- `docs/narrative/SCENARIO_SPINE_J1_J10.md`;
- `docs/narrative/CHARACTER_ARCS_J1_J10.md`;
- any older runtime assumption that introduces Nico / Pauline / Raphaëlle on J1;
- any older assumption that makes Sandra a strong active route on J1;
- any older assumption that makes Marie primarily jealous or suspicious on J1.

Current J1 source order:

1. `docs/V0_60_J1_Reworked_Script_Plan.md`
2. `docs/V0_61_J1_Reworked_Script_Draft.md`
3. `docs/V0_62_Character_Voice_Reconciliation_Report.md`
4. Marie / Sandra / Player concrete profiles
5. voice bibles and post-etalon correction layer

---

## 5. Banners to apply in future cleanup passes

This V0.63 pass creates the map first. It does not delete files.

Recommended banner types:

### Current source banner

```markdown
> **Status:** Current source-of-truth for its scope.  
> Use this before older planning documents when writing or integrating current content.
```

### Partially compatible banner

```markdown
> **Status:** Partially compatible legacy document.  
> Useful for context, but do not use as direct writing/runtime source without checking V0.57+, V0.59+, V0.62+, and current concrete character profiles.
```

### Historical banner

```markdown
> **Status:** Historical reference.  
> Kept to explain previous decisions. Do not use as source for current runtime integration.
```

### Deprecated-for-writing banner

```markdown
> **Status:** Deprecated for current writing.  
> Preserve for history only. Do not use for new day scripts, JSON integration, route locks, or character truth.
```

---

## 6. Cleanup strategy

Do not delete large documents immediately.

Recommended sequence:

1. Create this status map.
2. Add caution banners to the most risky older docs.
3. During each future day-source-pack pass, update or supersede the relevant older day docs.
4. Only after a document has been safely superseded and unused, decide whether to archive or delete it.

Deletion should be reserved for documents that are:

- actively misleading;
- duplicated by newer docs;
- not cited by current source hierarchy;
- clearly marked obsolete by a later PR.

---

## 7. Immediate next steps

After V0.63:

1. Add banners to the highest-risk older docs if needed.
2. Continue with J1 naturalization as V0.64.
3. Do not request runtime integration until V0.64 is validated.

Recommended next PR:

```text
V0.64 — J1 Naturalization & Voice Compliance Pass
```

Scope:

- revise `docs/V0_61_J1_Reworked_Script_Draft.md` or add a revised V0.64 draft;
- reduce over-cleverness;
- add low-level emojis sparingly;
- make Player more ordinary where needed;
- preserve J1 structure;
- still no runtime / JSON.

---

## 8. Final rule

```text
Old documents are not wrong because they are old.
They are dangerous only when read as current truth after newer source packs exist.

Classify first.
Rewrite or archive second.
Delete last.
```
