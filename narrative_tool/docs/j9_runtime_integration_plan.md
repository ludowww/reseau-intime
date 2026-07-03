# J9 Runtime Integration Plan

## Purpose
V0.51 prépare l’intégration runtime J9 sans l’exécuter.
Le but est d’éviter une intégration trop rapide de `game/data/` et de verrouiller l’ordre, les fichiers, les garde-fous et les validations futures.

## Locked baseline
- V0.48 : beat sheet J9 verrouillée.
- V0.49 : scene drafts J9 verrouillés.
- V0.50 : product review verrouillée, verdict `validated with minor notes`.
- Baseline de départ : `main / origin/main : ebfcfa8`
- Tag : `v0.50-j9-draft-product-review`

## Runtime integration status
À ce stade :
- aucun `chapter_09_index.json` ;
- aucune conversation J9 runtime ;
- aucun proof J9 runtime ;
- aucun `visual_content` J9 runtime ;
- aucun `content_id` J9 ;
- aucun flag J9 ;
- aucun route lock J9.

Sources lues en read-only pour cadrer ce plan :
- `narrative_tool/docs/j9_draft_product_review.md`
- `narrative_tool/drafts/day_09_scene_drafts.md`
- `narrative_tool/drafts/day_09_beat_sheet.md`
- `narrative_tool/docs/j9_narrative_direction.md`
- `docs/writing/EMOJI_INTIMACY_EVOLUTION_RULES.md`
- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/story_state/J5_SUMMARY.md`
- `game/data/conversations/chapter_08_index.json`
- `game/data/conversations/chapter_08_raphaelle_clarity.json`
- `game/data/conversations/chapter_08_marie_counterpoint.json`
- `game/data/conversations/chapter_05_sandra_later.json`
- `game/data/conversations/chapter_07_proofs.json` — absent
- `game/data/conversations/chapter_06_proofs.json` — absent
- `game/data/conversations/chapter_05_proofs.json` — absent

## Product decision summary
- Sandra est l’axe principal.
- Marie est optionnelle.
- Pauline reste indirecte.
- Raphaëlle repose.
- Mathilde et Nico restent absents.
- J9 doit rester court : 1 scène Sandra par défaut, 2 scènes maximum si Marie est retenue.
- Pas de troisième scène active.
- Pas de panel.
- Pas de proof définitif.
- Pas de contenu adulte explicite.
- Pas de route lock.

## Files to create later

| Future file | Required | Purpose | Notes |
|---|---:|---|---|
| `game/data/conversations/chapter_09_index.json` | yes | Activer J9 et ordonner les conversations | À créer seulement en runtime integration |
| `game/data/conversations/chapter_09_sandra_relance.json` | yes | Scène principale Sandra | Basée sur V0.49, avec micro-notes V0.50 |
| `game/data/conversations/chapter_09_marie_counterpoint.json` | optional | Micro-contrepoint couple | Seulement si Marie doit rester visible |
| `game/data/conversations/chapter_09_proofs.json` | likely yes | Support des 3 contenus visuels minimum | Nom et structure à confirmer en intégration |

## Files not to create yet
Ne pas créer en V0.51 :
- `chapter_09_index.json` ;
- `chapter_09_sandra_relance.json` ;
- `chapter_09_marie_counterpoint.json` ;
- `chapter_09_proofs.json` ;
- fichier `visual_content` ;
- asset image ;
- `content_id` ;
- flag ;
- route lock ;
- `story_state/J9_SUMMARY.md`.

Ces fichiers seront créés seulement après validation du plan d’intégration.

## Conversation structure plan

### Option A — Recommended
1. Sandra conversation only.
2. 3 visual contents still planned through Sandra + indirect traces.
3. Marie not active as a conversation.

### Option B — Acceptable
1. Sandra conversation.
2. Optional Marie micro-conversation.
3. 2 conversations maximum.

Option A remains preferred unless the product owner explicitly wants Marie visible in runtime J9.

## J9 index plan
Future `chapter_09_index.json` should:
- keep J9 short ;
- place Sandra first ;
- include Marie only if Option B is selected ;
- not include Pauline as active conversation ;
- not include Raphaëlle ;
- not include Mathilde ;
- not include Nico.

### Index pseudo-structure, not runtime JSON
```text
day: 9
conversations:
  - chapter_09_sandra_relance
  - chapter_09_marie_counterpoint optional only
proof_content_files:
  - chapter_09_proofs optional/likely after visual validation
```

Cette pseudo-structure n’est pas un JSON à copier tel quel.

## Sandra conversation plan
Future conversation id proposal:
`chapter_09_sandra_relance`

Thread:
`thread_sandra_private`

Role:
main J9 axis.

Source:
`narrative_tool/drafts/day_09_scene_drafts.md`, Scene 1.

Required runtime adjustments from V0.50:
- surveiller Sandra Choice 3 ;
- possibilité d’alléger `Parce que j’aime quand tu reviens.` si trop déclaratif ;
- surveiller la dernière relance si elle paraît trop écrite ;
- garder 😅 unique et justifié ;
- garder la photo douce comme non proof.

Do not change:
- ne pas transformer Sandra en disponibilité acquise ;
- ne pas ajouter confession lourde ;
- ne pas ajouter bascule sexuelle directe ;
- ne pas ajouter route lock ;
- ne pas rendre la photo incriminante.

## Optional Marie conversation plan
Future conversation id proposal:
`chapter_09_marie_counterpoint`

Thread:
`thread_marie_private`

Role:
optional couple counterpoint.

Source:
`narrative_tool/drafts/day_09_scene_drafts.md`, Optional Scene 2.

Use only if :
- J9 needs the couple to remain emotionally visible ;
- Marie can stay short ;
- Marie does not steal Sandra’s axis.

Runtime note:
- Marie may be omitted in Option A.
- If included, keep it short and domestic.
- Verify `Je coupe l’écran.` if it feels too neat in runtime.
- Keep 🙂 unique and justified.
- No direct mention of Sandra.
- No jealousy confrontation.

## Visual / proof plan
J9 needs 3 visual contents minimum in future runtime unless the product owner explicitly validates a new exception.
At least 1 Sandra photo is mandatory.
All visual contents must stay soft / relational / weak social trace / non proof.
No adult explicit visual.
No definitive proof.

| Visual slot | Source | Runtime purpose | Type | Required | Proof strength |
|---|---|---|---|---:|---|
| J9 visual 1 | Sandra | relancer le manque | photo douce / déjeuner / trace relationnelle | yes | weak / non proof |
| J9 visual 2 | Marie | garder le couple visible | photo quotidienne / domestique | recommended if Marie kept | non proof |
| J9 visual 3 | Pauline indirect or Sandra second texture | garder le téléphone vivant sans panel | story floue / social weak trace / seconde texture Sandra | recommended | weak / non proof |

`chapter_09_proofs.json` est probablement nécessaire plus tard pour porter ces visuels, mais V0.51 ne le crée pas.
La structure exacte doit être copiée du format existant au moment de l’intégration, pas inventée ici.

## Future content_id naming proposal
Proposals only, not created in V0.51:

| Proposed content_id | Use | Status |
|---|---|---|
| `j9_sandra_lunch_photo_soft` | Sandra soft relational photo | proposal only |
| `j9_marie_daily_trace` | Marie domestic/couple trace | proposal only |
| `j9_pauline_indirect_story` | Pauline weak social trace | proposal only |
| `j9_sandra_second_texture` | Alternative to Pauline indirect trace | proposal only |

These names are planning proposals only.
They must be confirmed or changed during runtime integration.
No `content_id` is created in V0.51.

## State / flag / route-lock policy
No new route lock in J9.
No exclusive Sandra route.
No Marie confrontation flag.
No Pauline proof flag.
No escalation flag that implies definitive cheating.

Possible future weak state only if required by existing systems:
- soft memory of Sandra relance ;
- visual seen state handled by existing visual/proof system ;
- no route lock.

Do not invent flags in V0.51.
Do not add flags in future runtime unless the existing structure requires them.

## Emoji and phone-language integration
Sandra : 😅 unique, gêne, retenue.
Marie : 🙂 unique if Marie retained, tendresse domestique.
No emoji uniformization.
No mechanical emoji insertion.
Absence of further emojis is intentional.

Before runtime integration, run the updated tooling :
- `dialogue_context_pack` for Sandra / Marie ;
- `dialogue_rhythm_report` after JSON creation ;
- `dialogue_voice_check` after JSON creation.

## Runtime validation checklist

- [ ] `chapter_09_index.json` created only in runtime integration.
- [ ] Sandra conversation created and first in J9.
- [ ] Marie omitted or kept optional and short.
- [ ] No active Pauline conversation.
- [ ] No Raphaëlle / Mathilde / Nico J9 conversation.
- [ ] 3 visual contents minimum planned or explicit exception validated.
- [ ] At least 1 Sandra visual.
- [ ] No definitive proof.
- [ ] No adult explicit content.
- [ ] No route lock.
- [ ] No invented content_id outside approved visual plan.
- [ ] Dialogue choices remain 3–9 words where possible.
- [ ] Max 3 messages from same character before Player.
- [ ] Emojis remain minimal and justified.
- [ ] `validate_game_data` passes without warnings.
- [ ] `simulate_route_paths` passes.
- [ ] `unittest` discovery passes.
- [ ] Godot headless passes.
- [ ] Godot 1280x720 headless passes.

## Risks and mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Sandra becomes too available | Breaks route tension | Keep V0.50 minor notes, especially Choice 3 |
| Marie steals the axis | J9 becomes couple repair day | Use Option A or keep Marie micro |
| Visual quota creates artificial content | Panel / filler risk | Use indirect trace or Sandra second texture |
| Pauline becomes omniscient | Too much proof pressure | Keep trace weak and indirect |
| content_id naming drifts | Runtime confusion | Confirm names during integration only |
| J9 becomes too long | Breaks J8/J9 rhythm | 1 conversation preferred, 2 maximum |

## Implementation sequence for later
1. Choose Option A or Option B.
2. Confirm visual structure and content_id names.
3. Create `chapter_09_proofs.json` if needed by visual system.
4. Create Sandra conversation JSON from V0.49 draft with V0.50 notes.
5. Optionally create Marie micro-conversation JSON.
6. Create `chapter_09_index.json`.
7. Run dialogue tooling on new JSON.
8. Run project validations.
9. Product review runtime output.
10. Only then merge/tag runtime J9.

Do not skip step 1 and 2.
Do not create `game/data` files before the product owner validates this plan.

## Non-goals for V0.51
- No runtime creation.
- No `game/data` modification.
- No `chapter_09_index.json`.
- No chapter_09 conversation file.
- No proof J9 file.
- No visual_content file.
- No asset.
- No content_id.
- No flag.
- No route lock.
- No dialogue rewrite.
- No draft modification.
- No tests modification.
- No tools modification.
- No reports generated.

## Review checklist
- [ ] Plan is documentation-only.
- [ ] Files to create later are listed.
- [ ] Files not to create yet are listed.
- [ ] Option A / B structure is clear.
- [ ] Sandra-first order is preserved.
- [ ] Marie remains optional.
- [ ] Pauline remains indirect.
- [ ] Visual plan has 3 slots.
- [ ] Sandra visual is required.
- [ ] content_id names are proposals only.
- [ ] No state/flag/lock is created.
- [ ] Future validation sequence is clear.
- [ ] No runtime is created in V0.51.

## Recommendation
Recommendation: validate this runtime integration plan before creating any J9 game/data files.
Next step should be either:
- V0.52 Runtime Integration Plan Review, or
- V0.52 J9 Runtime Integration only if the product owner explicitly approves Option A or Option B and the visual/content_id structure.
