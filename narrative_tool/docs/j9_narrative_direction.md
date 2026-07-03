# J9 Narrative Direction

## Purpose

Définir la fonction narrative de J9 **après** le recentrage de J8, sans créer de runtime.

Objectif produit pour cette note :
- éviter un retour à l’effet panel ;
- choisir un axe principal clair ;
- décider quelles voix doivent être actives, absentes ou seulement indirectes ;
- préparer la suite sans créer de `chapter_09` runtime.

## Current baseline

- Branche : `work/j9-narrative-direction-v0-45`
- SHA : `47bb73d`
- git status au départ : propre
- Périmètre : documentation-only
- Runtime J9 : absent à ce stade

## Sources inspected

### Story state / continuité

- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/story_state/J1_SUMMARY.md`
- `docs/story_state/J2_SUMMARY.md`
- `docs/story_state/J3_SUMMARY.md`
- `docs/story_state/J4_SUMMARY.md` — absent
- `docs/story_state/J5_SUMMARY.md`
- `docs/story_state/J6_SUMMARY.md` — absent
- `docs/story_state/J7_SUMMARY.md` — absent
- `docs/story_state/J8_SUMMARY.md` — absent

### J5-J8 narrative_tool

- `narrative_tool/docs/j5_sms_runtime_review_after_pauline_sandra_rewrite.md`
- `narrative_tool/docs/j6_j7_rhythm_review.md`
- `narrative_tool/docs/j8_narrative_direction.md`
- `narrative_tool/drafts/day_08_narrative_beat_sheet.md`
- `narrative_tool/drafts/day_08_scene_drafts.md`
- `narrative_tool/docs/j8_runtime_integration_plan.md`
- `narrative_tool/docs/j8_runtime_review.md`

### Runtime J5-J8 en lecture seule

- `game/data/conversations/chapter_05_index.json`
- `game/data/conversations/chapter_05_*.json`
- `game/data/conversations/chapter_06_index.json`
- `game/data/conversations/chapter_06_*.json`
- `game/data/conversations/chapter_07_index.json`
- `game/data/conversations/chapter_07_*.json`
- `game/data/conversations/chapter_08_index.json`
- `game/data/conversations/chapter_08_raphaelle_clarity.json`
- `game/data/conversations/chapter_08_marie_counterpoint.json`

### Docs d’écriture / voix / arcs

- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/narrative/DIALOGUE_CONTENT_TEXTURE_RULES.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/narrative/ANTI_LOOP_RULES.md`
- `docs/narrative/PLAYER_RESPONSE_RULES.md`
- `docs/narrative/CONSENT_AND_RISK_RULES.md`
- `docs/narrative/MARIE_ARC_J1_J10.md`
- `docs/narrative/RAPHAELLE_ARC_J1_J10.md`
- `docs/narrative/SANDRA_ARC_J1_J10.md`
- `docs/narrative/PAULINE_ARC_J1_J10.md`
- `docs/narrative/MATHILDE_ARC_J1_J10.md`
- `docs/narrative/NICO_ARC_J1_J10.md` — absent

### Sources absentes connues, vérifiées sans échec

- `docs/dialogue_tool/` — absent
- `game/narrative_memory/day_09.json` — absent
- `game/narrative_routes/routes_schema.json` — absent
- `docs/story_state/J9_SUMMARY.md` — absent
- `game/data/conversations/chapter_09_index.json` — absent
- `game/data/conversations/chapter_09_*.json` — absent
- `game/data/visual_content/chapter_09_proofs.json` — absent

## Existing J9 runtime absence check

- `chapter_09_index.json` : absent
- `chapter_09_*.json` : absent
- `chapter_09_proofs.json` : absent
- `day_09.json` : absent
- `routes_schema.json` : absent
- `J9_SUMMARY.md` : absent
- `docs/dialogue_tool/` : absent

Conclusion : aucun runtime J9 ne doit être créé dans cette V0.45.

## J5-J8 context

J5-J8 montrent une montée puis un recentrage :
- **J5** : journée dense, large, sociale, utile mais déjà proche de l’effet panel.
- **J6** : journée la plus hiérarchisée du bloc, avec un axe concret sur la trace et ses conséquences.
- **J7** : journée stable mais plus plate, avec 4 voix actives et un risque réel de panel.
- **J8** : journée courte et lisible, 2 scènes seulement, Raphaëlle puis Marie.

Mesures utiles relevées sur le runtime :
- J5 : 7 scènes ; beaucoup de surface, une journée large.
- J6 : 4 scènes ; meilleur modèle de hiérarchie.
- J7 : 4 scènes ; équilibre plus uniforme, donc plus panel.
- J8 : 2 scènes ; hiérarchie nette.
- J7 a des choix Player beaucoup plus longs que J8 ; J8 reste volontairement bref.

Conclusion de contexte : J8 a remis de l’air. J9 doit utiliser cet air pour relancer une tension intime contrôlée, pas pour recréer un tour de table.

## J9 narrative function

**Fonction narrative recommandée : relance intime contrôlée.**

J9 ne doit pas annuler J8. Il doit transformer le calme de J8 en tension plus personnelle, plus située, moins sociale.

Réponses directes aux questions :
- **Fonction narrative de J9** : relancer la tension intime après la respiration de J8.
- **Relancer la tension ou prolonger la respiration ?** : relancer la tension, mais sans refaire de panel ni d’escalade explicite.
- **Axe principal** : Sandra.
- **Nombre de scènes par défaut** : 1 scène forte par défaut, 2 maximum si le contrepoint est réellement utile.
- **Sandra après son silence actif J8 ?** : oui, mais de façon prudente et retenue.
- **Marie présente ou seulement en coût indirect ?** : présente, au moins en contrepoint bref ou en coût indirect visible.
- **Raphaëlle en actif ?** : non, repos recommandé.
- **Pauline en trace sociale ?** : seulement indirecte, pas de scène complète.
- **Mathilde ou Nico ?** : absents par défaut.
- **Proof / photo / content_id ?** : non.
- **Route lock ?** : non.

## Options considered

### Option A — Sandra main axis / relance intime contrôlée

J9 réactive Sandra comme axe principal.
La scène part d’un détail concret, d’un ancien message, d’un silence, d’un prétexte discret ou d’une gêne.
Le désir reste retenu, non consommé, non déclaré frontalement.
Marie reste présente comme coût moral ou arrière-plan, pas forcément en scène directe.

### Option B — Marie main axis / réparation du couple

J9 reste centré sur Marie.
La journée prolonge J8 avec une tentative de présence plus concrète.
Risque : trop fermer les autres routes ou transformer J9 en réparation morale.

### Option C — Pauline / social trace axis

J9 relance la pression sociale via Pauline ou une trace indirecte.
Risque : revenir trop vite au mécanisme proof/photo après J5.

### Option D — Multi-voice day

J9 ouvre plusieurs voix.
Risque : recréer l’effet panel que J8 vient de corriger.
Cette option est à éviter sauf justification forte.

## Option comparison matrix

| Option | Axe | Forces | Risques | Verdict |
|---|---|---|---|---|
| A | Sandra | Prolonge le manque actif de J8, garde une tension intime crédible, évite le retour au social massif | Sandra peut devenir trop disponible si la scène s’explique trop | **Recommandée** |
| B | Marie | Garde le couple au centre, simple à lire, cohérent avec l’ancrage émotionnel | Peut fermer trop vite les autres routes et devenir une réparation morale | Réserve |
| C | Pauline/social | Rappelle la mémoire sociale et les traces | Recycle trop vite le réflexe preuve/photo | À éviter |
| D | Multi-voice | Donne de la variété apparente | Recrée presque mécaniquement l’effet panel | À éviter |

## Character role matrix

| Personnage | Statut J9 recommandé | Fonction | Risque | Décision |
|---|---|---|---|---|
| Sandra | Actif, axe principal | Convertir l’absence en tension intime retenue | Devenir trop disponible ou trop explicite | **Oui, axe principal** |
| Marie | Présente, contrepoint bref ou coût indirect | Rappeler le couple et le coût affectif | Être effacée ou devenir une simple contrainte morale | **Oui, en second plan** |
| Raphaëlle | Repos | Ne pas relancer la clarté de J8 immédiatement | Refaire une clarté qui prend la place de Sandra | **Non en actif** |
| Pauline | Trace indirecte seulement | Rappeler le contrôle / la mémoire sociale | Revenir au système de preuves | **Indirect seulement** |
| Mathilde | Absente par défaut | Éviter de rouvrir la maison comme tour de table | Recentrer la journée sur le domestique | **Non** |
| Nico | Absent par défaut | Éviter un faux relief social | Ramener la comparaison / jalousie de groupe | **Non** |

## Recommended J9 shape

| Slot | Scene / trace | Character | Function | Required? |
|---|---|---|---|---|
| 1 | Scène intime contrôlée, déclenchée par un détail ou un silence | Sandra | Axe principal ; relance retenue, pas de disponibilité totale | Oui |
| 2 | Contrepoint court ou coût indirect dans le couple | Marie | Rappeler le champ conjugal et le prix de l’écart | Optionnel mais recommandé |
| 3 | Trace indirecte, si nécessaire seulement | Pauline (indirecte) | Rappeler la mémoire sociale sans rouvrir le panel | Non |

## Scene principles

- 1 scène principale par défaut.
- 2 scènes maximum si le contrepoint est réellement utile.
- Aucune scène de 100 messages.
- Pas de long monologue.
- Max 3 messages personnage avant Player.
- Un message = une idée.
- Choix Player courts, envoyables, 3 à 9 mots.
- Player doit rester actif, pas spectateur.
- La tension doit venir de détails concrets, pas d’explications.
- Sandra ne doit pas arriver comme une disponibilité totale.
- Sandra ne doit pas être une récompense après J8.
- Marie ne doit pas être effacée.
- Pauline ne doit pas redevenir un système de preuves.
- J9 ne doit pas ouvrir un tour de table.

## Risks and mitigations

| Risk | Severity | Mitigation |
|---|---|---|
| J9 panel | Élevée | Garder Sandra comme axe unique et limiter le jour à 1–2 scènes |
| Sandra too available | Élevée | La laisser prudente, humaine, un peu esquive, sans désir consommable frontal |
| Marie erased | Moyenne | Garder un contrepoint bref ou un coût indirect lisible |
| proof/photo reflex | Élevée | Interdire la reprise du réflexe photo/preuve comme moteur central |
| route lock too early | Moyenne | Laisser les routes ouvertes ; aucun verrou en J9 |
| desire too explicit too soon | Élevée | Décrire la retenue, le détour et le temps qui passe, pas une déclaration nette |

## Non-goals

- No runtime J9 in V0.45.
- No game/data modification.
- No `chapter_09_index.json`.
- No `chapter_09` conversation file.
- No proof J9.
- No new photo.
- No new `content_id`.
- No new flag.
- No route lock.
- No new system state/memory.
- No full dialogue draft.
- No 100-message conversation.
- No tests/tool changes.
- No reports generated.
- No merge/tag.

## Recommendation

**Option A — J9 relance Sandra comme axe principal, avec 1 à 2 scènes maximum.**

Why:
- J8 a déjà fait la respiration.
- Sandra a été gardée en silence actif en J8, donc J9 peut transformer ce manque en tension.
- Le couple doit rester dans le champ, mais sans prendre tout l’espace.
- Le panel reviendrait immédiatement si plusieurs voix fortes étaient réouvertes.
- Une preuve, une photo ou un lock seraient un faux signal à ce stade.

## Next recommended step

Préparer, si demandé ensuite, un plan J9 très court ou un beat sheet J9 centré sur Sandra, avant toute écriture runtime. Aucun fichier `game/data/` ne doit être créé à ce stade.