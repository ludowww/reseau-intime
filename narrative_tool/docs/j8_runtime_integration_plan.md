# J8 Runtime Integration Plan

## Purpose
Préparer l’intégration runtime de J8 **sans** écrire le runtime dans V0.42.

Cette note sert à transformer les drafts J8 verrouillés en plan d’intégration future, avec :
- les fichiers runtime à créer plus tard ;
- l’ordre d’index recommandé ;
- les contraintes d’IDs et de rythme ;
- les invariants à vérifier avant toute écriture JSON.

## Current baseline
- Branche de travail : `work/j8-runtime-integration-plan-v0-42`
- Base demandée : `main / origin/main @ df98409`
- Périmètre : documentation-only
- État attendu : arbre propre avant écriture

## Sources inspected
### J8 direction / drafts
- `narrative_tool/docs/j8_narrative_direction.md`
- `narrative_tool/drafts/day_08_narrative_beat_sheet.md`
- `narrative_tool/drafts/day_08_scene_drafts.md`

### Reviews précédentes
- `narrative_tool/docs/j5_sms_runtime_review_after_pauline_sandra_rewrite.md`
- `narrative_tool/docs/j6_j7_rhythm_review.md`

### Runtime J5-J7 read-only
- `game/data/conversations/chapter_05_index.json`
- `game/data/conversations/chapter_06_index.json`
- `game/data/conversations/chapter_07_index.json`
- `game/data/conversations/chapter_05_*.json`
- `game/data/conversations/chapter_06_*.json`
- `game/data/conversations/chapter_07_*.json`

### Writing / rules / story state
- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/narrative/DIALOGUE_CONTENT_TEXTURE_RULES.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/narrative/ANTI_LOOP_RULES.md`
- `docs/narrative/PLAYER_RESPONSE_RULES.md`
- `docs/narrative/CONSENT_AND_RISK_RULES.md`
- `docs/narrative/RAPHAELLE_ARC_J1_J10.md`
- `docs/narrative/MARIE_ARC_J1_J10.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`

### Sources absent or unavailable, checked without failing
- `docs/dialogue_tool/` — absent
- `game/narrative_memory/day_08.json` — absent
- `game/narrative_routes/routes_schema.json` — absent
- `docs/story_state/J8_SUMMARY.md` — absent

## Runtime absence check
Vérification explicite :
- `game/data/conversations/chapter_08_index.json` — absent
- `game/data/conversations/chapter_08_*.json` — absent
- `game/data/visual_content/chapter_08_proofs.json` — absent

Conclusion : aucun runtime J8 n’existe encore dans ce dépôt, et rien ne doit être créé dans V0.42.

## Locked J8 direction
J8 doit rester court et hiérarchisé.

Direction verrouillée à respecter :
- J8 = 2 scènes par défaut.
- Scène 1 : Raphaëlle / clarté concrète / limite lisible / recentrage.
- Scène 2 : Marie / contrepoint émotionnel / coût du recentrage.
- Sandra = silence actif, micro-trace seulement si indispensable.
- Pauline = trace indirecte, pas de scène directe.
- Mathilde hors centre.
- Nico absent.
- Aucun runtime J8 dans V0.42.

Décisions attendues pour l’intégration future :
- pas de troisième scène par défaut ;
- pas de proofs J8 ;
- pas de nouveau content_id ;
- pas de nouveau flag ;
- pas de route lock ;
- pas de nouvelle photo ;
- pas de confrontation finale.

## Proposed future runtime files
| Future file | Status | Purpose | Create in V0.42? |
|---|---|---|---|
| `game/data/conversations/chapter_08_index.json` | planned | Index runtime J8, ordre d’affichage et disponibilité | no |
| `game/data/conversations/chapter_08_raphaelle_clarity.json` | planned | Scène 1 : clarté concrète, limite lisible, recentrage | no |
| `game/data/conversations/chapter_08_marie_counterpoint.json` | planned | Scène 2 : contrepoint émotionnel et coût du recentrage | no |
| `game/data/conversations/chapter_08_sandra_trace.json` | optional / not default | Micro-trace de silence actif, seulement si validée explicitement | no |
| `game/data/visual_content/chapter_08_proofs.json` | not recommended | Bundle de preuves J8 ; risque de densité et de faux signal | no |

## Proposed future index order
| Order | Future conversation | Role | Required? |
|---|---|---|---|
| 1 | `chapter_08_raphaelle_clarity` | Clarté concrète, limite lisible, recentrage | yes |
| 2 | `chapter_08_marie_counterpoint` | Contrepoint émotionnel, coût du recentrage | yes |
| 3 | `chapter_08_sandra_trace` | Silence actif très bref | no |

Ordre recommandé : Raphaëlle d’abord, Marie ensuite, Sandra seulement en option et seulement si la fin a besoin d’un souffle très court.

## Scene conversion plan
| Draft scene | Future runtime file | Conversion constraints | Risks |
|---|---|---|---|
| Raphaëlle / clarté concrète | `chapter_08_raphaelle_clarity.json` | 1 thread visible, SMS court, limite lisible, pas de refuge, pas d’exposition | Trop de discours explicatif, ou glissement vers une scène de consolation |
| Marie / contrepoint émotionnel | `chapter_08_marie_counterpoint.json` | Réaction courte, charge émotionnelle lisible, pas de confrontation finale, Player doit rester acteur | Refaire un mini-panel, ou prolonger la tension au lieu de la faire respirer |
| Sandra trace optionnelle | `chapter_08_sandra_trace.json` | Silence actif, 3 à 5 bulles max, aucun système nouveau | Recréer un troisième vrai pôle ou surcharger la journée |

## IDs and naming recommendations
### Fichiers futurs recommandés
- `chapter_08_index`
- `chapter_08_raphaelle_clarity`
- `chapter_08_marie_counterpoint`
- `chapter_08_sandra_trace_optional`

### Segment IDs provisoires
- `c08_raphaelle_clarity_01`
- `c08_marie_counterpoint_01`
- `c08_sandra_trace_01`

### Threads
Réutiliser les threads existants si présents :
- `thread_raphaelle_private`
- `thread_marie_private`
- `thread_sandra_private`

Ces IDs sont recommandés pour future intégration, mais aucun fichier/ID runtime n’est créé dans V0.42.

## Flags, content, proofs, and route state
Décisions recommandées avant toute écriture JSON J8 :
- aucun nouveau `content_id` ;
- aucun nouveau `flag` ;
- aucun nouveau fichier de preuves ;
- aucun `route_lock` ;
- aucune photo nouvelle ;
- aucune scène de confrontation finale ;
- aucun nouveau système d’état ;
- aucune modification de `game/data/` dans V0.42.

Contrainte d’écriture : ne pas transformer le plan en mini-système. Le runtime futur doit rester une simple intégration de deux scènes lisibles dans un index unique.

## Runtime validation checklist
Avant toute écriture JSON future, vérifier :
- [ ] Runtime diff limité aux fichiers J8 seulement.
- [ ] `chapter_08_index.json` contient exactement 2 conversations par défaut.
- [ ] `chapter_08_sandra_trace.json` n’existe que si validation explicite.
- [ ] Aucun nouveau fichier de preuves sans validation explicite.
- [ ] Aucun nouveau `content_id`.
- [ ] Aucun nouveau `flag`.
- [ ] Aucun `route_lock`.
- [ ] Aucune confrontation finale.
- [ ] Raphaëlle reste clarté, pas refuge.
- [ ] Marie reste contrepoint émotionnel, pas affrontement.
- [ ] Max 3 messages personnage avant Player.
- [ ] Les choix Player restent courts et envoyables.
- [ ] `python3 tools/validate_game_data.py` OK.
- [ ] `python3 tools/simulate_route_paths.py` OK.
- [ ] `python3 -m unittest discover -s tests -p 'test_*.py' -v` OK.
- [ ] `godot --headless --path game --quit` OK.
- [ ] `godot --headless --path game --resolution 1280x720 --quit` OK.

## Risks
- Recréer un effet panel si Sandra devient une vraie troisième scène.
- Rendre Raphaëlle trop “refuge” au lieu de “limite lisible”.
- Faire de Marie une scène de rupture au lieu d’un contrepoint émotionnel.
- Ajouter par réflexe preuves, flags ou content_id alors que J8 doit rester léger.
- Rompre la continuité des threads visibles en inventant de nouveaux conteneurs inutiles.
- Dégrader la respiration du bloc J5-J7 en surchargeant J8.

## Non-goals
- No runtime patch in V0.42.
- No game/data modification.
- No index creation.
- No chapter_08_index.json.
- No chapter_08 runtime file.
- No JSON conversation.
- No dialogue expansion.
- No route lock.
- No new photo.
- No new content_id.
- No new flag.
- No new proof.
- No confrontation finale.
- No tests/tool changes.
- No reports generated.

## Recommendation
**Option A — Future runtime integration should create exactly 2 J8 conversations: Raphaëlle + Marie.**

Why:
- J8 doit rester court.
- Les drafts Raphaëlle/Marie suffisent à produire la respiration voulue.
- Une trace Sandra risque de recréer un mini-panel.
- Le runtime J5-J7 montre déjà que l’équilibre lisible vient de la hiérarchie, pas de la multiplication des voix.
- Les sources J8 déjà verrouillées convergent vers 2 scènes fortes, avec Sandra seulement en silence actif exceptionnel.

## Next recommended step
Attendre une validation explicite pour l’intégration runtime, puis créer seulement :
1. `game/data/conversations/chapter_08_index.json`
2. `game/data/conversations/chapter_08_raphaelle_clarity.json`
3. `game/data/conversations/chapter_08_marie_counterpoint.json`

Ne créer `chapter_08_sandra_trace.json` que si une micro-trace Sandra est explicitement validée.
