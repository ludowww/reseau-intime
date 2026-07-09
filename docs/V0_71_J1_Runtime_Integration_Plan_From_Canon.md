# V0.71 — J1 Runtime Integration Plan From Canon

> Documentation-only runtime integration plan.  
> This file prepares the Hermes prompt for J1 integration, but does not modify runtime JSON, tests, assets, or playable content.  
> J1 runtime integration must be done in a later PR by Hermes/Codex.

## 1. Purpose

This plan tells Hermes how to replace / realign the current J1 runtime with the current canon source.

Current J1 exact line source:

```text
docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md
```

Current J1 source pack:

```text
docs/canon/J1_CANON_SOURCE_PACK.md
```

Choice rule:

```text
docs/canon/CHOICE_DESIGN_CANON.md
```

Character canon:

```text
docs/canon/characters/MARIE_CANON_FULL.md
docs/canon/characters/SANDRA_CANON_FULL.md
docs/canon/characters/PLAYER_CANON_FULL.md
```

NSFW canon:

```text
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

For J1, NSFW canon is context only. J1 remains Tier 1 / everyday charge, not explicit content.

---

## 2. Runtime files to inspect

Hermes must inspect existing files before editing.

Known current J1 runtime files:

```text
game/data/conversations/chapter_01_index.json
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_01_sandra.json
game/data/visual_content/chapter_01_proofs.json
```

Current `chapter_01_index.json` already identifies:

- `chapter_01_marie`;
- `chapter_01_sandra`;
- `chapter_01_marie.json`;
- `chapter_01_sandra.json`;
- `chapter_01_proofs.json`.

Do not assume other files without inspecting.

---

## 3. Current runtime diagnosis

The current J1 runtime is technically structured around Marie and Sandra, but it predates the current canon line source.

Known mismatches to fix during the later runtime PR:

### Marie current runtime

Current runtime still begins from older `Tu rentres vers quelle heure ? / pain` material and contains Mathilde bag / sport / raquette traces and a Marie kitchen visual.

This is not necessarily broken technically, but it no longer matches the V0.69 exact line source.

The new J1 should use:

- tomatoes;
- cheese / dinner;
- missing bread;
- couch;
- walk;
- La Verrière color beat;
- optional Mathilde lighting seed only if kept indirect.

### Sandra current runtime

Current runtime currently uses:

- phone resurfacing a photo;
- lunch memory;
- bad coffee;
- lake / nature;
- romance novel mention;
- tomatoes dodge.

V0.69 instead requires:

- Sandra finds / prints an old lunch photo after work;
- SentryCore anchor;
- ticket fantôme / missing button;
- hot chocolate;
- French `poste / fin de poste` terminology;
- no romance-reading exposition on J1;
- one soft boundary.

### Visual content current runtime

Current `chapter_01_proofs.json` has three soft visuals:

- `j1_marie_kitchen_soft`;
- `j1_mathilde_bag_domestic_trace`;
- `j1_sandra_lunch_memory_soft`.

V0.69 / J1 source pack prefers:

- one Sandra lunch trace if scope is tight;
- optional Marie dinner trace;
- Mathilde indirect only, no active thread.

Hermes must decide whether to update visual content now or keep placeholders if no asset/runtime visual scope is requested. The recommended first runtime pass should focus on conversation text and leave visual asset changes minimal unless needed for consistency.

---

## 4. Target J1 runtime structure

Recommended final runtime structure:

```text
chapter_01_index.json
  initial_conversation_ids: [chapter_01_marie]
  locked_conversation_ids: [chapter_01_sandra]
  unlock chapter_01_sandra after chapter_01_marie completed
```

Keep the two-thread runtime structure:

1. `chapter_01_marie`
2. `chapter_01_sandra`

No new active J1 conversations:

- no Nico;
- no Pauline;
- no Raphaëlle;
- no Mathilde active thread;
- no group thread.

---

## 5. Target Marie runtime structure

`chapter_01_marie.json` should represent three Marie blocks from V0.69:

1. Opening domestic warmth.
2. La Verrière color beat, with optional Mathilde indirect seed.
3. End-of-day close after Sandra / presence check.

Depending on the current runtime engine, Hermes may implement these as either:

- one conversation with sequential segments; or
- multiple segments with guided replies / choice followups.

Hermes must preserve the existing data-first conversation schema.

### Required Marie content

Use V0.69 exact line source for:

- `Deux tomates, un reste de fromage...`
- `Il manque juste le pain.`
- walk request;
- La Verrière logos / provider / Élodie beat;
- final bread / dinner / tomatoes / cheese close.

### Optional Mathilde seed

Allowed only as indirect line through Marie:

```text
Mathilde veut passer voir l'installation demain.
```

No active Mathilde thread.

Avoid old Mathilde bags / sport / raquette material unless explicitly retained as a soft indirect visual trace in a separate visual pass.

---

## 6. Target Sandra runtime structure

`chapter_01_sandra.json` should represent two Sandra blocks from V0.69:

1. Trace re-entry.
2. Soft boundary.

### Required Sandra content

Use V0.69 exact line source for:

- old lunch photo;
- printed photo after work;
- `mon poste` / `fin de poste` wording;
- SentryCore;
- ticket fantôme;
- missing button;
- hot chocolate;
- soft goodnight.

### Removed / avoided from old runtime

Do not keep as J1 active content unless user explicitly restores it:

- romance novel exposition;
- lake / nature as main anchor;
- tomato dodge;
- bad coffee as the central scene;
- any English `shift` wording.

Sandra can still be soft and cautious, but her current canon engine is trace + work anchor + boundary.

---

## 7. Choice-count rule for runtime

J1 must use three runtime choices per choice node.

Authoring variants in V0.69 may show four possible variants, but runtime must collapse them.

Recommended mapping:

### M1 — Opening Marie response

```text
1. Present
2. Joke, but present
3. Flat / delayed
```

### S1 — Sandra photo response

```text
1. Safe warmth
2. Precise observation
3. Playful or cautious
```

### M2 — Return to Marie / presence check

```text
1. Active return
2. Awkward but sincere
3. Joke / distant
```

Hermes must not integrate four choices in J1 unless a later plan explicitly justifies the exception.

---

## 8. Flags / routes / effects

J1 must not create route locks.

Allowed effects:

- small Marie presence / distance signal;
- small Sandra warmth / cautious signal;
- simple guided reply flags if existing runtime requires them;
- completion flags needed by the engine.

Forbidden effects:

- route lock;
- hard secret system;
- adult route unlock;
- NTR / sharing / trio / quatuor activation;
- Nico / Pauline / Raphaëlle activation;
- Mathilde active route state beyond indirect seed.

If existing runtime uses `sets_flags`, keep them minimal and do not introduce permanent route commitments.

---

## 9. Visual content guidance

For first runtime integration, prefer minimal visual churn.

Acceptable options:

### Option A — Text-first runtime pass

- Keep existing `chapter_01_proofs.json` unchanged temporarily.
- Ensure no visual is treated as proof or route lock.
- Mark future visual cleanup separately.

### Option B — Light visual alignment

Update visual references toward canon:

- prefer `j1_sandra_lunch_photo_blurry` / equivalent existing Sandra lunch visual;
- optional Marie dinner trace;
- Mathilde visual remains indirect only if kept.

Recommended for the first Hermes runtime pass: **Option A unless the user explicitly asks for visual cleanup now**.

---

## 10. Validation commands for Hermes

After runtime integration, Hermes should run at least:

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

If tests fail because existing static tests assert old J1 text / IDs, Hermes may update tests narrowly, but only to reflect the intended J1 runtime rewrite.

---

## 11. Acceptance criteria

A future J1 runtime PR is acceptable if:

- only J1 runtime/data files are modified, unless tests require narrow updates;
- active J1 conversations remain Marie + Sandra only;
- Mathilde remains indirect only;
- no Nico / Pauline / Raphaëlle / group conversation is introduced;
- V0.69 exact lines are used as the source of truth;
- Sandra uses French `poste / fin de poste` wording, not `shift`;
- no romance-reading exposition remains in J1 Sandra runtime;
- choice nodes use three choices max unless explicitly justified;
- no route lock, hard secret system, adult escalation, or NSFW route activation is introduced;
- final J1 emotional center returns to Marie / shared life;
- all validation commands pass.

---

## 12. Hermes prompt draft

```text
Repo: ludowww/reseau-intime
Task: V0.71+ J1 runtime integration from canon.

Start from current main. Create a short branch, for example:
work/j1-runtime-from-canon-v0-72

Goal:
Rewrite / realign J1 runtime data from the current canon, using:
- docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md as exact line source
- docs/canon/J1_CANON_SOURCE_PACK.md as J1 structure source
- docs/canon/CHOICE_DESIGN_CANON.md for 3-choice rule
- docs/canon/characters/MARIE_CANON_FULL.md
- docs/canon/characters/SANDRA_CANON_FULL.md
- docs/canon/characters/PLAYER_CANON_FULL.md
- docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md only as future-route context, not explicit J1 content

Inspect before editing:
- game/data/conversations/chapter_01_index.json
- game/data/conversations/chapter_01_marie.json
- game/data/conversations/chapter_01_sandra.json
- game/data/visual_content/chapter_01_proofs.json
- relevant tests that mention chapter_01 or J1

Scope:
- J1 only
- no J2+ changes
- no new systems
- no new active characters
- no route locks
- no adult explicit content
- no NSFW route activation
- keep data-first JSON structure

Required J1 runtime structure:
- Marie active first
- Sandra unlocks after Marie completion
- Marie and Sandra are the only active conversations
- Mathilde indirect only if used through Marie
- no Nico, Pauline, Raphaëlle, group

Choice rule:
- max 3 choices per node
- collapse authoring variants from V0.69 to three choices
- do not integrate four choices unless explicitly justified, which is not expected for J1

Visuals:
- prefer minimal visual churn in the first runtime pass
- keep existing visual content only if it remains soft, non-proof, and non-locking
- do not add explicit adult visual content

Validation:
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit

Deliver:
- concise diff summary
- list changed files
- validation output
- explicit confirmation that no J2+ runtime was changed
```

---

## 13. Final rule

```text
Do not integrate old J1 because it is already playable.
Integrate J1 because V0.69 is now the canon line source.
Keep the runtime small, readable, and limited to three choices per node.
```
