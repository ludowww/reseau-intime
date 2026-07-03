# J8 Narrative Tool Direction

## Purpose

Définir la direction narrative de J8 **avant** toute création runtime.

Objectif produit validé pour cette note :

- préparer J8 comme une journée de respiration / recentrage ;
- éviter de prolonger l’effet panel de J7 ;
- fixer un axe principal lisible ;
- décider des personnages actifs, secondaires, en silence actif ou en trace indirecte ;
- limiter J8 à 2 scènes fortes, 3 scènes maximum absolu ;
- ne pas créer de fichiers runtime J8 ici.

## Current baseline

- Branche : `work/j8-narrative-tool-direction-v0-39`
- Baseline vérifiée : `main / origin/main @ 457d277`
- État du dépôt au départ : arbre propre
- Périmètre : documentation-only
- Runtime J8 : absent à ce stade

## Sources inspected

### Reviews / method docs

- `narrative_tool/docs/j5_j8_narrative_arc_character_rhythm_reassessment.md`
- `narrative_tool/docs/j5_sms_rewrite_method_runtime_integration_plan.md`
- `narrative_tool/docs/j5_sms_runtime_review_after_pauline_sandra_rewrite.md`
- `narrative_tool/docs/j6_j7_rhythm_review.md`

### Runtime J5-J7

- `game/data/conversations/chapter_05_index.json`
- `game/data/conversations/chapter_05_*.json`
- `game/data/conversations/chapter_06_index.json`
- `game/data/conversations/chapter_06_*.json`
- `game/data/conversations/chapter_07_index.json`
- `game/data/conversations/chapter_07_*.json`
- `game/data/visual_content/chapter_05_proofs.json`
- `game/data/visual_content/chapter_06_proofs.json`
- `game/data/visual_content/chapter_07_proofs.json`

### Verified absences in runtime

- `game/data/conversations/chapter_08_index.json` — absent
- `game/data/conversations/chapter_08_*.json` — absent
- `game/data/visual_content/chapter_08_proofs.json` — absent

### Writing / narrative docs

- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/narrative/DIALOGUE_CONTENT_TEXTURE_RULES.md`
- `docs/narrative/DAILY_RHYTHM_AND_CONTENT_DENSITY.md`
- `docs/narrative/ANTI_LOOP_RULES.md`
- `docs/narrative/PROOF_AND_SECRET_MAP.md`
- `docs/narrative/PLAYER_RESPONSE_RULES.md`
- `docs/narrative/CONSENT_AND_RISK_RULES.md`
- `docs/narrative/MARIE_ARC_J1_J10.md`
- `docs/narrative/SANDRA_ARC_J1_J10.md`
- `docs/narrative/MATHILDE_ARC_J1_J10.md`
- `docs/narrative/RAPHAELLE_ARC_J1_J10.md`
- `docs/narrative/PAULINE_ARC_J1_J10.md`
- `docs/narrative/J1_J10_REVISED_SCENARIO_PLAN.md`
- `docs/narrative/J5_J6_REWRITE_PLAN.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`

### Story_state summaries

- `docs/story_state/J5_SUMMARY.md`
- `docs/story_state/J6_SUMMARY.md` — absent
- `docs/story_state/J7_SUMMARY.md` — absent
- `docs/story_state/J8_SUMMARY.md` — absent

### Sources absent or unavailable, checked without failing

- `docs/dialogue_tool/` — absent
- `game/narrative_memory/day_08.json` — absent
- `game/narrative_routes/routes_schema.json` — absent

## Why J8 should exist

J5-J7 already form a dense block: aftermath social, consequences, then a more evenly distributed reaction day.

The reviewed docs converge on the same issue:

- J5 is functionally correct but structurally broad.
- J6 is the cleanest, most hierarchical day.
- J7 is coherent but close to a balanced four-way panel.

J8 should therefore exist as a **respiration day** rather than as another equal-weight day.
It should restore hierarchy, reduce panel feel, and give the block a clearer pause before any later escalation.

## Lessons from J5-J7

### J5

- J5 is dense and readable, but too broad for a clean rhythm model.
- Marie carries the emotional anchor.
- Pauline and Sandra were correctly compressed at runtime, but the day still contains a lot of surface area.
- Raphaëlle is useful as clarity / limit, not as easy refuge.

### J6

- J6 is the strongest rhythm reference.
- It has a clear act / consequence shape.
- It does not feel like a roundtable.
- Its main risk is a single long monological burst, not the day structure itself.

### J7

- J7 is stable, but flatter than J6.
- The four threads each have a voice, yet the day risks feeling balanced instead of focused.
- This is exactly the kind of pattern J8 should avoid extending.

### Cross-day conclusion

J8 should not continue the J7 equilibrium.
It should break it by giving one clear axis, one emotional counterpoint, and one quiet remainder.

## J8 narrative function

### Answer to the core questions

- **What function should J8 have after J5/J6/J7?**
  - A short corrective day: breathing room, recentring, and clarification.
- **Should J8 be a panel day or a recentred day?**
  - A recentred day.
- **Should J8 carry the main axis?**
  - Yes, but only one axis.
- **Should Raphaëlle become the main clarity axis?**
  - Yes.
- **Should Marie remain the emotional secondary?**
  - Yes.
- **Should Sandra be active or silent-active?**
  - Silence active.
- **Should Mathilde be active or silent-active?**
  - Not actively in J8; keep her out of the active center.
- **Should Pauline intervene directly?**
  - No, only as trace indirecte.
- **Should Nico remain absent?**
  - Yes.
- **How many scenes should J8 have?**
  - 2 strong scenes minimum; 3 maximum absolute if a very short trace is necessary.
- **Should J8 contain a new proof?**
  - No.
- **Should J8 contain a final confrontation?**
  - No.
- **Should J8 contain a route lock?**
  - No.

### Function statement

J8 is the day where the story stops adding voices and starts choosing a clearer line.
It should not answer everything.
It should make the next step readable.

## Character role decisions

### Matrix de direction

| Axe | Recommandation J8 | Justification | Risque si mal dosé |
|---|---|---|---|
| Fonction du jour | Respiration / recentrage / clarification | J7 a déjà le bon contenu, mais trop d’équilibre ; J8 doit réintroduire une hiérarchie | Reproduire l’effet panel au lieu de le casser |
| Personnage principal | Raphaëlle | Les docs la définissent comme clarté concrète, limite et refus du refuge flou | La faire dériver vers une morale abstraite ou un refuge romantique |
| Secondaire émotionnel | Marie | Le couple reste l’ancrage émotionnel ; Marie doit garder la pression affective sans monopoliser | La réduire à une simple réaction ou à une jalousie plate |
| Silence actif | Sandra | Un seul silence actif suffit ; Sandra peut rester présente comme retenue, sans prendre toute la parole | Réouvrir le motif “plus tard” comme boucle verbale |
| Trace indirecte | Pauline | Pauline doit rester en bordure : photos / contrôle / garde des traces, mais sans scène directe forte | La rendre omniprésente ou surpuissante |
| Personnage absent | Nico | Sa fonction est surtout miroir social ; J8 n’a pas besoin de lui pour être lisible | Relancer une jalousie périphérique et détourner l’axe principal |
| Preuve / photo | Aucune nouvelle preuve définitive | J8 doit respirer, pas ajouter un nouveau noeud de preuve | Créer un nouveau crochet qui prépare une escalade trop rapide |
| Route state | Routes ouvertes, pas verrouillées | J8 doit clarifier sans fermer | Introduire un lock prématuré |

### Matrice personnages

| Personnage | Statut J8 recommandé | Rôle | À éviter |
|---|---|---|---|
| Marie | Secondaire émotionnel | Donner la température affective du recentrage ; rappeler le couple, la fatigue et la lucidité | Laisser Marie devenir l’axe principal du jour ou une scène de confrontation |
| Sandra | Silence actif | Présence retenue, écho lointain, tension sans ouverture verbale | Lancer une nouvelle boucle “plus tard” ou une disponibilité émotionnelle trop explicite |
| Mathilde | Absent du centre / hors scène | Garder la maison et la loyauté comme hors-champ, sans rouvrir le triangle | La remettre activement au premier plan |
| Raphaëlle | Axe principal | Clarté concrète, limite, respiration lisible, recentrage | En faire une romance refuge ou une voix thérapeutique |
| Pauline | Trace indirecte | Reste dans le champ des photos / du contrôle / des traces, sans scène forte | Lui donner une nouvelle scène directe, une preuve forte ou un secret révélé |
| Nico | Absent | Ne pas réactiver le miroir social maintenant | Le réintroduire pour créer un faux relief |

### Lecture pratique

- **Raphaëlle** doit porter la clarté, la limite et le réel concret.
- **Marie** doit rester le contrepoint émotionnel, pas le second axe principal.
- **Sandra** doit être retenue, non expansive.
- **Mathilde** doit se taire dans ce jour-ci, pour que J8 ne redevienne pas un tour de table domestique.
- **Pauline** doit rester en bordure, à travers les traces.
- **Nico** doit rester absent pour ne pas réouvrir le bruit social de J7.

## Recommended J8 structure

### Proposition de structure J8

| Ordre | Scène narrative_tool proposée | Personnage | Fonction | Intensité | Notes |
|---|---|---|---|---|---|
| 1 | Clarté concrète / recentrage | Raphaëlle | Ouvrir le jour avec une limite lisible, un constat concret ou un recadrage sans grand discours | Moyenne | C’est la vraie entrée du jour ; pas de sur-explication |
| 2 | Contrepoint émotionnel | Marie | Faire sentir ce que la clarté coûte émotionnellement au couple | Forte mais courte | Marie doit réagir, pas monopoliser |
| 3 optionnelle | Trace silencieuse | Sandra | Rappeler qu’une tension existe encore sans transformer cela en troisième vraie scène | Faible | Seulement si le jour a besoin d’un souffle final très court |

### Lecture de la structure

- **2 scènes fortes** est la meilleure cible.
- **3 scènes** ne se justifient que si la troisième reste très courte et presque respirée.
- La structure doit éviter le “tour de table”.
- Le jour doit avoir un centre, pas quatre points d’équilibre.

## What J8 must avoid

### Matrice “à ne pas faire”

| Risque | Pourquoi l’éviter | Conséquence probable |
|---|---|---|
| Ajouter tous les personnages | Cela recrée mécaniquement le panel J7 | Le jour perd sa hiérarchie et sa respiration |
| Créer une nouvelle preuve forte | J8 doit clarifier, pas escalader | Le bloc J5-J8 devient trop chargé trop tôt |
| Réactiver Nico | Il détourne l’attention vers la jalousie sociale | L’axe principal se dilue |
| Mettre Sandra + Mathilde actives ensemble | Deux silences actifs ou deux voix actives cassent la sobriété du jour | Retour du tour de table |
| Transformer Raphaëlle en romance refuge | Elle doit rester claire, concrète et limitée | Le jour glisse vers une échappatoire au lieu d’un recentrage |

### Interdictions de rythme

- Pas de tour de table.
- Pas de journée “tout le monde parle une fois”.
- Pas de scène longue de justification.
- Pas de répétition du motif photo / preuve / contrôle sous une nouvelle forme.
- Pas de confrontation finale déguisée en clarification.

## Proofs, photos, and route state

### Position claire

- **Nouvelle preuve définitive : non**
- **Nouvelle photo créée : non**
- **Route lock : non**
- **Nouveau flag : non**
- **Nouveau content_id : non**
- **Nouveau système state/memory : non**
- **Confrontation finale : non**

### Lecture narrative

J8 peut mentionner des traces déjà existantes, mais il ne doit pas ouvrir une nouvelle couche de preuve.
La bonne fonction est la mise à plat, pas le gain de matière.

Les documents de cadrage confirment aussi que :

- les preuves doivent rester faibles tant qu’elles ne changent pas de fonction ;
- une photo ne doit pas revenir si elle ne change pas de rôle ;
- Raphaëlle doit rester une limite concrète ;
- Marie doit rester un ancrage émotionnel actif ;
- Nico doit rester un miroir social rare, pas un moteur de jour.

## Non-goals

- No runtime patch in V0.39.
- No game/data modification.
- No index modification.
- No chapter_08 runtime file.
- No scene rewrite.
- No prototype modification.
- No route lock.
- No new photo.
- No new content_id.
- No new flag.
- No new system state/memory.
- No tests/tool changes.
- No direct preparation of J8 runtime.

## Recommendation

**Option A — Préparer J8 narrative_tool avec Raphaëlle comme axe principal.**

### Pourquoi

- J6 montre qu’un jour hiérarchisé fonctionne mieux qu’un jour distribué.
- J7 montre le risque du panel quand les voix gardent toutes la même lisibilité.
- Raphaëlle est déjà codée comme clarté concrète, limite et refus du refuge flou.
- Marie peut rester le contrepoint émotionnel sans faire basculer le jour en duel.
- Sandra peut rester en silence actif sans rouvrir une nouvelle disponibilité verbale.
- Pauline peut rester indirecte via les traces, ce qui évite une surcharge supplémentaire.
- Nico n’a pas besoin de revenir pour que J8 soit lisible.

### Pourquoi pas les autres options

- **Option B — Marie comme axe principal** : trop proche de l’ancrage émotionnel déjà très chargé du bloc ; risque de prolonger le conflit au lieu de le décompresser.
- **Option C — Sandra ou Mathilde comme axe principal** : trop proche des dynamiques déjà très actives ; risque de répéter le déséquilibre ou de ramener un mini-panel.
- **Option D — attendre et revenir patcher J6/J7** : les docs montrent plutôt que J6/J7 sont stabilisés ; le bon mouvement maintenant est de préparer J8 comme respiration, pas de rouvrir le runtime existant.

## Next recommended step

Rester en **documentation-only** pour J8, puis utiliser cette note comme base d’un futur cadrage runtime ou d’un beat sheet plus précis.

Le prochain pas utile n’est pas de modifier `game/data/`, mais de traduire cette direction en structure J8 verrouillable seulement après validation.
