# V0.68 — Narrative Refoundation Audit After Character V2 + NSFW Canon

> Documentation-only audit.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Purpose

This audit reconciles the existing narrative documentation with the new canon stack:

1. `docs/canon/DOCUMENTATION_READING_ORDER.md`
2. `docs/canon/NARRATIVE_CANON_STATUS.md`
3. `docs/canon/characters/CHARACTER_CANON_INDEX.md`
4. full per-character canon files:
   - `MARIE_CANON_FULL.md`
   - `SANDRA_CANON_FULL.md`
   - `PLAYER_CANON_FULL.md`
   - `MATHILDE_CANON_FULL.md`
   - `PAULINE_CANON_FULL.md`
   - `RAPHAELLE_CANON_FULL.md`
   - `NICO_CANON_FULL.md`
5. `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md`
6. `docs/canon/J1_CANON_SOURCE_PACK.md`

The goal is to prevent older narrative docs and runtime assumptions from overriding the newer character and NSFW canon.

---

## 2. Central conclusion

The project now has a new narrative foundation.

```text
Existing runtime is not automatically narrative canon.
Older J5/J6/J7 material is technically present, but narratively suspended until reviewed against the full character canon and NSFW route canon.
```

The previous J5/J6/J7 runtime work happened before the full Marie / Sandra / Player refoundation and before the NSFW route canon was made explicit.

Therefore:

- it may contain useful implementation or structural material;
- it may inspire future content;
- it must not drive future story directly;
- it must be re-audited, rewritten, confirmed, or retired day by day.

---

## 3. Current source hierarchy

### Primary canon

Use first:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
docs/canon/J1_CANON_SOURCE_PACK.md
```

### Current J1 truth

Use:

```text
docs/canon/J1_CANON_SOURCE_PACK.md
docs/V0_64_J1_Naturalized_Script_Draft.md only for exact line text
```

J1 remains:

- Marie + Sandra + Player;
- Mathilde indirect only;
- no Nico / Pauline / Raphaëlle active thread;
- no group;
- no route lock;
- no explicit escalation;
- final emotional center: Marie / shared life.

### Current adult-route truth

Use:

```text
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

This confirms that the project is allowed to become pornographic when routes escalate and that adult route families include:

- reconquest;
- tromperie;
- Sandra secret slow burn;
- Mathilde domestic taboo;
- Pauline control/image;
- Raphaëlle clarity/frame;
- Nico / NTR / sharing;
- trio / quatuor.

---

## 4. Status of existing runtime days

### J1

Status: **to rebuild or align from current canon**.

J1 must use the current source pack, not old assumptions.

### J2

Status: **review required before current-canon confirmation**.

Potentially reusable, but must be checked against:

- Marie living center;
- Sandra concrete trace rhythm;
- Player passive-delay / observation engine;
- Mathilde / Raphaëlle pacing;
- NSFW future route space.

### J3

Status: **review required before current-canon confirmation**.

The old `photo canapé` direction remains legacy unless deliberately restored.

Current Mathilde direction should start from domestic proximity / weak trace, not legacy proof.

### J4

Status: **legacy / suspended until reviewed**.

Social exposure, Pauline, Nico and group-photo logic may be useful, but must be rebuilt through full character canon and NSFW route intent.

### J5 / J6

Status: **technical runtime exists, narrative canon suspended**.

Reason:

- written before current character canon;
- written before explicit NSFW route canon;
- may be too dependent on older arcs, proof loops, and route assumptions;
- must not be used as fixed future direction.

### J7

Status: **technical runtime exists, narrative canon suspended**.

Reason:

- built from the older J5/J6 continuity;
- cannot be trusted if J1-J6 are refounded;
- may still inspire a later Mathilde day, but is not a fixed target.

### J8+

Status: **non-current unless later source pack explicitly validates it**.

---

## 5. Documents patched by this pass

This V0.68 pass patches the following docs to avoid misreading:

- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/narrative/CHARACTER_ARCS_J1_J10.md`
- `docs/narrative/SCENARIO_SPINE_J1_J10.md`
- `docs/narrative/PROOF_AND_SECRET_MAP.md`

The goal is not to fully rewrite every future day.

The goal is to quarantine outdated assumptions and point all future work to canon.

---

## 6. Character audit impact

### Marie

Older docs that frame Marie mainly as phone / jealousy / loss must be corrected.

Current Marie:

- living center;
- La Verrière;
- social movement;
- active choice wound;
- desirable domestic life;
- future adult routes can include reconquest, direct physical demand, social visibility, sharing / NTR only with her agency central.

### Sandra

Older docs that frame Sandra as mainly `waiting / later / hidden` must be corrected.

Current Sandra:

- concrete traces;
- SentryCore;
- Jeff as non-cartoon emotionally underfed couple;
- horaires décalés in French only, not `shift`;
- printed photos / slow-burn showing;
- adult route grows from chosen exposure, not pressure.

### Player

Older docs where Player exists mostly through abstract choices must be corrected.

Current Player:

- concrete daily life;
- software/product-ops work;
- cold coffee / tabs / bread / passive delay;
- notices but acts late;
- desire, shame, jealousy and adult gaze become route engines.

### Mathilde / Pauline / Raphaëlle / Nico

These characters now have full current canon files, but still need future concrete-profile expansion.

Until then:

- do not overbuild hard biography beyond canon;
- keep their route functions compatible with NSFW route canon;
- do not introduce them too early in J1;
- do not rely on old J5/J6/J7 runtime as proof of current arc validity.

---

## 7. Proof / photo audit impact

Proofs and photos remain central, but their interpretation must change.

Photos are not only plot clues.

They can be:

- arousal engines;
- adult rewards;
- risk containers;
- betrayal objects;
- NTR / sharing triggers;
- consensual chosen exposure;
- dangerous traces when saved, hidden, forwarded or discovered.

Current rule:

```text
Soft traces can be safe early.
Adult photos can become pornographic later.
Non-consented exposure is not a clean reward.
```

---

## 8. Required next step after V0.68

Recommended next PR:

```text
V0.69 — J1 Runtime Integration Plan From Canon
```

Scope should remain planning-only unless user explicitly asks Hermes to implement runtime.

The plan should:

- use `J1_CANON_SOURCE_PACK.md`;
- use full Marie / Sandra / Player canon;
- keep NSFW canon as future-route context but preserve J1 restraint;
- avoid old J5/J6/J7 assumptions;
- prepare exact JSON/runtime integration instructions for Hermes.

---

## 9. Final rule

```text
The next story step must be built from canon, not inherited from old runtime.

Characters stay deep.
Routes may become pornographic.
Older content remains useful only after revalidation.
```
