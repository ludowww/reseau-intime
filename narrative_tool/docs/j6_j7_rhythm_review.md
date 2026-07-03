# J6/J7 Rhythm Review

## Purpose

Revue documentation-only du rythme SMS de J6/J7 après stabilisation de J5.

Objectif produit : vérifier si J6 et J7 respirent correctement, repérer les risques de monologue / panel / choix Player trop abstraits, puis décider s’il faut un micro-patch ciblé ou stabiliser avant J8.

## Current baseline

- Branche de travail : `work/j6-j7-rhythm-review-v0-38`
- Baseline validée : `main / origin/main @ 8d29038`
- Périmètre : documentation-only
- Runtime non modifié
- `game/data/` non modifié

## Sources inspected

### Revue J5 / méthode SMS

- `narrative_tool/docs/j5_j8_narrative_arc_character_rhythm_reassessment.md`
- `narrative_tool/docs/j5_sms_rewrite_method_runtime_integration_plan.md`
- `narrative_tool/docs/j5_sms_runtime_review_after_pauline_sandra_rewrite.md`

### Runtime J6

- `game/data/conversations/chapter_06_index.json`
- `game/data/conversations/chapter_06_mathilde_trace.json`
- `game/data/conversations/chapter_06_marie_morning.json`
- `game/data/conversations/chapter_06_pauline_kept_photos.json`
- `game/data/conversations/chapter_06_sandra_later_echo.json`
- `game/data/conversations/chapter_06_raphaelle_clarity.json` — présent mais **non actif dans l’index**

### Runtime J7

- `game/data/conversations/chapter_07_index.json`
- `game/data/conversations/chapter_07_mathilde_too_close.json`
- `game/data/conversations/chapter_07_marie_senses_difference.json`
- `game/data/conversations/chapter_07_sandra_lamp_soft.json`
- `game/data/conversations/chapter_07_pauline_less_theoretical.json`

### Runtime contexte

- `game/data/visual_content/`
- `game/data/state/initial_state.json`

### Docs d’écriture / rythme / arcs

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
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`

### Story state summaries

- `docs/story_state/J1_SUMMARY.md`
- `docs/story_state/J2_SUMMARY.md`
- `docs/story_state/J3_SUMMARY.md`
- `docs/story_state/J4_SUMMARY.md`
- `docs/story_state/J5_SUMMARY.md`
- `docs/story_state/J6_SUMMARY.md` — absent
- `docs/story_state/J7_SUMMARY.md` — absent

### Sources absentes vérifiées sans échec

- `docs/dialogue_tool/` — absent
- `game/narrative_memory/day_06.json` — absent
- `game/narrative_memory/day_07.json` — absent
- `game/narrative_routes/routes_schema.json` — absent

## J5 reference after V0.37

J5 sert de référence de comparaison, mais ce n’est pas encore le modèle le plus resserré du bloc.

Constat de la revue J5 après V0.37 :

- J5 respire mieux qu’avant les patches Pauline/Sandra.
- Pauline n’est plus mécaniquement explicative.
- Sandra n’est plus trop disponible.
- La journée reste dense, mais elle est lisible.
- La scène la plus monologique reste `Marie morning`.
- Conclusion J5 : stabiliser, ne plus patcher, passer à J6/J7.

En bref : J5 est acceptable et gelé, mais encore plus large que ce qu’on veut pour un modèle de rythme tardif.

## J6 rhythm review

### Lecture globale

J6 est le jour le plus propre du bloc.

Le runtime J6 est structuré autour d’un acte concret sur la trace, puis de conséquences lisibles : Mathilde pose le geste, Marie en perçoit la portée, Pauline mesure le prix du silence, Sandra clôt sur une honnêteté simple. Le jour tient bien sans devenir une table ronde.

Points de forme relevés :

- 4 threads actifs dans l’index.
- `chapter_06_raphaelle_clarity.json` existe mais n’est pas actif dans l’index : à noter, mais pas à compter dans le rythme actif.
- J6 a une hiérarchie claire.
- Le seul vrai pic de monologue reste `Marie sent une position`.

### Matrice J6

| Scène J6 | Rôle narratif | Rythme SMS actuel | Risque restant | Recommandation |
|---|---|---|---|---|
| `chapter_06_mathilde_trace.json` | Acte concret sur la trace, décision de garde/suppression/assumption | 22 messages, 10 messages avant la première réponse Player, 4 choix | Une ou deux réponses Player restent longues ; légère tendance à la mini-thèse | Garder tel quel ; si futur patch, raccourcir un seul choix |
| `chapter_06_marie_morning.json` | Counterweight émotionnel ; Marie sent la position prise par Player | 24 messages, 12 messages avant la première réponse Player, 4 choix | Scène la plus monologique de J6 ; plusieurs choix lisibles comme mini-thèses | Garder ; si un micro-patch futur existe, il viserait d’abord cette scène |
| `chapter_06_pauline_kept_photos.json` | Pression / mesure / contrôle sans climax | 15 messages, 6 messages avant la première réponse Player, 3 choix | Léger risque de sur-expliciter le “prix du silence” | Garder |
| `chapter_06_sandra_later_echo.json` | Clôture honnête, retenue, manque mis en forme courte | 15 messages, 6 messages avant la première réponse Player, 3 choix | Un choix Player est un peu long, mais la scène reste compacte | Garder |
| `chapter_06_raphaelle_clarity.json` *(hors index)* | Test de clarté / refus de refuge pratique | 21 messages, 6 messages avant la première réponse Player, 4 choix | Non actif dans l’index : ne pas le compter comme rythme J6 actif | Ne pas activer ; garder comme référence read-only |

### Conclusion J6

- J6 respire mieux que J5 : oui.
- J6 reste le meilleur modèle de rythme SMS tardif : oui.
- J6 peut servir de référence de hiérarchie pour le bloc : oui.
- Le risque principal est la longueur de `Marie morning`, pas un problème structurel global.

## J7 rhythm review

### Lecture globale

J7 est propre, lisible et SMS-compatible, mais plus plat que J6.

Le jour enchaîne quatre scènes nettes : proximité domestique avec Mathilde, perception de différence avec Marie, désir doux avec Sandra, observation contrôlée avec Pauline. C’est cohérent, mais ça donne davantage une journée de conséquence distribuée qu’un tournant hiérarchisé.

### Matrice J7

| Scène J7 | Rôle narratif | Rythme SMS actuel | Risque restant | Recommandation |
|---|---|---|---|---|
| `chapter_07_mathilde_too_close.json` | Ouverture domestique trop proche pour rester théorique | 31 messages, 3 messages avant la première réponse Player, 4 choix | Un choix Player à 183 caractères ; Mathilde prend beaucoup de place | Garder ; si un micro-patch futur vise J7, c’est la première scène à compresser |
| `chapter_07_marie_senses_difference.json` | Marie lit une différence sans téléphone ni grand concept | 25 messages, 3 messages avant la première réponse Player, 4 choix | Un choix flirte avec la jalousie, mais la scène reste nette | Garder |
| `chapter_07_sandra_lamp_soft.json` | Désir doux, retenue, absence d’escalade | 16 messages, 2 messages avant la première réponse Player, 3 choix | Peut devenir trop disponible si on l’allonge ; ici ce n’est pas le cas | Garder |
| `chapter_07_pauline_less_theoretical.json` | Observation courte, contrôlée, presque sèche | 17 messages, 2 messages avant la première réponse Player, 3 choix | Peut paraître un peu terse, mais le rythme est bon | Garder |

### Conclusion J7

- J7 respire correctement : oui.
- J7 reste le jour le plus surveillable pour l’effet panel : oui.
- J7 a un bon rythme SMS, mais une hiérarchie plus faible que J6 : oui.
- J7 n’est pas cassé ; il est simplement plus équilibré que focalisé.

## J6 vs J7 comparison

| Jour | Axe principal | Personnages actifs | Risque monologue | Risque panel | Recommandation |
|---|---|---|---|---|---|
| J6 | Trace concrète + conséquence émotionnelle | Mathilde, Marie, Pauline, Sandra ; Raphaëlle hors index | Moyen, concentré sur `Marie morning` | Faible | J6 reste le meilleur modèle de rythme tardif |
| J7 | Proximité domestique + lecture de différence + désir retenu + contrôle | Mathilde, Marie, Sandra, Pauline | Faible à moyen, surtout sur la scène Mathilde | Moyen | J7 reste stable, mais c’est le jour à surveiller pour le panel |

Lecture synthétique :

- J6 est plus hiérarchisé.
- J7 est plus uniforme.
- J6 montre mieux une action et ses conséquences.
- J7 montre mieux une journée de réactions, mais avec un poids assez réparti.

## Character balance review

- **Mathilde** : devient très présente sur deux jours d’affilée, mais la fonction change suffisamment entre J6 et J7 pour que cela reste défendable. À surveiller si le bloc s’étire.
- **Pauline** : reste présente après J5, mais sans monopoliser ; elle est pression en J6, contrôle court en J7. Pas de saturation immédiate.
- **Sandra** : garde assez d’absence et de retenue. J6 est honnête sans la rendre disponible ; J7 la maintient douce et mesurée.
- **Marie** : reste le pivot émotionnel sans saturer l’ensemble. Sa scène J6 est la plus bavarde ; c’est un point d’attention, pas une crise.
- **Raphaëlle** : son absence en J7 sert le rythme. En J6, le fichier existe mais n’est pas indexé ; cela doit rester un hors-champ, pas un ajout automatique.

## Remaining risks

| Priorité | Jour/scène | Risque | Type de correction éventuelle | Urgence |
|---|---|---|---|---|
| 1 | J6 / `chapter_06_marie_morning.json` | Burst long avant réponse Player + choix un peu mini-thèse | Compression légère de 2-3 messages et d’un choix | Moyenne, mais pas immédiate |
| 2 | J7 / `chapter_07_mathilde_too_close.json` | Un choix Player trop long, risque de mini-thèse | Raccourcir un seul choix pour retrouver une courbe plus SMS | Moyenne |
| 3 | J7 global | Effet panel par équilibre trop stable entre quatre threads | Donner une priorité plus nette à une seule scène si J7 devait être retravaillé | Faible à moyenne |
| 4 | J6 / `chapter_06_raphaelle_clarity.json` | Fichier présent mais non indexé ; risque de confusion si activé trop tôt | Le garder read-only, ne pas le brancher à l’index | Faible |

## Recommendation

**Option A — J6/J7 sont suffisamment stabilisés, préparer J8 narrative_tool.**

### Pourquoi

- J6 est déjà un bon modèle de rythme SMS tardif : acte concret, conséquence lisible, hiérarchie claire.
- J7 n’est pas cassé ; il est juste un peu trop équilibré pour être le jour le plus fort du bloc.
- Les risques restants sont localisés, pas structurels.
- Le bloc ne justifie pas une réécriture plus large avant J8.

### Pourquoi pas un patch maintenant

- J6 a surtout un pic de longueur, pas une erreur de structure.
- J7 a surtout un effet de répartition, pas un effondrement narratif.
- Le meilleur usage du temps est de préparer J8 comme respiration / recentrage, pas de rouvrir le runtime J6/J7.

## Non-goals

- No runtime patch in V0.38.
- No game/data modification.
- No index modification.
- No scene rewrite.
- No prototype modification.
- No route lock.
- No new photo.
- No new content_id.
- No new flag.
- No tests/tool changes.
- No direct preparation of J8 runtime.

## Next recommended step

Stabiliser J6/J7 tels quels et produire la note narrative_tool de suivi pour J8 : J8 doit casser l’effet panel potentiel, pas prolonger le même équilibre.
