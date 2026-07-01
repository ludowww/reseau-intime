# Narrative SMS Tool

## Purpose
The Narrative SMS Tool helps design, benchmark, draft, and validate realistic SMS-style scenes for Réseau Intime.

It is meant to support:
- human SMS rhythm
- character-specific voice
- proximity context
- memory continuity
- route coherence
- cross-route pressure

## Current scope
Current validated scope includes:
- Sandra Day 1 → Day 2 continuity
- Marie Day 1 → Day 2 continuity
- Sandra ↔ Marie cross-route pressure prototype
- Generic memory continuity checks
- Dialogue QA runner

## Folder map
- `benchmarks/` — tone references and editorial notes
- `drafts/` — QA/test drafts, not canonical game data
- `memory/` — memory contracts created by benchmark scenes
- `profiles/` — character, desire, proximity, relationship inputs
- `routes/` — route arcs, fantasy profiles, interaction rules
- `scene_contracts/` — expected structure for future scenes or drafts
- `qa_rules/` — rules used or referenced by QA tools
- `docs/` — explanatory documentation
- `templates/` — reusable starting points
- `reports/` — generated QA reports; should not be committed

## Validated routes
### Sandra
- Day 1 benchmark
- Day 1 draft
- Day 1 memory contract
- Day 2 callback draft
- Future continuity check validated

### Marie
- Route foundation
- Day 1 benchmark
- Day 1 draft
- Day 1 memory contract
- Day 2 callback draft
- Source and future continuity checks validated

### Sandra ↔ Marie
- Interaction rules
- Day 2 cross-route pressure contract
- Day 2 cross-route pressure prototype draft

## QA commands
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

General validation:
```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Generated reports in `narrative_tool/reports/` should not be committed unless explicitly requested.

## Recommended workflow
1. Define proximity and route foundations.
2. Create benchmark tone references.
3. Create a scene contract.
4. Create a QA draft.
5. Create or update a memory contract.
6. Run dialogue QA.
7. Run memory continuity checks.
8. Add cross-route rules only when more than one route can influence the scene.

## See also
- `docs/workflow_usage_guide.md`
- `docs/README.md`
- `docs/memory_continuity_model.md`
- `docs/scene_contract_patterns.md`
