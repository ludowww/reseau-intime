# V0.88 — First Repetition Runtime Preparation Note

> Boundary note only.  
> V0.87 defines the first post-opening repetition wave.  
> This note does not authorize runtime implementation by itself.

## 1. Source authority

Read first:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md
```

Runtime baseline:

```text
V0.86
main commit ba22baf1f901e932f9c755344712363274a827ae
```

## 2. Required V0.88 deliverable

V0.88 must be a documentation-first integration plan defining:

```text
runtime inventory
state mapping
foreground-ticket representation
deterministic candidate selection
one charged-access owner
obligation priority
cooldown and expiry mapping
missed-opportunity mutation
same-thread continuation
cross-thread notifications
co-presence representation
save compatibility
smallest vertical slice
rollback boundary
validation matrix
```

## 3. Small-slice rule

V0.88 must not plan all V0.87 scenes as one runtime PR.

Recommended first vertical slice:

```text
W9 Marie shared hour
+ one external candidate
+ mandatory Marie return
```

The integration plan must justify which external candidate is technically and narratively best for the first slice.

It must not choose merely because that character has the most exciting later adult route.

## 4. Runtime invariants

Any future implementation must preserve:

- maximum two external foreground tickets in the wave;
- maximum one R2 owner;
- Pauline and Nico at R1;
- Marie consequence before a later external opportunity;
- current V0.86a phone clock and notification behavior;
- no blank timeline cards;
- no visible `Moments hors ligne` section;
- no fake long chat during co-presence;
- no new required image asset;
- no adult frame, hard secret, or R3+ route.

## 5. State-mapping caution

Conceptual labels in V0.87 are not automatically final JSON keys.

V0.88 must:

1. inspect existing `TimelineState`, `GameState`, flags, and conversation data;
2. reuse existing state where semantics match;
3. introduce only the smallest necessary new state;
4. document every mapping;
5. avoid score proliferation;
6. preserve rollback and static-test readability.

## 6. Selection caution

The scene-selection engine must be deterministic.

It must read:

- prerequisites;
- exclusions;
- obligations;
- cooldowns;
- actual time/location context;
- foreground ticket budget;
- charged owner;
- prior foreground history.

It must not:

- use free randomness before authored priority;
- expose every eligible contact simultaneously;
- treat timestamps as sufficient access;
- create a route menu.

## 7. Final rule

```text
V0.87 decides the story.
V0.88 decides how to integrate the smallest truthful part of it.
Runtime begins only after both decisions are validated.
```
