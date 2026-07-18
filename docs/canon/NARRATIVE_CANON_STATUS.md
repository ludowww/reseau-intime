# Narrative Canon Status — Current

> **Current phase: technical-resumption decision**

The Season 1 narrative corpus J01–J21 is signed off.

There is no remaining narrative blocker.

```text
UI‑FOUNDATION: validated
UI‑SCREENS: validated
UI‑HANDOFF: validated
Technical resumption: ready but not yet explicitly authorized
```

---

## 1. Authority chain

```text
Project documentation governance
→ North Star and player experience
→ Character canon and voices
→ Routes, sequences and scenes
→ Consolidated narrative scripts
→ Trace / promise / knowledge registries
→ Narrative state contract and reachability
→ Final narrative corpus sign-off
→ Canonical UI system
→ Explicit technical-resumption decision
→ Runtime adaptation
```

Runtime does not define narrative or UI authority.

---

## 2. Narrative status

```text
Architecture J01–J21: validated
Scripts J01–J21: consolidated
Global dialogue audit: validated
Correction lot A: consolidated
Narrative contract lot B: validated
Source consolidation lot C: validated
Voice polish lot D: validated
Final narrative corpus sign-off: validated
Remaining narrative blocker: none
```

Authoritative sign-off:

```text
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
```

---

## 3. UI status

The UI canon validates:

```text
portrait target: 720 × 1280
ratio: 9:16
style: dark anime-inspired
character identity: color + avatar + name + position
MVP navigation: Messages / Galerie
Gallery: classic photo grid organized by character tabs
system screens: separate from the diegetic phone
screen inventory: complete
integration handoff: complete
```

Sources:

```text
docs/canon/ui/README.md
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

The `UI_01–03` prefixes define document reading order, not work phases.

Concept mockups are references, not final assets or canonical character designs.

Critical UI rules:

- direct chat stops during physical co-presence ;
- text resumes only after real separation ;
- image actions are permission-gated ;
- removing an image does not erase messages or knowledge ;
- locked gallery content never exposes a spoiler ;
- routes, scores and internal IDs remain invisible.

---

## 4. Runtime status

The current Godot prototype remains useful but historical relative to the signed product target.

```text
current viewport: 1280 × 720 horizontal
future target: 720 × 1280 portrait
active code: accumulated V0.xx prototype layers
J01–J04: several targeted reconciliations exist
J05–J06: must be re-audited from signed canon
J07+: historical runtime material is not authoritative for final adaptation
```

The open draft PR #54 is not an automatic base for future work.

A future branch must start from current `main` and cite the active narrative and UI sources.

---

## 5. Technical-resumption boundary

No global runtime migration begins until Ludovic explicitly authorizes `T‑UI‑01`.

The first technical step must be:

```text
short documentation-first T‑UI‑01 plan
→ current main
→ portrait shell only
→ no narrative migration
→ Hermes local Godot validation
```

The plan must cite:

```text
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
docs/runtime/README.md
```

---

## 6. Documentation authority

```text
Governance : docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
Narration  : docs/canon/dialogues/ + contracts
UI         : docs/canon/ui/
Runtime    : code, data, tests + docs/runtime/README.md
Status     : README.md + ROADMAP.md
```

Older V0.xx documents remain historical evidence unless an active index explicitly references them.

---

## 7. Superseded legacy concepts

The following are not authoritative product concepts:

```text
lie score
truth tendency
attachment score
route owner
wave owner
candidate pool as woman selection
external ticket as route access
automatic R2 owner
visible route percentage
```

Future implementation uses bounded states, promises, obligations, traces, knowledge and active contradictions.

---

## 8. UI screen inventory

### Diegetic

```text
D01 conversation list
D02 direct conversation
D03 group conversation
D04 off-phone transition
D05 photo viewer
D06 gallery by character
D07 day transition
```

### System

```text
S01 title
S02 pause
S03 save / load
S04 settings
S05 first Player configuration
S05B adult content warning
S06 confirmations and errors
S07 credits / legal
```

---

## 9. Next work

```text
1. Ludovic explicitly authorizes or rejects technical resumption
2. if authorized, Hermes writes a short T‑UI‑01 plan from current main
3. validate the plan
4. implement the portrait shell before narrative migration
5. continue with Messages, Gallery, system screens, then J01–J06
```

---

## 10. Final rule

```text
The narrative corpus is signed.
The UI target and handoff are complete.
The horizontal runtime is a prototype to reconcile, not a product specification.
No new document may create a second active truth.
No technical migration begins without explicit authorization.
```
