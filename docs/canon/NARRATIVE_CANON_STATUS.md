# Narrative Canon Status — Current

> **Current phase: UI‑SCREENS — final screen specifications and concepts**

The Season 1 narrative corpus J01–J21 is signed off.

There is no remaining narrative blocker.

UI‑FOUNDATION is validated. The current product work is completing the missing UX/UI screens before a separate technical-resumption decision.

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

UI‑FOUNDATION validates:

```text
portrait target: 720 × 1280
ratio: 9:16
style: dark anime-inspired
character identity: color + avatar + name + position
MVP navigation: Messages / Galerie
Gallery: classic photo grid organized by character tabs
system screens: separate from the diegetic phone
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

## 5. Technical freeze

No global runtime migration may begin until:

1. UI‑SCREENS completes the missing screen specifications ;
2. UI‑HANDOFF confirms the integration contract ;
3. Ludovic explicitly authorizes technical resumption.

Small documentary or visual-concept work remains allowed.

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
S06 confirmations
S07 credits / legal
```

---

## 9. Next work

```text
1. produce UI‑SCREENS specifications and final concepts for missing screens
2. validate UI‑HANDOFF integration contract
3. decide explicitly whether to resume technical work
4. if approved, implement portrait shell before narrative migration
```

---

## 10. Final rule

```text
The narrative corpus is signed.
UI‑FOUNDATION defines one canonical UI target.
The horizontal runtime is a prototype to reconcile, not a product specification.
No new document may create a second active truth.
```
