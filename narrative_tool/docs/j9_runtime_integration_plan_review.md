# J9 Runtime Integration Plan Review

## Purpose
Relire le plan d’intégration runtime J9 avant toute modification de `game/data/`.
Valider ou ajuster le plan V0.51, trancher Option A / Option B, clarifier la structure visual/proof, le naming des `content_id`, la présence éventuelle de Marie, et la manière de porter 3 visuels sans recréer un panel.

## Reviewed baseline
- Branche vérifiée au départ : `work/j9-runtime-plan-review-v0-52`
- SHA : `5764467`
- État git au départ : propre
- Baseline fournie dans le prompt : `main / origin/main @ 5764467`
- Tag de référence fourni : `v0.51-j9-runtime-integration-plan`
- Périmètre de cette V0.52 : documentation-only

## Reviewed files
### Plan / review / direction
- `narrative_tool/docs/j9_runtime_integration_plan.md`
- `narrative_tool/docs/j9_draft_product_review.md`
- `narrative_tool/drafts/day_09_scene_drafts.md`
- `narrative_tool/drafts/day_09_beat_sheet.md`
- `narrative_tool/docs/j9_narrative_direction.md`

### Writing / continuity sources
- `docs/writing/EMOJI_INTIMACY_EVOLUTION_RULES.md`
- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/story_state/J5_SUMMARY.md`

### Runtime references inspected
- `game/data/conversations/chapter_08_index.json`
- `game/data/conversations/chapter_08_raphaelle_clarity.json`
- `game/data/conversations/chapter_08_marie_counterpoint.json`
- `game/data/conversations/chapter_05_sandra_later.json`

### Proof / visual references inspected
- `game/data/visual_content/chapter_05_proofs.json`
- `game/data/visual_content/chapter_06_proofs.json`
- `game/data/visual_content/chapter_07_proofs.json`

### Existence / absence checks
- `game/data/conversations/chapter_05_proofs.json` — absent
- `game/data/conversations/chapter_06_proofs.json` — absent
- `game/data/conversations/chapter_07_proofs.json` — absent
- `game/data/visual_content/` — present
- `game/data/content/` — absent
- `game/data/media/` — absent

## Runtime structure findings
- `chapter_08_index.json` montre une structure très lisible : 2 conversations visibles par défaut, ordre Raphaëlle puis Marie, `proof_content_files: []`, aucune trace Sandra.
- `chapter_08_raphaelle_clarity.json` et `chapter_08_marie_counterpoint.json` confirment le modèle runtime actuel : une conversation = un thread visible, Player répond une fois par choix, pas de Player auto-rendu hors choix.
- Les fichiers de proof existants ne sont pas dans `game/data/conversations/` mais dans `game/data/visual_content/`.
- Le modèle réel des proofs J5-J7 est un fichier `chapter_XX_proofs.json` avec un tableau `items[]` portant au minimum `id`, `character`, `tier`, `type`, `source_app`, `asset_path`, `context`, `tags`, `is_proof`, `risk_level` et drapeaux de capture/suppression/壁紙.
- J8 confirme qu’un index peut fonctionner sans proof runtime (`proof_content_files: []`), mais cela ne doit pas être inventé pour J9 si le brief exige 3 visuels.
- Aucun `chapter_09_index.json`, aucune conversation J9, aucun proof J9, aucun `content_id`, aucun flag et aucun route lock n’existent à ce stade.

## Product verdict
validated with required decisions

## Option A vs Option B review

| Option | Structure | Strengths | Risks | Runtime impact | Recommendation |
|---|---|---|---|---|---|
| Option A | Sandra only | Plus nette, respecte Sandra comme axe principal, évite le panel, garde J9 respirable, permet de porter les 3 visuels via une seule voix + traces indirectes | Il faut cadrer finement les 3 visuels sans ouvrir Marie, et éviter que Sandra paraisse trop disponible | Un thread principal, lecture rapide, intégration plus sûre | **Recommandée** |
| Option B | Sandra + Marie micro | Garde Marie visible, facilite le contrepoint domestique, peut rendre le coût du recentrage plus tangible | Peut voler un peu l’axe Sandra, rallonger J9, et recréer une journée à deux pôles trop lourde | Deux threads visibles, plus de charge d’intégration | Acceptable seulement si le produit veut Marie visible en runtime J9 |

## Recommended runtime option
Option A recommended for first runtime pass.
Marie should remain omitted in first runtime pass unless product owner explicitly wants the couple counterpoint visible in J9.

## Sandra runtime review
- Sandra first : oui.
- Thread proposé : `thread_sandra_private` ; validé.
- Conversation id proposé : `chapter_09_sandra_relance` ; validé.
- Le draft V0.49 reste exploitable comme base.
- Les notes V0.50 peuvent être intégrées plus tard, sans ajouter de route lock.
- Choice 3 surveillance : oui, surtout la charge affective de `Parce que j’aime quand tu reviens.`
- Photo douce / non proof : oui.
- Pas de confession lourde.
- Pas de bascule sexuelle directe.
- Pas de route lock.

## Marie runtime review
- Marie est optionnelle.
- Thread proposé : `thread_marie_private` ; validé si Option B.
- Conversation id proposé : `chapter_09_marie_counterpoint` ; validé si Option B / omis si Option A.
- Marie ne doit pas mentionner Sandra directement.
- Pas de confrontation jalouse.
- Pas de journée de réparation du couple.
- Si Marie est gardée, la scène doit rester courte, domestique, et émotionnelle.

## Pauline indirect review
- Pauline ne doit pas être une conversation active dans le premier runtime J9.
- Le rôle attendu reste indirect : trace sociale faible, photo floue, ou seconde texture visuelle si nécessaire.
- Pas d’omniscience.
- Pas de chantage.
- Pas de révélation.
- Pas de scène Pauline lourde dans le premier pass.

## Visual / proof structure review
Point critique : la structure réelle des proofs existe déjà sous `game/data/visual_content/`, pas dans `game/data/conversations/`.

Décision observée :
- 3 visuels minimum : requis par la direction produit.
- 1 photo Sandra minimum : obligatoire.
- La structure proof/visual doit être calée sur le modèle existant `chapter_05_proofs.json` / `chapter_06_proofs.json` / `chapter_07_proofs.json` dans `game/data/visual_content/`.
- `chapter_09_proofs.json` n’est pas approuvé automatiquement, mais le format futur doit probablement suivre ce modèle de `visual_content` plutôt que d’inventer une nouvelle structure.
- Le fait que `chapter_08_index.json` ait `proof_content_files: []` montre seulement une absence actuelle de proof J8, pas une règle générale à recopier pour J9.

### Visual structure decision
- 3 visuals: required by product direction.
- Sandra photo: required.
- Proof/visual file format: must be confirmed from current runtime data before creation.
- chapter_09_proofs.json: not approved automatically.

## Content_id naming review

| Proposed content_id | Verdict | Notes |
|---|---|---|
| `j9_sandra_lunch_photo_soft` | Acceptable as planning label | Bon label provisoire pour la photo Sandra ; finaliser après confirmation du format proof/visual |
| `j9_marie_daily_trace` | Acceptable as planning label | À garder seulement si Marie reste visible en runtime J9 |
| `j9_pauline_indirect_story` | Acceptable only if Pauline trace is kept | À remplacer par une texture Sandra si Option A reste stricte |
| `j9_sandra_second_texture` | Acceptable as planning label | Bonne solution de repli pour rester dans l’axe Sandra |

Names are acceptable as planning labels, but final `content_id` must be confirmed during runtime integration after visual/proof structure is identified.

## State / flag / route-lock review
- No route lock.
- No exclusive Sandra route.
- No Marie confrontation flag.
- No Pauline proof flag.
- No cheating-definitive escalation flag.
- No new flag unless the existing runtime structure requires a weak memory.
- Prefer no new flags for the first runtime pass.

## Emoji and phone-language review
- Sandra 😅 unique and justified.
- Marie 🙂 only if Marie retained.
- No emoji uniformization.
- No mechanical emoji insertion.
- No extra emoji needed.
- Pauline n’a pas de décision emoji directe tant qu’elle reste indirecte.

## Runtime implementation readiness
Runtime integration readiness : yes with required decisions

Décisions requises :
1. Option A or Option B.
2. Visual/proof current format.
3. Final content_id naming after visual format.
4. Whether Marie is omitted in first runtime pass.

## Blocking issues
### Blocking issues
- None for planning.
- Blocking issue before runtime: visual/proof format must be confirmed from the current runtime model.

### Minor issues
- Final `content_id` names remain provisional until the proof/visual format is locked.
- Marie presence is still a product decision, not a technical one.

### Watch points
- Keep J9 short and respirable.
- Do not rebuild a multi-voice panel under the excuse of “3 visuals”.
- Do not invent a new proof schema when a real `game/data/visual_content/` model already exists.
- Do not let Marie become a second main axis by accident.

## Decisions required before runtime

| Decision | Required before runtime? | Recommended answer |
|---|---:|---|
| Option A or B | yes | Option A |
| Marie runtime presence | yes | Omit first pass unless product owner wants it |
| Visual/proof file format | yes | Inspect current runtime format before creating |
| 3 visual contents | yes | Keep unless explicit exception |
| Sandra content_id | yes | Confirm during runtime |
| Route lock | yes | No |

## Recommended runtime scope
Recommended first runtime scope:
- Option A.
- Create Sandra conversation only.
- Create J9 index.
- Handle visuals only after the visual/proof format is confirmed.
- No Marie conversation in first pass.
- No active Pauline.
- No route lock.
- No new flags unless required by the existing structure.

If the product owner insists on 3 runtime visuals immediately, visual/proof structure must be solved before creating the J9 index.

## What must not change
- Sandra remains main axis.
- Marie remains optional.
- Pauline remains indirect.
- Raphaëlle remains resting.
- Mathilde and Nico remain absent.
- No third active conversation.
- No definitive proof.
- No adult explicit content.
- No route lock.
- No unvalidated `content_id`.
- No runtime in V0.52.

## Review checklist
- [x] Review is documentation-only.
- [x] Option A / B are compared.
- [x] One runtime option is recommended.
- [x] Sandra-first order is preserved.
- [x] Marie remains optional.
- [x] Pauline remains indirect.
- [x] Visual/proof uncertainty is documented.
- [x] 3 visual requirement is preserved.
- [x] `content_id` proposals are reviewed.
- [x] No route lock is approved.
- [x] Required decisions are listed.
- [x] No runtime is created in V0.52.

## Recommendation
Recommendation: approve Option A for first runtime pass, but do not start runtime integration until the current visual/proof format is confirmed.
