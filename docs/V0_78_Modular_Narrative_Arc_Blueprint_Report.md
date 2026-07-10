# V0.78 — Modular Narrative Arc Blueprint Report

> Documentation-only architecture report.  
> No runtime, narrative JSON, Godot scene, script, test, asset, or playable line is changed.

## 1. Scope

V0.78 replaces the old forward assumption of a fixed J2–J10 route chronology with a modular narrative architecture.

The pass defines:

- the fixed dramatic spine;
- post-J1 starting state;
- Act 0–V structure;
- couple-state dimensions and derived modes;
- universal route stages;
- narrative cycles and topology-changing choices;
- window types and capacity;
- modular scene pools;
- selection priority;
- obligations, traces, knowledge, and consent;
- character-specific pool functions;
- route compatibility;
- replayability;
- collision and secret-pressure rules;
- ending families;
- scene-authoring requirements;
- incremental runtime boundary.

It does not:

- write exact J2 dialogue;
- select a fixed day count;
- validate old J2+ runtime as narrative canon;
- create runtime variables;
- modify Godot or JSON;
- require a large technical refactor.

## 2. Files added

- `docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md`
- `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md`
- `docs/V0_78_Modular_Narrative_Arc_Blueprint_Report.md`

## 3. Files updated

- `docs/canon/CHOICE_DESIGN_CANON.md`
- `docs/canon/DOCUMENTATION_READING_ORDER.md`
- `docs/canon/NARRATIVE_CANON_STATUS.md`
- `docs/canon/CHARACTERS_CANON_CURRENT.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`

## 4. Central architecture decision

The story is not a collection of independent character routes.

The fixed dramatic question remains:

```text
Can Player and Marie make their couple an active choice again?
```

The target architecture is:

```text
fixed dramatic spine
+ choices that change context
+ modular narrative windows
+ character-specific scene pools
+ persistent obligations and traces
+ consequences that return to the couple
```

The other characters remain distinct responses around the couple crisis:

```text
Marie      = the couple and active reconquest
Sandra     = confidence and chosen private truth
Mathilde   = domestic proximity and changed intention
Pauline    = image, compartmentalization, and double life
Nico       = social gaze, domestic envy, voyeuristic complicity, and rivalry
Raphaëlle  = chosen version, explicit frame, and responsibility after the role
Player     = the gaze becoming an act, choice, or bad faith
```

## 5. Post-J1 starting state

Current J1 remains canon:

```text
J1 — Les choses qu'on remarque
```

Its fixed output is intentionally limited:

- Player and Marie remain together;
- their life remains warm and real;
- the couple problem is passive presence, not declared crisis;
- Sandra has returned through a soft trace;
- Mathilde remains indirect;
- Pauline, Nico, and Raphaëlle remain absent from active J1;
- no route is locked;
- no explicit adult escalation exists;
- no hard secret exists;
- exclusivity remains assumed.

Canonical starting couple mode:

```text
HABITUAL_WARMTH
```

J1 choices create soft tendencies only. They do not skip route stages or activate an affair.

## 6. Fixed dramatic spine

V0.78 locks the following functions:

```text
S0 Attention
S1 Household change
S2 Movement offered
S3 Outside lives become visible
S4 Private attention repeats
S5 Boundary named
S6 Desire becomes consequential
S7 Private and ordinary life collide
S8 Couple frame declared
S9 What remains
```

### Key implications

- Mathilde's temporary stay is an early household-change anchor.
- Marie creates movement rather than waiting to be threatened.
- Every principal character receives ordinary presence before major erotic function.
- At least one private connection becomes repeatable.
- At least one limit becomes explicit.
- Player eventually makes a consequential choice: stop, hide, disclose, ask permission, save, send, accept an alibi, cross, or actively return.
- Private versions eventually collide with ordinary life.
- Player and Marie's relationship frame becomes explicit.
- Endings include ordinary aftermath rather than stopping at the sexual climax.

The exact day and exact scene carrying each function may vary.

## 7. Act structure

### Act 0 — `Les choses qu'on remarque`

Current J1.

```text
How does Player pay attention before routes exist?
```

### Act I — `La place qu'on laisse`

```text
Will Player enter ordinary life before desire forces him to react?
```

Primary functions:

- Mathilde enters the household;
- Marie proposes meaningful movement;
- Player makes topology choices;
- external characters receive ordinary entry;
- no major adult completion.

### Act II — `Les regards circulent`

```text
What does Player do when private attention becomes rewarding?
```

Primary functions:

- Marie becomes socially visible;
- private channels repeat;
- character-specific tension becomes readable;
- traces, promises, invitations, or debts persist;
- Player receives a real chance to choose Marie actively.

### Act III — `Les lignes choisies`

```text
Can desire remain hypothetical once a boundary has been named?
```

Primary functions:

- attraction or risk is named;
- Player stops, hides, discloses, asks permission, or crosses;
- a route becomes consequential or closes;
- explicit scenes create aftermath.

### Act IV — `Les versions se rencontrent`

```text
Who pays when private versions begin changing ordinary life?
```

Primary functions:

- collision, discovery, confession, or direct negotiation;
- Marie acts from her own information and desire;
- route consequences affect other routes;
- the couple frame becomes explicit.

### Act V — `Ce qu'on choisit de garder`

```text
What remains after desire, exposure, and choice?
```

Primary functions:

- answer what Player and Marie are;
- resolve route access and knowledge;
- show work, family, image, social, and domestic consequences;
- show ordinary life after explicit adult content.

Acts are not fixed day ranges.

## 8. Narrative cycle

The basic rhythm is:

```text
1. fixed setup or ordinary-life anchor
2. Player choice
3. topology changes
4. one foreground modular scene becomes eligible
5. zero to two echoes may appear
6. return to shared life or consequence
7. state and obligations update
```

A day may contain one or more cycles.

A cycle is not automatically one day.

Default window budget:

```text
1 foreground scene
0–2 echoes
```

This prevents every route from demanding attention in the same evening.

## 9. Topology choices

Choices no longer directly select character routes.

They change:

- location;
- presence;
- privacy;
- available people;
- witnesses;
- channel;
- later return consequences.

Worked architecture example:

```text
Marie proposes an evening

1. Player joins Marie
   -> couple / social window

2. Marie goes; Player stays home
   -> domestic / private-message window

3. Player chooses a separate responsibility or outing
   -> work / Nico / independent window
```

The exact choices and wording remain for the next source pack.

Core rule:

```text
The choice does not select a woman.
It creates a context in which different scenes become plausible.
```

## 10. Couple-state model

The couple is not represented by one love score.

Conceptual dimensions:

- presence;
- desire;
- trust;
- truth;
- relationship frame.

Derived modes:

```text
HABITUAL_WARMTH
ACTIVE_RECONNECTION
PARALLEL_DRIFT
CONCEALED_FRACTURE
OPEN_CRISIS
NEGOTIATED_REDESIGN
SEPARATED_TRANSITION
RECONSTRUCTED_COUPLE
```

A couple-mode transition requires events and sustained behavior.

One isolated dialogue choice cannot turn warmth into open crisis.

## 11. Universal route lifecycle

```text
R0 Background
R1 Ordinary Access
R2 Charged Access
R3 Acknowledged Intent
R4 Consequential Frame
R5 Integration / Aftermath
```

R4 must be labeled as:

```text
HIDDEN_BETRAYAL
INFORMED_ADULT_FRAME
POST_SEPARATION_FRAME
NEGATIVE_BROKEN_BOUNDARY
```

A route may also be paused, cooled, closed, or transformed.

A route emerges from repeated patterns rather than one flirt answer.

## 12. Secret-pressure rule

Many R1/R2 connections may coexist.

Consequential secrets cannot accumulate indefinitely without interaction.

```text
one unresolved secret
= pressure

two unresolved secrets
= cross-pressure and jealousy

three or more consequential hidden secrets
= mandatory collision, exposure, confession, or structural choice
```

An informed group arrangement counts as one explicit frame, not several hidden affairs.

## 13. Narrative windows

Canonical window families include:

- `COUPLE_HOME`;
- `HOME_WITHOUT_MARIE`;
- `MARIE_SOCIAL`;
- `PLAYER_WITH_MARIE_SOCIAL`;
- `PLAYER_SEPARATE_OUTING`;
- `PLAYER_WORK`;
- `PRIVATE_MESSAGE`;
- `GROUP_EVENT`;
- `TRACE_OR_IMAGE`;
- `AFTERMATH`;
- `COUPLE_TRUTH`.

Every window identifies:

- location;
- time band;
- available characters;
- privacy;
- witnesses;
- channel;
- time pressure;
- couple visibility;
- intensity ceiling;
- foreground and echo capacity;
- obligations due.

A character cannot appear solely because an abstract score is high.

The window must make their availability credible.

## 14. Scene-pool taxonomy

The architecture uses:

```text
ORDINARY_LIFE
ACCESS
ATTENTION
TENSION
BOUNDARY
ESCALATION
COLLISION
AFTERMATH
REPAIR_OR_WITHDRAWAL
BREATHER
```

Every principal character has distinct engines inside these functions.

Examples:

- Sandra uses concrete traces and chosen distance.
- Mathilde uses household proximity and changed intention.
- Pauline uses public/private versions, alibis, and reciprocal proof.
- Nico uses social gaze, domestic envy, image exchange, and mutual cover.
- Raphaëlle uses transformation, role, audience, and after-role responsibility.
- Marie uses domestic participation, social visibility, reconquest, and couple truth.

A pool is not a day and not an affection score.

## 15. Selection priority

Current priority order:

```text
A. safety / consent / aftermath due
B. fixed spine anchor due
C. explicit obligation due
D. active route continuation
E. ordinary entry / new opportunity
F. breather / fallback
```

Within one band:

```text
context fit
-> overdue
-> unseen
-> longest deferred
-> least recently used pool
-> authored deterministic tie-breaker
```

Random selection never overrides psychological coherence.

## 16. Obligations and persistent memory

Important choices may create:

- promises;
- invitations;
- unanswered questions;
- debts;
- alibis;
- lies;
- image rules;
- deletion rules;
- boundaries;
- confessions due;
- adult aftermath;
- missed opportunities.

Every obligation must define:

- who owes it;
- who expects it;
- where it may be paid;
- expiry or mutation;
- consequence if ignored;
- who knows or suspects it.

```text
Nothing important waits forever unchanged.
```

## 17. Trace, knowledge, and consent ledgers

### Trace

A meaningful trace records:

- origin;
- creator;
- holder;
- intended audience;
- actual audience;
- consent state;
- saving / forwarding rules;
- knowledge;
- narrative meaning;
- discovery risk;
- payoff windows.

### Knowledge

```text
KNOWN
SUSPECTED
MISREAD
UNKNOWN
```

A perceptive character is not omniscient.

### Consent

An adult frame records:

- participants;
- activity;
- audience;
- touch;
- image rules;
- saving / forwarding;
- limits;
- duration;
- stop / slow signals;
- aftermath;
- whether relationship partners are informed or excluded.

Core rule:

```text
one yes is not every yes
```

## 18. Marie-centrality rules

The blueprint requires:

- at least one Marie scene per act where she exists for herself;
- a Marie/shared-life anchor across any two consecutive cycles;
- a couple consequence after major external escalation;
- independent Marie action under repeated Player passivity;
- direct Marie confirmation for informed open routes;
- no route that freezes Marie until Player returns;
- endings that answer what happened to the couple.

Marie remains the living center, not merely the gatekeeper of other routes.

## 19. Replayability

Replayability comes from:

- topology choices;
- character availability;
- couple mode;
- route stage;
- knowledge differences;
- obligations due;
- trace history;
- respected or broken boundaries;
- scenes already seen;
- missed opportunities;
- hidden or informed frame;
- withdrawal.

Scene lifecycle:

```text
DORMANT
-> ELIGIBLE
-> OFFERED
-> SEEN / DEFERRED / MISSED
-> MUTATED / EXPIRED
-> CONSEQUENCE_DUE
-> RESOLVED
```

A skipped scene does not remain unchanged forever.

It may mutate, cool, expire, become colder, or create a missed-opportunity consequence.

## 20. Modular Scene Authoring Contract

Every foreground scene must document:

- stable ID;
- primary function and relationship;
- canon dependencies;
- act and route-stage range;
- intensity;
- hard requirements and exclusions;
- availability reason;
- context reads;
- character-specific engine;
- exact decision axis;
- maximum three choices by default;
- non-Player agency;
- state writes;
- traces, knowledge, and consent changes;
- exit state;
- follow-up candidates;
- consequence timing;
- cooldown;
- expiry / mutation;
- fallback.

The contract includes worked examples for:

- Mathilde morning kitchen;
- Pauline private alternate photo;
- Marie's evening topology window.

## 21. Choice-design update

The choice canon now explicitly requires:

- three choices by default;
- topology choices rather than route menus;
- one primary decision axis per node;
- route emergence through accumulation;
- documented consequences;
- preservation of non-Player agency;
- no false choices when a consequence should simply happen;
- explicit justification for every 4+ node.

```text
The UI asks what Player does.
It does not ask which character route he selects.
```

## 22. Adult-route integration

V0.78 does not alter the NSFW canon.

It integrates adult logic into architecture by requiring:

- ordinary presence before major erotic use;
- R3 boundary before R4 consequence;
- explicit hidden vs informed frame;
- image origin and audience;
- participant-specific consent;
- aftermath after explicit scenes;
- collision pressure for multiple secrets;
- character voice during pornographic escalation.

A route may close before sex and remain narratively complete.

## 23. Supporting-character proportionality

Jeff, Bastien, Maud, Nora, Julie, Clara, Sophie, Malik, and other support anchors remain human where knowledge, consent, privacy, or consequences affect them.

They do not automatically receive:

- independent routes;
- scene pools;
- route variables;
- endings;
- equal documentation mass.

The modular architecture does not promote supporting characters by accident.

## 24. Incremental runtime boundary

V0.78 does not prescribe a universal simulation system.

Recommended future implementation sequence:

```text
1. Act I Opening Windows Source Pack
2. approved modular scene inventory
3. minimal runtime-state mapping
4. one small vertical slice
5. validation
6. expansion pool by pool
```

Avoid:

- one giant refactor;
- procedural intimate dialogue;
- a single affection score;
- rewriting every old day at once;
- building systems not used by the vertical slice.

## 25. Operational documentation reconciliation

The pass updates the two operational story-state documents:

- `GLOBAL_STORY_STATE.md` now describes the V0.78 architecture and correct V0.69 J1 line source;
- `CHARACTER_CONTINUITY_MATRIX.md` now tracks post-J1 state, modular windows, character progression, collisions, and support-character continuity rather than old day columns.

The main reading order, narrative status, character doorway, and choice canon all point to the same current architecture.

## 26. Product decisions to review

The most consequential locks are:

1. The fixed story is functional rather than day-based.
2. Mathilde's household arrival is an early mandatory spine function.
3. Marie's meaningful movement creates the first topology choices.
4. One foreground scene and zero to two echoes is the default window budget.
5. The couple uses five dimensions and derived modes, not one love score.
6. Every route uses R0–R5 and an explicitly labeled R4 frame.
7. Consequences and obligations outrank new temptation.
8. Three consequential hidden secrets force collision.
9. Every act contains Marie-for-herself content.
10. The next pass writes Act I opening windows, not all of J2–J10.

## 27. Scope verification

V0.78 changes documentation only.

It changes no:

- runtime scene;
- GDScript;
- narrative JSON;
- route variable;
- test;
- asset;
- playable message;
- J1 text.

Existing J2+ runtime remains technically present and narratively suspended.

## 28. Next steps

After Product Owner validation and merge:

```text
V0.79 — Act I Opening Windows Source Pack
V0.80 — First Modular Runtime Integration Plan
```

V0.79 should define the first concrete post-J1 content:

- Mathilde household entry;
- Marie's first topology-changing invitation;
- ordinary Raphaëlle, Nico, and Pauline entry windows;
- Sandra continuation;
- Marie return anchors;
- exact scene cards and three-choice nodes;
- conditions, consequences, cooldowns, and fallbacks.

No runtime modification belongs in V0.79.

## 29. Final rule

```text
The spine asks one fixed question.
Choices change the context.
Windows make characters plausibly available.
Scenes reveal how Player acts.
Traces remember.
Consequences return every private version to the same human life.
```
