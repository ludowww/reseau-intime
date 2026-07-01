# Day 2 Rhythm & Character Presence Plan

## Purpose

Define the intended runtime rhythm for Day 2 before integrating any new Day 2 scene.

This plan does not integrate any Day 2 content and does not modify game/data/conversations.

## Current baseline

V0.21 integrated Marie Day 1 as a light runtime anchor.
V0.23 integrated Sandra Day 1 as a light runtime anchor.
V0.26 polished Marie/Sandra Day 1 together.
V0.25 accepted the Day 1 structure and recommended joint polish, now completed in V0.26.
Day 1 runtime order remains Marie → Sandra.
The next step should not jump directly to cross-route pressure.

## Existing canonical sources for faster Day 2 work

Day 2 planning should not rely only on narrative_tool drafts. The repository already contains broader canonical sources that should be treated as required context for future Day 2 integration branches:

- `docs/story_state/J2_SUMMARY.md` — macro Day 2 chronology, active characters, visual contents, open risks.
- `docs/story_state/GLOBAL_STORY_STATE.md` — global route state, visual traces, current route embryos, long-term risks.
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md` — per-character day-by-day continuity and future preparation.
- `docs/dialogue_tool/01_Project_Bible.md` — project-level narrative principles.
- `docs/dialogue_tool/02_SMS_Writing_Rules.md` — SMS style constraints.
- `docs/dialogue_tool/characters/*.md` — character voices and boundaries.
- `docs/dialogue_tool/relationships/*.md` — relationship-specific proximity and tension.
- `docs/dialogue_tool/06_Routes_And_States.md` — route/state principles.
- `docs/dialogue_tool/07_Scene_Generation_Template.md` — scene generation format.
- `docs/dialogue_tool/09_Dialogue_Review_Checklist.md` — human review criteria.
- `docs/dialogue_tool/10_Automated_Checks.md` — expected validation/checking workflow.
- `docs/narrative/` — broader narrative design documents; list and read relevant files before Day 2 integration.
- `game/narrative_routes/routes_schema.json` — runtime route/state schema constraints.
- `game/narrative_memory/day_01.json` and `game/narrative_memory/day_02.json` — runtime memory already considered canonical.
- `docs/writing/dialogue_authoring_tools.md` — practical authoring guidance for dialogue production.
- `docs/writing/characters/VOICE_PROFILES.md` — consolidated voice profiles for character-specific writing.

### docs/narrative files observed

- `docs/narrative/SCENARIO_SPINE_J1_J10.md` — backbone day-by-day scenario spine.
- `docs/narrative/CHARACTER_ARCS_J1_J10.md` — cross-character progression and repetition guards.
- `docs/narrative/ROUTE_STATE_MODEL.md` — route/state grammar and coupling axes.
- `docs/narrative/ROUTE_COMPATIBILITY_MATRIX.md` — compatibility, fragility, and blockage rules.
- `docs/narrative/PROOF_AND_SECRET_MAP.md` — proof types, functions, and escalation rules.
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md` — daily pacing and density guidance.
- `docs/narrative/MARIE_ARC_J1_J10.md` — Marie’s active arc and limits.
- `docs/narrative/SANDRA_ARC_J1_J10.md` — Sandra’s slow-burn arc and guardrails.
- `docs/narrative/MATHILDE_ARC_J1_J10.md` — Mathilde’s arc and domestic tension.
- `docs/narrative/RAPHAELLE_ARC_J1_J10.md` — Raphaëlle’s clarity/refuge role.
- `docs/narrative/PAULINE_ARC_J1_J10.md` — Pauline’s control/proof pressure.
- `docs/narrative/PLAYER_ARC_J1_J10.md` — Player posture and response trajectory.
- `docs/narrative/NICO_AND_EXTERNAL_PARTNERS.md` — external pressure and rival/mirror threads.
- `docs/narrative/DIALOGUE_CONTENT_TEXTURE_RULES.md` — dialogue texture and anti-repetition guidance.
- `docs/narrative/PLAYER_RESPONSE_RULES.md` — Player response visibility and choice handling.
- `docs/narrative/CONSENT_AND_RISK_RULES.md` — consent, risk, and escalation boundaries.
- `docs/narrative/ANTI_LOOP_RULES.md` — anti-loop protections for recurring motifs.
- `docs/narrative/ADULT_CONTENT_PROGRESSION_AND_ENDINGS.md` — progression and ending constraints.
- `docs/narrative/J1_J10_REVISED_SCENARIO_PLAN.md` — revised scenario direction across J1-J10.
- `docs/narrative/J5_J6_REWRITE_PLAN.md` — later-day rewrite constraints and pivots.
- `docs/narrative/NARRATIVE_VALIDATION_TOOLS_V2.md` — narrative QA tools and warnings.

Future Day 2 integration prompts should use these sources to avoid re-deciding already documented continuity.

## Runtime Day 2 context observed

- Existing Day 2 index file observed: `game/data/conversations/chapter_02_index.json`.
- Existing Day 2 conversation files referenced by the index observed:
  - `chapter_02_marie_morning.json`
  - `chapter_02_raphaelle_midday.json`
  - `chapter_02_marie_afternoon.json`
  - `chapter_02_mathilde_evening.json`
  - `chapter_02_sandra_evening.json`
  - `chapter_02_marie_night.json`
  - `chapter_02_mathilde_night.json`
- Additional Day 2 files observed in `game/data/conversations/` but not listed in `chapter_02_index.json`:
  - `chapter_02_mathilde_home.json`
  - `chapter_02_social_marie_nico.json`
  - `chapter_02_group_pauline_night.json`
- Confirmed Day 2 runtime characters in the index: Marie, Raphaëlle, Mathilde, Sandra.
- Marie already appears in Day 2: confirmed, several times.
- Sandra already appears in Day 2: confirmed, later in the day.
- Mathilde already appears in Day 2: confirmed, several times.
- Raphaëlle already appears in Day 2: confirmed, midday.
- Group / friends thread appears in the directory, but it is not confirmed as part of the active Day 2 index flow.
- Pauline / Nico appear in observed Day 2 files, but active Day 2 placement is not confirmed by `chapter_02_index.json`.
- Existing order / unlock / pending / unread information visible in the index:
  - Day 2 starts with `chapter_02_marie_morning` at 08:12.
  - Raphaëlle unlocks after Marie morning at 12:27 and is marked pending.
  - Marie afternoon unlocks after Raphaëlle midday at 17:36 and is marked pending.
  - Mathilde evening unlocks after Marie afternoon at 17:52 and is marked pending.
  - Sandra evening unlocks after Mathilde evening at 18:38 and is marked pending.
  - Marie night unlocks after Sandra evening at 18:56 and is marked pending.
  - Mathilde night unlocks after Marie night at 19:04 and is marked pending.
- Obvious constraints:
  - Day 2 is already a multi-thread day, so additional central scenes would risk overload.
  - The index explicitly says no active group conversation.
  - The design goal keeps Player out of the house for the full day.
  - Sandra should not introduce a new photo; she should return to Day 1 photo continuity.
  - Pauline and Nico remain seed-only unless a future branch confirms otherwise.

## Narrative goals for Day 2

Day 2 should deepen Day 1 without overloading the player.
Marie should remain the official relationship baseline.
Sandra should continue as a returning complicity / emotional hook.
Supporting characters should make the world feel alive without creating too many routes at once.
Day 2 should prepare future callbacks before cross-route pressure.

## Character presence map

| Character/thread | Day 2 function | Weight | Recommended form | Notes |
|---|---|---|---|---|
| Marie | Official couple baseline and domestic rhythm anchor | central | long/medium callback, repeated across the day | Keep the couple frame clear; preserve fatigue, home rhythm, and phone-distance texture. |
| Sandra | Returning complicity / emotional hook | secondary | medium callback, later in the day | Keep the photo/J1 continuity and deniable trouble; do not over-escalate too early. |
| Mathilde | Social/domicile texture, light domestic disruption | light presence | short scene or brief interruption | Useful for breathing room and house energy; should not become a dominant route on Day 2. |
| Raphaëlle | External world texture and a small interruption from work | light presence | short midday callback | Good for pacing and variety, but should stay lighter than Marie/Sandra. |
| Group / friends thread if present | Ambient social pressure only | not yet | background-only, or postpone | The directory shows group/social files, but the validated Day 2 index does not confirm them as active. |

## Marie Day 2 role

Marie matters on Day 2 because she preserves the official-couple baseline after Day 1 and gives the day its domestic center of gravity.
The callback it should preserve is the home rhythm / fatigue / phone-distance texture already established in Day 1.
It should be long or at least medium-long, because Marie is the safest way to open Day 2 without flattening it into route noise.
Marie should come before Sandra if the goal is to keep the relationship baseline readable before the returning complicity thread arrives.
If Marie is skipped or kept too light, Day 2 risks losing its emotional anchor and making later threads feel disconnected from the couple.

## Sandra Day 2 role

Sandra matters on Day 2 because she keeps the photo / déjeuner / souvenir thread alive and confirms that Day 1 was not a one-off.
The callback it should preserve is the Day 1 photo memory and the cautious recontact tone.
It should be medium or short-medium rather than long, because Sandra is strongest as a precise return, not a takeover.
Sandra should come after Marie in the current Day 2 rhythm, so the couple baseline remains visible before the emotional hook reappears.
If Sandra is too strong too soon, she can pull the day into premature pressure and make the scene feel like route escalation instead of a controlled continuation.

## Mathilde / Raphaëlle / group role

Supporting characters should not compete with Marie/Sandra yet.
They can provide social rhythm, humor, interruptions, or world texture.
They should not all receive long scenes on Day 2.
A light Mathilde or group presence can help the day breathe if already supported by runtime.
Raphaëlle should remain light unless runtime already positions her as important on Day 2.
The group thread, if used later, should stay ambient on Day 2 and not become a new central axis.

## Recommended Day 2 rhythm

1. Marie — central — establish the official-couple baseline, home rhythm, and day opening.
2. Raphaëlle or Mathilde — light presence — keep the day breathing and add a small social interruption.
3. Sandra — secondary — restore the photo/J1 continuity and close the day with controlled emotional hook.

Recommended Day 2 shape: 1 central callback + 1 secondary callback + 1 light/ambient presence.

## Candidate comparison

| Candidate | Value | Risk | Runtime complexity | Recommended timing |
|---|---|---|---|---|
| Marie Day 2 callback | Best at preserving the couple baseline and the emotional center of the day | Can feel repetitive or domestic-filler-like if overextended | Low to moderate | First, or early in the day |
| Sandra Day 2 callback | Best at preserving the photo/J1 memory and the deniable emotional hook | Can become too strong too soon and steal the day’s center | Moderate | After Marie, later in the day |
| Supporting-character light presence | Best at making Day 2 feel lived-in and breathable | Can dilute the core if made too important | Low | In between or as a brief beat |

## Recommended first Day 2 integration

Recommended first Day 2 integration: Marie Day 2 callback

Secondary candidate: Sandra Day 2 callback

## Non-goals

No Day 2 runtime integration in V0.27.
No changes to game/data/conversations.
No cross-route integration.
No route lock.
No new state/memory system.
No new character route foundation.
No draft rewrite.
No QA/tool changes.

## Risks

Day 2 overload if too many characters become central.
Marie/Sandra imbalance if only one route receives continuity.
Supporting characters may dilute the core if introduced too strongly.
Day 2 callbacks may depend on Day 1 texture that is still light.
Cross-route pressure should wait until solo callbacks are clearer.

## Required validations for future integration

```bash
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_02_marie_callback.draft.json
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_02_sandra_callback.draft.json

python3 tools/check_memory_continuity.py narrative_tool/memory/marie_day_01_memory_contract.json narrative_tool/drafts/day_02_marie_callback.draft.json
python3 tools/check_memory_continuity.py narrative_tool/memory/sandra_day_01_memory_contract.json narrative_tool/drafts/day_02_sandra_callback.draft.json

python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## Next step

V0.28 should be a scoped runtime integration branch for the recommended first Day 2 candidate only, if Ludovic validates this plan.
V0.28 should use the story_state, dialogue_tool, docs/writing, docs/narrative, narrative_memory, and route schema documents as required context before touching runtime data.

Proposed future branch name: `work/runtime-integration-day-02-marie-callback-v0-28`.