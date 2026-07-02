# J5-J8 Narrative Arc & Character Rhythm Reassessment

## Purpose

Reassess the J5-J8 narrative rhythm against the current runtime and the long-form arc docs, without touching the runtime.

The core question is not only whether J5-J7 are “correct”, but whether they *feel* like a single evolving arc or like a tour de table between characters.

## Current baseline

- Branch: work/j5-j8-narrative-arc-character-rhythm-v0-31
- Runtime baseline inspected at `main / origin/main` SHA `56e90f4484122de1501d97d36726ea05a3441ddf`
- This is documentation-only.

Observed high-level state:

- J5 exists and is fully wired.
- J6 exists and is fully wired.
- J7 exists and is fully wired.
- J8 does not exist in runtime yet.

Short diagnosis:

- J5 is the noisiest day.
- J6 is the cleanest day.
- J7 is coherent, but close to a balanced multi-thread roundtable.
- J8 is currently the right place to rebalance, because it is still absent from runtime.

## Sources inspected

### Runtime

- `game/data/conversations/chapter_05_index.json`
- `game/data/conversations/chapter_05_*.json`
- `game/data/conversations/chapter_06_index.json`
- `game/data/conversations/chapter_06_*.json`
- `game/data/conversations/chapter_07_index.json`
- `game/data/conversations/chapter_07_*.json`
- `game/data/conversations/chapter_08_index.json` — absent
- `game/data/conversations/chapter_08_*.json` — absent
- `game/data/visual_content/chapter_05_proofs.json`
- `game/data/visual_content/chapter_06_proofs.json`
- `game/data/visual_content/chapter_07_proofs.json`
- `game/data/visual_content/chapter_08_proofs.json` — absent
- `game/data/state/initial_state.json`

### Story state

- `docs/story_state/J5_SUMMARY.md`
- `docs/story_state/J6_SUMMARY.md` — absent
- `docs/story_state/J7_SUMMARY.md` — absent
- `docs/story_state/J8_SUMMARY.md` — absent
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`

### Narrative docs

- `docs/narrative/SCENARIO_SPINE_J1_J10.md`
- `docs/narrative/CHARACTER_ARCS_J1_J10.md`
- `docs/narrative/MARIE_ARC_J1_J10.md`
- `docs/narrative/SANDRA_ARC_J1_J10.md`
- `docs/narrative/MATHILDE_ARC_J1_J10.md`
- `docs/narrative/RAPHAELLE_ARC_J1_J10.md`
- `docs/narrative/PAULINE_ARC_J1_J10.md`
- `docs/narrative/NICO_AND_EXTERNAL_PARTNERS.md`
- `docs/narrative/ROUTE_STATE_MODEL.md`
- `docs/narrative/ROUTE_COMPATIBILITY_MATRIX.md`
- `docs/narrative/PROOF_AND_SECRET_MAP.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/narrative/DIALOGUE_CONTENT_TEXTURE_RULES.md`
- `docs/narrative/PLAYER_RESPONSE_RULES.md`
- `docs/narrative/CONSENT_AND_RISK_RULES.md`
- `docs/narrative/ANTI_LOOP_RULES.md`
- `docs/narrative/ADULT_CONTENT_PROGRESSION_AND_ENDINGS.md`
- `docs/narrative/J1_J10_REVISED_SCENARIO_PLAN.md`
- `docs/narrative/NARRATIVE_VALIDATION_TOOLS_V2.md`

### Writing docs

- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`

### Narrative tool references

- `narrative_tool/docs/day2_rhythm_character_presence_plan.md`
- `narrative_tool/reviews/day_01_marie_runtime_integration_review.md`
- `narrative_tool/reviews/day_01_sandra_runtime_integration_review.md`
- `narrative_tool/reviews/day_01_runtime_balance_review.md`

## Runtime reality J5-J7

### J5

Runtime shape:

- 7 active threads in the index.
- Marie is the explicit anchor.
- Pauline is the secondary pressure axis.
- Sandra, Mathilde, Raphaëlle, and the social story are all active enough to feel like distinct beats.
- Nico exists mostly as a social mirror, not as a direct route.

What works:

- The day really does feel like aftermath social pressure.
- Marie clearly carries the couple axis.
- Pauline is dangerous without becoming a new system.
- Sandra is not just a name in the background.

What strains:

- The day is denser than the hypothesis suggests.
- The day distributes attention across too many voices for a simple aftermath beat.
- The social story, the work breath, and the final Pauline seed all extend the same “traces after the party” field.

Verdict:

- Functionally aligned.
- Rhythmically too broad.
- The main risk is structural dilution, not wrong content.

### J6

Runtime shape:

- 4 active threads.
- Mathilde is central.
- Marie is the direct emotional counterweight.
- Pauline remains present, but more as pressure/measurement than as a second climax.
- Sandra closes the day with a concrete, honest beat.
- Raphaëlle is absent from the active index, which is good for density.

What works:

- This is the cleanest day in the set.
- The day clearly enacts “acte concret de Player”.
- The consequences are legible.
- The day does not feel like a roundtable.

What strains:

- Pauline and Sandra are still a little more present than the minimal hypothesis.
- That is acceptable, because they each contribute a distinct consequence.

Verdict:

- Strongly aligned.
- The closest day to the planned arc.
- Keep this rhythm model as the reference for later restraint.

### J7

Runtime shape:

- 4 active threads.
- Mathilde opens the day with a strong domestic proximity beat.
- Marie follows with a clear perception of change.
- Sandra brings a soft but embodied desire beat.
- Pauline closes with a short, controlled observation.

What works:

- Every thread has a recognizable voice.
- The day keeps moving from domestic closeness to emotional reaction to soft desire to controlled observation.
- The runtime does not collapse into one repeated note.

What strains:

- The day is flatter than J6 in terms of hierarchy.
- It reads less like a new crest and more like a distributed consequence day.
- Pauline feels slightly too present for a day that should probably narrow.

Verdict:

- Mostly aligned in content.
- Less aligned in rhythm hierarchy.
- The day risks becoming a balanced four-way panel instead of a focused emotional turn.

## Runtime absence of J8

- `chapter_08_index.json` absent: yes
- `chapter_08_*.json` absent: yes
- `chapter_08_proofs.json` absent: yes

Interpretation:

- This absence is not a problem.
- It is actually useful, because J8 is the best place to restore breathing room after J5-J7.
- J8 should not be created as a fifth equal-weight day in the same pattern.

## Planned arc J5-J8

### What the docs expect

From the arc docs and the revised scenario plan:

- J5 should make Marie active and make the image/social aftermath meaningful.
- J6 should force a concrete Player act.
- J7 should be the world’s reaction to that act.
- J8 should introduce a contradiction, a clarity branch, or a rerouting of the story.

The docs also warn against repeating these motifs without consequence:

- phone / absence / screen
- Sandra “plus tard” / waiting
- photo / trace / proof
- Pauline proof / control
- Raphaëlle refuge / cachette
- Marie / Nico / jealousy

### Hypothesis to test

The proposed test rhythm is useful, but not literal:

- J5 — aftermath social
- J6 — domestic return of traces
- J7 — desire and emotional place
- J8 — respiration / clarity / recentring

Assessment of that hypothesis:

- Better than the current “everyone gets a turn” feeling.
- Stronger than a flat linear escalation.
- Needs one adjustment: J5 and J7 must be more asymmetrical so they do not feel like sister-days.

## Day-by-day comparison

| Jour | Arc prévu | Runtime actuel | Écart | Risque | Décision recommandée |
|---|---|---|---|---|---|
| J5 | Aftermath social. Marie central, Pauline secondary, Sandra trace indirecte, Mathilde silence actif, Raphaëlle absent. | Marie central, Pauline secondary, Mathilde/Sandra/Raphaëlle active, Nico mostly indirect. | Écart de densité et de structure : trop de beats de même poids. | Impression de tour de table, dilution du pivot Marie. | Garder J5 tel quel pour V0.31, mais considérer un futur allègement de Raphaëlle/Sandra si réécriture. |
| J6 | Retour domestique des traces. Mathilde central, Marie secondary, Pauline trace, Sandra silence actif, Raphaëlle absent. | Mathilde central, Marie secondary, Pauline secondary, Sandra secondary, Raphaëlle absent. | Écart faible : Pauline et Sandra un peu trop présentes. | Duplication légère, mais pas de rupture. | Garder J6 tel quel. C’est la meilleure base rythmique du bloc. |
| J7 | Désir et place émotionnelle. Mathilde ou Sandra central, l’autre secondary, Marie trace indirecte, Pauline silence actif, Raphaëlle absent. | Mathilde central, Marie/Sandra/Pauline secondary, Raphaëlle absent. | Écart de structure et de hiérarchie : quatre voix à poids assez égal. | La journée devient un plateau plutôt qu’un tournant. | Garder J7, mais si réécriture future : réduire Pauline et donner une vraie priorité à un seul axe (Mathilde ou Sandra). |
| J8 | Respiration / clarté / recentrage. Raphaëlle ou Marie central, l’autre secondary, Pauline trace indirecte, Sandra ou Mathilde en silence actif. | runtime absent | Écart total de timing, mais absence utile. | Si J8 n’est pas créé, J5-J7 risquent de former un bloc trop dense sans respiration. | Créer J8 maintenant, mais comme journée courte et hiérarchisée, pas comme quatrième journée dense. |

## Character rhythm comparison

| Personnage | Arc prévu J5-J8 | Présence runtime J5-J7 | Statut actuel | Risque de rythme | Ajustement proposé |
|---|---|---|---|---|---|
| Marie | J5 central, J6 secondary, J7 secondary, J8 central ou secondary selon branche. | J5 central, J6 secondary, J7 secondary. | J5: central ; J6: secondary ; J7: secondary ; J8: absent. | Peut devenir le seul fil stable si les autres voix sont trop nombreuses autour d’elle. | Garder Marie comme ancre, mais lui donner une action ou contradiction nette en J7/J8, pas seulement un constat. |
| Sandra | J5 trace indirecte, J6 secondary, J7 secondary ou central léger, J8 trace/retour modulé. | J5 secondary, J6 secondary, J7 secondary. | J5: secondary ; J6: secondary ; J7: secondary ; J8: absent. | Trop présente trop tôt pour une route censée rester retenue. | En futur allègement, ramener Sandra vers la trace et l’absence active sur J5, puis la faire changer de disponibilité plus tard. |
| Mathilde | J5 silence actif, J6 central, J7 secondary ou central léger, J8 variable. | J5 secondary, J6 central, J7 central. | J5: secondary ; J6: central ; J7: central ; J8: absent. | La route domestique devient presque aussi présente que Marie sur deux jours d’affilée. | Lui donner une vraie fonction de transition, puis éviter qu’elle reste le même moteur deux jours de suite. |
| Pauline | J5 secondary, J6 secondary, J7 trace indirecte, J8 trace indirecte. | J5 secondary, J6 secondary, J7 secondary. | J5: secondary ; J6: secondary ; J7: secondary ; J8: absent. | Risque de “pivot secondaire permanent” ; elle garde trop souvent le même poids. | Garder Pauline dangereuse, mais la réduire à une trace ou à une seule intervention courte sur J7/J8. |
| Raphaëlle | J5 absent, J6 absent, J7 absent, J8 central ou secondary. | J5 secondary, J6 absent, J7 absent. | J5: secondary ; J6: absent ; J7: absent ; J8: absent. | Timing un peu trop tôt en J5 : elle devient un décompressor de journée plus qu’une vraie respiration différée. | Si elle reste en J5, raccourcir fortement sa scène. Sinon, déplacer sa vraie fonction vers J8. |
| Nico | J5 trace indirecte, J6 trace ou absent, J7 trace indirecte, J8 variable. | J5 trace indirecte, J6 absent, J7 trace indirecte. | J5: trace indirecte ; J6: absent ; J7: trace indirecte ; J8: absent. | Peut devenir un simple déclencheur de jalousie si sa présence se densifie. | Le garder rare et socialement plausible ; ne pas le faire porter la tension à lui seul. |

## Density and repetition risks

### 1. J5 is functionally correct, but structurally broad

J5 is the main place where the “tour de table” impression can appear.

Why:

- Marie has the strongest weight, but several other threads are still fully active.
- The same thematic field keeps returning: image, story, proof, reaction, memory.
- Each beat is valid on its own, but the day has many active edges.

Conclusion:

- The problem is not that J5 is wrong.
- The problem is that J5 spreads its energy too evenly.

### 2. J6 is the reference model for asymmetry

J6 works because:

- Mathilde owns the day.
- Marie supplies the emotional counterweight.
- Pauline and Sandra are consequences, not co-pivots.
- Raphaëlle is absent, which helps the day breathe.

Conclusion:

- J6 should be the pacing template for future days.

### 3. J7 is the closest to a balanced panel

J7 is the main rhythm warning because:

- four threads are present,
- none of them completely dominates,
- the day is coherent but very evenly distributed.

Conclusion:

- J7 should not be the “everyone gets a turn” day.
- It needs a sharper hierarchy.

### 4. Repetition risk is real, but it is mostly a function-change issue

The docs are right: the same motif can return if it changes function.

The current runtime mostly does that, but not always strongly enough.

Main repeated motifs:

- phone / absence / screen
- trace / photo / proof
- waiting / “plus tard”
- control / secrecy
- Marie / Nico / visibility

The repetition risk is not only textual.
It is also rhythmic:

- too many equal-weight daily beats;
- too many characters sounding like they are all “up next”;
- too few days with a clear centrality drop-off.

## Proposed rhythm model

| Jour | Axe principal | Secondary | Trace indirecte | Silence actif | Absent | Justification |
|---|---|---|---|---|---|---|
| J5 | Marie | Pauline | Sandra, Nico | Mathilde | Raphaëlle | Aftermath social should stay centered on the couple, with Pauline as the social pressure valve and the others reduced. |
| J6 | Mathilde | Marie | Pauline, Sandra | Raphaëlle | Nico | This is the clearest “acte concret” day. Keep the domestic trace at the front and limit extra pressure. |
| J7 | Sandra | Mathilde | Marie, Pauline | Raphaëlle | Nico | J7 should feel like desire and emotional place, not like another social roundtable. Sandra needs a stronger singularity or, if not, Mathilde should own the day. |
| J8 | Raphaëlle | Marie | Pauline | Sandra or Mathilde | Nico | J8 should recentre the arc and lower the noise after J5-J7. A clarity day is the best structural reset. |

## Recommended decisions for J5

- Keep J5 as is in runtime for V0.31.
- Do not patch runtime now.
- Treat J5 as narratively acceptable but rhythmically overloaded.
- If later revising, demote Raphaëlle and Sandra from full beat to trace-level presence.
- Preserve Marie as the true center; do not let Pauline become co-central.

## Recommended decisions for J6

- Keep J6 tel quel.
- Do not add Raphaëlle.
- Do not increase Pauline beyond her current role.
- Let Mathilde own the day as the concrete trace decision.
- Use J6 as the reference for how to structure a clean day after an overloaded one.

## Recommended decisions for J7

- Keep J7 in runtime for now, but treat it as the day most likely to be rewritten later.
- Do not add new active characters.
- Reduce Pauline if this day is ever revised.
- Give one character a sharper emotional lead, instead of maintaining a four-way equilibrium.
- Prefer a day that feels like desire or emotional place, not a multi-person summary of consequences.

## Recommended direction for J8

- Yes, J8 should be created now.
- Maximum: 2 scenes strong, 3 scenes absolute max.
- Central: Raphaëlle if the goal is clarity / recentring; Marie can remain the emotional secondary anchor.
- Secondary: Marie.
- Trace indirecte: Pauline.
- Silence actif: Sandra or Mathilde, but not both.
- Absent: Nico.

What should return in J8:

- the strongest unresolved social/proof trace from J5-J7;
- one consequence of Pauline’s control;
- one clear contrast between what was shown and what was said.

What should stay waiting in J8:

- Sandra’s full availability;
- Mathilde’s domestic escalation;
- any new Nico escalation.

## How to use the narrative tool after this reassessment

1. Use `docs/narrative/` to verify the intended arc.
2. Use `docs/story_state/` to verify the consolidated state.
3. Use `game/data/conversations/` to verify what is actually playable.
4. Use `narrative_tool/` to prepare diagnostics, drafts, reviews, and memory contracts before runtime.

When to use it:

- Before creating J8: build a plan/scene in `narrative_tool` before touching runtime.
- Before rewriting J5-J7: create a targeted `narrative_tool` review first.
- Before integrating any scene: verify memory continuity and character voice.
- After integration into runtime: run a runtime review and the validations.

When not to use it:

- Do not use `narrative_tool` to replace runtime files directly.
- Do not copy a draft from `narrative_tool` into `game/data` unchanged.
- Do not create a new system when a rhythm adjustment is enough.
- Do not use narrative QA as a justification for mechanical density.

## Non-goals

- No runtime patch in V0.31.
- No index modification.
- No scene creation.
- No draft creation.
- No route lock.
- No new state/memory system.
- No tests/tool changes.
- No direct copy from narrative docs to runtime.

## Risks

- The biggest risk is the tour de table effect: several valid beats with no clear hierarchy.
- J5 can read as overloaded because it spreads consequence across too many active threads.
- J7 can read as a plateau because four voices are given similar weight.
- If J8 is not created as a short reset, the whole block can feel denser than the story actually needs.
- Sandra can lose her “plus tard” tension if she stays too present too early.
- Raphaëlle can become a functional decompression valve instead of a real clarity branch if she appears too soon in the wrong form.

## Next recommended step

Draft a short J8 skeleton in `narrative_tool` first, with a single clear hierarchy and a maximum of 2-3 scenes.

If the branch chosen is the clarity branch, center Raphaëlle and keep Marie secondary.
If the branch chosen is the couple/cost branch, center Marie and keep Raphaëlle as the clarity contrast.

Do not touch runtime until the J8 skeleton can prove that the day will reset the rhythm instead of repeating the same daily panel.
