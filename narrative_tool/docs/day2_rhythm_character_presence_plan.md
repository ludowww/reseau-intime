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

Proposed future branch name: `work/runtime-integration-day-02-marie-callback-v0-28`.