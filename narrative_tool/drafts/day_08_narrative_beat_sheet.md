# Day 8 Narrative Beat Sheet

## Purpose

Définir J8 comme une journée de respiration, de recentrage et de clarification avant toute création runtime.

Objectif produit : transformer la direction verrouillée en V0.39 en un beat sheet précis, lisible, et strictement documentation-only.

## Current baseline

- Branche de travail : `work/j8-narrative-beat-sheet-v0-40`
- Base vérifiée au départ : `main / origin/main` SHA `8cbe5e0`
- J5, J6 et J7 existent déjà en runtime.
- J5 est la journée la plus dense et la plus bruitée.
- J6 reste la référence la plus hiérarchisée et la plus propre.
- J7 est cohérent, mais proche d’un effet panel à quatre voix.
- J8 n’existe pas encore en runtime.
- `chapter_06_raphaelle_clarity.json` existe, mais n’est pas dans l’index actif de J6 : c’est un hors-champ de lecture, pas un ajout automatique.

## Sources inspected

### J8 direction / reassessment

- `narrative_tool/docs/j8_narrative_direction.md`
- `narrative_tool/docs/j5_j8_narrative_arc_character_rhythm_reassessment.md`
- `narrative_tool/docs/j5_sms_rewrite_method_runtime_integration_plan.md`
- `narrative_tool/docs/j5_sms_runtime_review_after_pauline_sandra_rewrite.md`
- `narrative_tool/docs/j6_j7_rhythm_review.md`

### Runtime J5-J7 read-only

- `game/data/conversations/chapter_05_index.json`
- `game/data/conversations/chapter_05_*.json`
- `game/data/conversations/chapter_06_index.json`
- `game/data/conversations/chapter_06_*.json`
- `game/data/conversations/chapter_07_index.json`
- `game/data/conversations/chapter_07_*.json`

### Narrative / writing / story state

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
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`

### Story-state summaries

- `docs/story_state/J6_SUMMARY.md` — absent
- `docs/story_state/J7_SUMMARY.md` — absent
- `docs/story_state/J8_SUMMARY.md` — absent

### Sources absentes connues vérifiées

- `docs/dialogue_tool/` — absent
- `game/narrative_memory/day_08.json` — absent
- `game/narrative_routes/routes_schema.json` — absent

## Runtime absence check

- `game/data/conversations/chapter_08_index.json` — absent
- `game/data/conversations/chapter_08_*.json` — absent
- `game/data/visual_content/chapter_08_proofs.json` — absent

Conclusion : J8 n’a pas de runtime actif à ce stade, ce qui confirme que la bonne sortie V0.40 est bien une note de cadrage, pas un patch.

## J8 locked direction from V0.39

J8 doit casser l’équilibre de J7, pas le prolonger.

Direction verrouillée :

- journée courte, respirable, recentrée ;
- une seule vraie axe principal ;
- Raphaëlle = axe principal ;
- Marie = contrepoint émotionnel ;
- Sandra = silence actif ;
- Pauline = trace indirecte ;
- Mathilde hors centre ;
- Nico absent ;
- 2 scènes fortes maximum ;
- 3 scènes maximum absolu si une trace très courte est vraiment nécessaire ;
- aucune nouvelle preuve définitive ;
- aucune nouvelle photo ;
- aucun nouveau content_id ;
- aucun nouveau flag ;
- aucun route lock ;
- aucune confrontation finale ;
- pas de panel ;
- pas de tour de table ;
- pas de romance refuge avec Raphaëlle ;
- pas de grande scène de jalousie avec Marie.

Lecture simple : J8 doit rendre la suite lisible, pas plus chargée.

## Beat sheet overview

| Ordre | Scène | Personnage | Fonction | Intensité | Statut |
|---|---|---|---|---|---|
| 1 | Clarté concrète / recentrage | Raphaëlle | Poser une limite lisible et ramener Player au réel concret | Moyenne | obligatoire |
| 2 | Contrepoint émotionnel | Marie | Faire sentir ce que la clarté coûte au couple sans fermer les routes | Forte mais courte | obligatoire |
| 3 | Trace silencieuse (si vraiment nécessaire) | Sandra | Un rappel très bref, presque en suspension, sans vraie scène | Faible | optionnel / non retenu |

## Scene 1 — Raphaëlle / clarté concrète

**Goal:** recentrer Player sur ce qu’il fait vraiment, et non sur ce qu’il pourrait expliquer.

**Trigger:** un constat concret de décalage : agenda, délai de réponse, dossier ouvert, fatigue lisible, ou comportement qui ne tient plus ensemble.

**Opening beat:** Raphaëlle ouvre avec une observation simple, concrète, presque administrative, puis glisse vers une question nette.

**Emotional movement:** calme → précision → limite. Elle ne console pas ; elle nomme.

**Player choice shape:** réponses courtes, envoyables, idéalement 3 à 8 mots, chacune avec un seul geste : assumer, clarifier, recadrer, ou reconnaître un flou.

**Ending beat:** Player repart avec un cap plus clair ; Raphaëlle reste disponible seulement si la clarté est choisie.

**Flags/content:** none added.

**Runtime caution:** ne pas faire de Raphaëlle une cachette romantique, ni une thérapeute, ni une voix qui analyse tout le triangle.

### Fonction exacte de la scène Raphaëlle

- ouvrir une respiration ;
- poser une limite concrète ;
- faire émerger une clarté praticable ;
- recentrer Player sur l’action réelle plutôt que sur le commentaire.

### Risque principal

La faire basculer vers une romance refuge ou vers une consolation trop douce.

### Ce qu’il faut éviter

- thérapie déguisée ;
- grand discours sur le désir ;
- analyse de tout le triangle ;
- flirt refuge ;
- mini-climax émotionnel.

### Ce qui doit rester après la scène

Raphaëlle reste présente, mais pas disponible comme cachette. Le jour s’ouvre, il ne se résout pas.

## Scene 2 — Marie / contrepoint émotionnel

**Goal:** faire sentir la température du couple après la clarté, sans transformer Marie en scène de rupture.

**Trigger:** Marie perçoit une différence réelle : fatigue, distance, ton changé, présence moins franche, ou quelque chose qui ne sonne plus comme d’habitude.

**Opening beat:** Marie entre par un détail quotidien, puis laisse apparaître que la distance n’est plus seulement imaginaire.

**Emotional movement:** proximité → lucidité → légère tension. Elle garde le couple dans le champ, mais sans figer la route.

**Player choice shape:** choix courts et concrets, qui répondent à une sensation, pas à une accusation. Pas de mini-thèse, pas de justification longue.

**Ending beat:** le couple reste visible, mais la scène laisse une distance lisible au lieu de fermer le système.

**Flags/content:** none added.

**Runtime caution:** ne pas transformer Marie en confrontation finale, ni en juge omnisciente, ni en jalousie théâtrale.

### Fonction exacte de la scène Marie

- donner le contrepoids émotionnel ;
- rappeler le couple ;
- laisser sentir la fatigue et la distance ;
- maintenir une porte ouverte au lieu de clore le bloc.

### Risque principal

La faire monter trop vite en conflit conjugal majeur.

### Ce qu’il faut éviter

- accusation frontale ;
- tour de table affectif ;
- jalousie énorme ;
- révélation totale ;
- fermeture de route.

### Ce qui doit rester après la scène

Marie continue d’être l’ancre émotionnelle, mais elle ne devient pas la scène finale du jour.

## Optional trace — Sandra or Pauline

### Option trace Sandra — silence actif

Sandra est la seule trace optionnelle qui reste compatible avec la respiration du jour.

Pourquoi elle peut marcher :

- elle peut rester en silence actif ;
- elle peut rappeler une retenue ou un manque sans relancer le bruit ;
- elle peut fonctionner comme un écho, pas comme un troisième axe.

Pourquoi elle est fragile :

- si elle parle trop, elle rouvre la boucle “plus tard” ;
- si elle apporte un choix complexe, le jour redevient un mini-panel ;
- si elle devient présente, elle casse la hiérarchie.

### Option trace Pauline — trace indirecte / bordure

Pauline fonctionne moins bien en trace optionnelle directe.

Pourquoi :

- elle ramène vite le contrôle, la photo et la surveillance ;
- elle risque de réinjecter de la structure sociale là où J8 doit rester bref ;
- elle tire le jour vers une dynamique de preuve ou d’observation trop lisible.

### Recommandation

Ne pas retenir de troisième scène par défaut.

Si une micro-trace est vraiment indispensable, choisir Sandra, pas Pauline, et la limiter à une respiration très courte, sans choix complexe, sans nouvelle photo, sans flag, sans content_id.

## Character presence map

| Personnage | Présence J8 | Fonction | Limite |
|---|---|---|---|
| Raphaëlle | active principale | Clarté concrète, limite lisible, recentrage | Pas de refuge, pas de thérapie, pas de romance alternative |
| Marie | active secondaire | Contrepoint émotionnel du couple | Pas de confrontation finale, pas d’omniscience, pas de jalousie lourde |
| Sandra | silence actif / trace optionnelle | Rappel de retenue ou d’absence | Ne pas relancer “plus tard”, ne pas ouvrir une vraie scène |
| Pauline | trace indirecte | Contrôle de bordure, photos déjà existantes, observation lointaine | Pas de scène directe forte, pas de preuve nouvelle, pas d’omniscience |
| Mathilde | hors centre | Hors-champ domestique, pas de pivot du jour | Ne pas rouvrir le triangle domestique |
| Nico | absent | Aucun moteur narratif utile pour J8 | Ne pas réactiver le bruit social |

## SMS rhythm rules for J8

| Règle | Application J8 |
|---|---|
| Maximum 3 messages personnage avant réponse Player | Viser 2 à 3, jamais une longue rafale |
| Une bulle = une idée | Chaque message doit porter un seul mouvement |
| Choix Player courts | Réponses concrètes, 3 à 8 mots si possible |
| Pas de mini-thèse | Aucun choix qui ressemble à une analyse |
| Pas de panel | Deux axes seulement, le reste en bordure |
| Pas d’exposition | Ne pas expliquer le sous-texte à haute voix |

## Proofs, photos, and route state

J8 peut mentionner des traces existantes, mais ne doit pas en ajouter de nouvelles.

- Nouvelle preuve définitive : non
- Nouvelle photo : non
- Nouveau content_id : non
- Nouveau flag : non
- Route lock : non
- Nouveau système state/memory : non
- Confrontation finale : non

Lecture utile : J8 met à plat, il n’ouvre pas une nouvelle couche de preuve.

## What J8 must avoid

| Risque | Interdit concret | Pourquoi |
|---|---|---|
| Panel | Faire parler tout le monde | Ça recrée l’effet J7 et casse la hiérarchie |
| Raphaëlle refuge | En faire une cachette émotionnelle | Le jour perd sa fonction de clarté |
| Marie confrontation | La transformer en verdict final | Le couple se ferme trop tôt |
| Sandra disponibilité | Rouvrir le motif “plus tard” | La retenue disparaît et le jour s’alourdit |
| Pauline omnisciente | Lui donner une scène directe de contrôle | Le contrôle reprend le dessus sur la respiration |
| Nouvelle preuve | Ajouter une preuve forte ou une nouvelle photo | J8 doit clarifier, pas escalader |

## Runtime preparation notes

- Si J8 devient un jour runtime plus tard, garder la structure courte et hiérarchisée.
- Ne pas convertir cette note en nouveau système.
- Ne pas activer de nouvelles données tant que J8 n’est pas validé comme jour court.
- Si une trace optionnelle est retenue plus tard, elle doit rester inférieure en intensité aux deux scènes principales.
- Toute intégration future doit préserver la respiration du bloc J5-J7 au lieu d’ajouter une cinquième journée dense.

## Non-goals

- No runtime patch in V0.40.
- No game/data modification.
- No index modification.
- No chapter_08_index.json.
- No chapter_08 runtime file.
- No JSON conversation.
- No full dialogue draft.
- No route lock.
- No new photo.
- No new content_id.
- No new flag.
- No new proof.
- No confrontation finale.
- No tests/tool changes.
- No reports generated.

## Recommendation

**Option A — Beat sheet J8 validable avec 2 scènes seulement : Raphaëlle + Marie.**

Pourquoi :

- J6 montre qu’un jour hiérarchisé respire mieux qu’un jour réparti.
- J7 montre le risque d’un équilibre trop stable entre quatre voix.
- J8 doit casser cet équilibre, pas le reproduire sous une autre forme.
- Raphaëlle donne la clarté, Marie donne le coût émotionnel ; ensemble, elles suffisent à rendre le jour lisible.
- Ajouter une troisième scène, même courte, réintroduit facilement le réflexe de panel.

Sandra reste la seule candidate possible pour une micro-trace, mais seulement si une respiration finale devient vraiment indispensable. Par défaut, on ne la retient pas.

## Next recommended step

Ne pas créer de runtime J8 maintenant.

Utiliser ce beat sheet comme base de cadrage seulement, puis attendre une demande explicite avant toute traduction en `chapter_08_*` ou en index runtime.