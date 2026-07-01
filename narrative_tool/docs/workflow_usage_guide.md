# Narrative Tool Workflow Usage Guide

## 1. What this tool is for
This tool is for designing and validating narrative SMS scenes before they are integrated into game data.

It helps to:
- avoid generic AI dialogue
- keep character voices distinct
- preserve route memory
- test dialogue drafts safely
- test cross-route pressure without runtime changes

## 2. What is canonical and what is not
- Files under `narrative_tool/drafts/` are QA/editorial prototypes, not canonical game conversations.
- Files under `game/data/conversations/` are canonical runtime conversations.
- Benchmarks are tone references.
- Scene contracts are design constraints.
- Memory contracts define what future scenes should remember.
- Reports are generated outputs and should normally not be committed.

## 3. File types
- **character profile**: defines who the character is, their tone, and their narrative role.
- **desire profile**: defines what the character wants, avoids, and pursues emotionally or erotically.
- **proximity profile**: defines current closeness, distance, history, and social context with Player.
- **relationship profile**: defines the relationship model, boundaries, and relational stakes.
- **route fantasy profile**: defines the route’s core emotional or erotic promise.
- **route arc**: defines the route’s progression and major beats.
- **benchmark**: a tone reference scene or note used to anchor style and behavior.
- **scene contract**: a pre-writing constraint file describing what a scene must do.
- **draft**: a QA scene prototype used for validation, not runtime canon.
- **memory contract**: a contract describing what must be remembered later.
- **QA rules**: validation rules used by the dialogue QA runner and related checks.
- **cross-route rules**: constraints for scenes where routes can influence each other.
- **generated report**: QA output produced by tools; keep it out of commits unless asked.

## 4. Standard route workflow
Recommended order:
1. Character profile
2. Desire profile
3. Proximity / relationship profile
4. Route fantasy profile
5. Route arc
6. Day/scene contract
7. Benchmark
8. Draft
9. Memory contract
10. Callback draft
11. Continuity check

Sandra started directly as a benchmark/reference, while Marie received a more structured foundation first.

## 5. Memory workflow
V0.9 uses two modes:
- `source_memory_coverage_check`
- `future_continuity_check`

`source_memory_coverage_check` verifies that a source draft produces the memory traces promised by its memory contract.
`future_continuity_check` verifies that a later draft remembers or respects a previous memory contract.

Examples:
```bash
python3 tools/check_memory_continuity.py narrative_tool/memory/marie_day_01_memory_contract.json narrative_tool/drafts/day_01_marie_couple_anchor.draft.json
python3 tools/check_memory_continuity.py narrative_tool/memory/marie_day_01_memory_contract.json narrative_tool/drafts/day_02_marie_callback.draft.json
```

## 6. Cross-route workflow
Cross-route work should start with `route_interaction_rules.json` before any draft.
A cross-route scene should not immediately create jealousy, confession, or route locks.
Pressure should first appear through timing, tone, attention, remembered details, and micro-repairs.

Current files:
- `route_interaction_rules.json`
- `day_02_cross_route_pressure.contract.json`
- `day_02_cross_route_pressure.draft.json`

## 7. QA workflow
- Run dialogue QA on every new draft.
- Run memory continuity only when a draft is intended to test memory source or future callback.
- Do not modify QA tools just to make a weak draft pass.
- Generated QA reports should normally be cleaned before commit.

Useful commands:
```bash
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_02_sandra_callback.draft.json
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_01_marie_couple_anchor.draft.json
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_02_marie_callback.draft.json
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_02_cross_route_pressure.draft.json
python3 tools/check_memory_continuity.py narrative_tool/memory/sandra_day_01_memory_contract.json narrative_tool/drafts/day_02_sandra_callback.draft.json
python3 tools/check_memory_continuity.py narrative_tool/memory/marie_day_01_memory_contract.json narrative_tool/drafts/day_01_marie_couple_anchor.draft.json
python3 tools/check_memory_continuity.py narrative_tool/memory/marie_day_01_memory_contract.json narrative_tool/drafts/day_02_marie_callback.draft.json
```

## 8. Adding a new character or route
1. Define initial proximity context.
2. Define what makes the character emotionally and erotically specific.
3. Define how they know Player and what they remember.
4. Define what they should not become.
5. Create a benchmark before a full draft.
6. Create a memory contract before a callback.
7. Add cross-route rules only when necessary.

Always define how long Player has known the character, current closeness/distance, shared history, social context, and how the relationship affects or is affected by other routes.

## 9. Writing principles
- Use concrete triggers.
- Write actual SMS, not literary dialogue.
- Use imperfect rhythm.
- Keep subtext deniable early.
- Make Player present as a character.
- Choices must be sendable SMS.
- Avoid symmetrical AI banter.
- Avoid explaining the psychology inside the messages.
- Each character must have a specific voice and relationship context.

## 10. Common mistakes to avoid
- Writing choices as author labels.
- Making Marie only guilt or suspicion.
- Making Sandra only forbidden temptation.
- Letting routes ignore each other completely.
- Forcing confession too early.
- Creating route locks in prototypes.
- Overusing metadata words inside actual message text.
- Committing generated reports accidentally.
- Editing runtime game data from `narrative_tool` tasks.
