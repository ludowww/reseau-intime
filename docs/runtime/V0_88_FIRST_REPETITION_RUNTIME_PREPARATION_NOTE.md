# V0.88 — First Repetition Runtime Preparation Note

> Fulfilled boundary note.  
> V0.87 defines the first post-opening repetition wave.  
> V0.88 now defines the integration plan, but runtime still remains unchanged.

## 1. Current authority

Read:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_INTEGRATION_PLAN.md
docs/V0_88_First_Repetition_Runtime_Integration_Plan_Report.md
```

Runtime baseline remains:

```text
V0.86 + V0.86a
main planning base: 1d739454a280c17c76c33c74eab3c6e8a81f2a24
playable Tuesday through Friday
```

## 2. Fulfilled V0.88 decisions

V0.88 now defines:

```text
runtime inventory
structured story-ledger mapping
foreground-ticket representation
deterministic candidate selection
one charged-access owner
obligation priority
cooldown and expiry mapping
missed-opportunity mutation
same-thread continuation
cross-thread notifications
co-presence representation
safe missing-state defaults
smallest vertical slice
rollback boundary
validation matrix
```

## 3. First implementation slice

Approved planning target:

```text
Saturday W9 Marie shared hour
-> Sunday Mathilde morning candidate or silent defer
-> Sunday W11 Marie concrete return
```

Why Mathilde:

- current household access already exists;
- current persistent thread already exists;
- no image is required;
- the scene tests repetition, expiry, R1/R2 gating, and return logic;
- selection is based on fit, not later adult-route excitement.

## 4. Runtime boundary

This note and the V0.88 plan do not modify:

```text
game/**
tests/**
tools/**
```

The current build still ends Friday at:

```text
opening_band_complete = true
```

No Saturday or Sunday content is playable yet.

## 5. Invariants for V0.89

The future implementation must preserve:

- maximum two external foreground tickets in the full wave;
- maximum one charged-access owner;
- only one external candidate in the first slice;
- Marie return before another external opportunity;
- current V0.86a phone clock and notification behavior;
- no blank timeline cards;
- no visible `Moments hors ligne` section;
- no fake long chat during co-presence;
- no new required image asset;
- no adult frame, hard secret, or R3+ route;
- Pauline and Nico remaining R1;
- character voice distinction.

## 6. Next step

After Product Owner validation:

```text
V0.89 — First Repetition Vertical Slice
```

V0.89 must implement only the approved Marie -> Mathilde -> Marie chain.

It must not add the complete V0.87 candidate pool in the same PR.

## 7. Final rule

```text
V0.87 decides what repetition means.
V0.88 decides the smallest honest integration.
V0.89 may implement only that validated slice.
```
