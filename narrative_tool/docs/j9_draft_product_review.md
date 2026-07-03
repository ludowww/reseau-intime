# J9 Draft Product Review

## Purpose
Relire les drafts J9 avant toute intégration runtime.
Vérifier le naturel SMS, la tension Sandra, le caractère optionnel de Marie, les emojis, les choix courts, les visuels placeholders et les garde-fous.
Identifier seulement les micro-ajustements éventuels avant runtime.

## Reviewed baseline
- Branche de travail : `work/j9-draft-product-review-v0-50`
- SHA : `ff0f6b1`
- État git au départ : propre
- Base indiquée au prompt : `main / origin/main @ ff0f6b1`
- Tag de départ indiqué : `v0.49-j9-scene-drafts`
- Périmètre de cette V0.50 : documentation-only

## Reviewed files
### Drafts / direction
- `narrative_tool/drafts/day_09_scene_drafts.md`
- `narrative_tool/drafts/day_09_beat_sheet.md`
- `narrative_tool/docs/j9_narrative_direction.md`

### Writing / story-state sources
- `docs/writing/EMOJI_INTIMACY_EVOLUTION_RULES.md`
- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/story_state/J5_SUMMARY.md`

### Runtime comparison sources
- `game/data/conversations/chapter_05_sandra_later.json`
- `game/data/conversations/chapter_08_marie_counterpoint.json`

### Narrative tools launched
- `python3 tools/dialogue_context_pack.py --character sandra --day 9 --stage stage_3_intimite_naissante --risk medium`
- `python3 tools/dialogue_context_pack.py --character marie --day 9 --stage stage_2_complicite --risk medium`

## Product verdict
validated with minor notes

## Sandra scene review
- Sandra est bien l’axe principal : oui.
- Le prétexte photo est naturel : oui, la photo du déjeuner/retrouvée reste relationnelle et concrète.
- Le manque revient sans rendre Sandra disponible : oui.
- Le trouble monte sans confession lourde : oui.
- Sandra garde une sortie : oui, la fermeture reste ouverte et prudente.
- Les choix Player restent courts : oui.
- La fin ouvre une envie sans promesse : oui.
- Le 😅 est bien placé : oui, il masque la gêne au bon moment.

Points de vigilance :
- la formulation de la troisième montée peut encore sembler un peu trop “bien écrite” si on la pousse davantage ;
- `Parce que j’aime quand tu reviens.` est la seule option qui doit rester sous surveillance, car elle monte vite en charge affective.

## Marie optional scene review
- Marie est bien optionnelle : oui.
- La scène reste courte : oui.
- Le détail domestique porte le sous-texte : oui.
- Marie reste humaine, affective, fatiguée : oui.
- Marie devient obstacle moral : non.
- La scène vole l’axe Sandra : non.
- Le 🙂 est bien placé : oui.

Lecture produit : le contrepoint garde le couple visible sans réorienter J9 vers la réparation.

## Pauline indirect trace review
- Pauline reste indirecte : oui.
- Les traces proposées restent faibles : oui.
- Le troisième visuel peut exister sans ouvrir une scène : oui.
- Risque de proof trop fort : faible si la trace reste textuelle / sociale / douce.
- Risque de Pauline omnisciente : faible à surveiller, mais pas activé dans les drafts.

## Visual placeholder review
- 3 visuels minimum restent planifiés : oui.
- 1 photo Sandra est obligatoire : oui.
- Aucun content_id n’est inventé : oui.
- Aucun nom de fichier asset n’est inventé : oui.
- Les visuels sont soft / relationnels / non proof : oui.
- La photo Sandra nourrit le manque : oui.
- La photo Marie garde le couple visible : oui.
- La trace Pauline ou seconde texture Sandra garde le téléphone vivant sans panel : oui.

## Emoji and phone-language review
Les palettes restent différenciées et cohérentes avec les profils.

Sandra 😅 : validé.
Marie 🙂 : validé.

Notes :
- Sandra reste rare / retenue, avec le bon niveau de gêne.
- Marie reste modérée, sans uniformisation mécanique.
- L’absence d’autres emojis est acceptable si elle sert la retenue ou le rythme.
- Le téléphone paraît vivant sans surjouer la couleur emoji.

## SMS rhythm review
- Maximum 3 messages du même personnage avant Player : respecté.
- Une bulle = une idée : respecté.
- Choix Player courts : respecté.
- Pas de mini-thèse Player : respecté.
- Pas de longs monologues : respecté.
- Longueur des messages variée : oui.
- Rythme lisible : oui.
- Pas de style trop littéraire : globalement oui, avec une légère surveillance sur la dernière relance Sandra.

## Choice review

### Sandra Choice 1
- Fonction : tester le prétexte photo sans casser la retenue.
- Naturel : oui.
- Longueur : bonne.
- Risque : faible.
- Meilleure option éventuelle : `Tu l’as retrouvée ?` si on voulait encore plus sec, mais ce n’est pas nécessaire.
- Option à surveiller : `Tu fais exprès, là.` parce qu’elle peut tirer vers le taquin trop tôt.

### Sandra Choice 2
- Fonction : faire émerger la phrase trop vraie.
- Naturel : oui.
- Longueur : bonne.
- Risque : moyen, car ça monte la tension vite.
- Meilleure option éventuelle : aucune urgente.
- Option à surveiller : `Je prends le risque.` qui est un peu plus déclaratif que le reste.

### Sandra Choice 3
- Fonction : laisser Player assumer un trouble léger sans promesse.
- Naturel : oui, mais le plus risqué des trois.
- Longueur : bonne.
- Risque : moyen à surveiller, car la charge affective est plus frontale.
- Meilleure option éventuelle : `Parce que je réponds.` si on voulait réduire la coloration romantique.
- Option à surveiller : `Parce que j’aime quand tu reviens.`

### Marie Choice 1
- Fonction : présence simple, sans mensonge lourd.
- Naturel : oui.
- Longueur : parfaite.
- Risque : faible.
- Meilleure option éventuelle : aucune.
- Option à surveiller : `Merci.` si on veut éviter un ton trop court / sec selon la mise en bouche.

### Marie Choice 2
- Fonction : compensation maladroite ou écoute réelle.
- Naturel : oui.
- Longueur : bonne.
- Risque : faible.
- Meilleure option éventuelle : aucune.
- Option à surveiller : `Je coupe l’écran.` si on veut garder un ton plus organique et moins “déclaratif bien formulé”.

## Continuity review
Cohérence avec la continuité validée :
- J5 Sandra : photo / plus tard / retenue / photo supprimée / prudence — cohérent.
- J8 : respiration Raphaëlle + Marie — cohérent, J9 ne casse pas ce recentrage.
- J9 : Sandra revient après absence sans casser J8 — cohérent.
- Marie : couple vivant, pas obstacle — cohérent.
- Pauline : trace indirecte seulement — cohérent.

Lecture globale : J9 prolonge bien la hiérarchie de J8 sans réouvrir un panel.

## Runtime readiness
Ready for runtime integration : yes with minor notes

Conditions :
- Scene 1 Sandra validated first : oui.
- Optional Marie scene needed : seulement si le couple doit rester visiblement dans le champ.
- Visual structure validated : oui, en mode placeholder soft.
- Content_id naming deferred : oui.
- Proof/visual file deferred : oui.

## Issues found
### Blocking issues
Blocking issues: none.

### Minor issues
- Sandra Choice 3 est un peu plus déclaratif que le reste du draft.
- La dernière relance Sandra garde une petite tension “écrite” à surveiller si on densifie.

### Watch points
- Ne pas laisser Marie prendre trop d’espace si l’option est gardée.
- Ne pas durcir le prétexte photo vers un signal proof.
- Ne pas rendre les emojis trop uniformes si un futur runtime reprend ces drafts presque tels quels.

## Recommended micro-adjustments
| Priority | Target | Suggestion | Reason |
|---|---|---|---|
| P1 recommended before runtime | Sandra Choice 3 | Réduire légèrement la charge affective si le runtime final veut rester plus retenu. | Évite un basculement trop vite explicite. |
| P2 optional polish | Dernière relance Sandra | Simplifier très légèrement la phrase si elle paraît trop “écrite” une fois mise en jeu. | Garde le naturel SMS. |
| P2 optional polish | Marie Choice 2 | Vérifier la lecture tonale en contexte si on veut une Marie plus quotidienne. | Évite une formulation un peu trop nette. |

## What must not change
- Sandra remains main axis.
- Marie remains optional.
- Pauline remains indirect.
- Raphaëlle remains resting.
- Mathilde and Nico remain absent.
- No third active scene.
- No definitive proof.
- No adult explicit content.
- No route lock.
- No content_id invented before runtime integration.
- No runtime in V0.50.

## Review checklist
- [x] Sandra is the main axis.
- [x] Sandra is not acquired or too available.
- [x] The photo trigger feels natural.
- [x] Player choices are short.
- [x] No heavy confession.
- [x] No direct sexual shift.
- [x] Marie remains optional.
- [x] Marie does not become a moral obstacle.
- [x] Pauline remains indirect.
- [x] Raphaëlle rests.
- [x] Mathilde and Nico are absent.
- [x] Visuals remain placeholders only.
- [x] No content_id is invented.
- [x] Emojis are minimal and justified.
- [x] SMS rhythm is readable.
- [x] Runtime integration is not created.

## Recommendation
Recommendation: validate V0.49 draft as runtime-ready with minor notes.
Next step should be runtime integration planning, not direct runtime integration, unless the product owner explicitly approves the visual placeholder structure and the Sandra-first order.
