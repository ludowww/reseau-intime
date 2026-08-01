# Narrative Canon Status — Current

> **Current phase: signed canon with Season 1 runtime present on the locked baseline**

The Season 1 narrative corpus J01–J21 is signed off.

There is no remaining narrative blocker.

```text
UI‑FOUNDATION: validated
UI‑SCREENS: validated
UI‑HANDOFF: validated
Season 1 runtime J01–J21: present on the current baseline
Latest explicitly locked product milestone: J11 A5
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
→ Runtime adaptation on an explicit product lot
→ Baseline verification through code, data and tests
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

The current baseline contains the portrait Season 1 runtime from J01 through J21.
`Season1RuntimeProvider` orchestrates the day providers, and J09–J12 have dedicated
providers, runtime data and tests. J11 A5 is the latest explicitly locked product
milestone.

```text
baseline: fa2880c1ad168569b148ed85bedf4774324f87dd
locked tag: runtime-s1-11e-j11-a5-scene-presentation
runtime present: J01–J21
```

Runtime presence does not certify exhaustive polish, final content delivery or an
entirely green global test gate.

---

## 5. Runtime and asset boundary

The signed canon remains the narrative authority; code, data and tests on the
baseline remain the execution authority. The common visual pipeline is operational
through `VisualMediaResolver` and `ResourceLoader`, but placeholders and prototypes
are not final assets. J11 A5 has two Gallery parents and six sequence children; none
of the six final assets is delivered, so **“Visuel non livré”** remains expected.

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
1. prepare a future lot limited to the six J11 A5 child assets
2. preserve the two Gallery parents and ordered triplets
3. use the common visual delivery pipeline
4. validate actual delivery before removing the fallback
5. do not expand that lot into a complete Act III manifest
```

---

## 10. Final rule

```text
The narrative corpus is signed.
The Season 1 J01–J21 runtime is present on the locked baseline.
J11 A5 is the latest explicitly locked product milestone.
The six final J11 A5 child assets are not delivered.
No new document may create a second active truth.
Runtime presence does not imply exhaustive polish or final asset delivery.
```
