# Day 09 Scene Drafts

## Purpose
Créer des brouillons narratifs SMS J9 en documentation-only, lisibles avant toute intégration runtime.
J9 doit relancer Sandra après la respiration de J8, garder Marie en contrepoint optionnel, et laisser Pauline en trace indirecte seulement.

## Locked references
- Base vérifiée au départ : `main / origin/main @ 5f4a908`
- Tag de départ : `v0.48-j9-beat-sheet`
- `narrative_tool/drafts/day_09_beat_sheet.md`
- `narrative_tool/docs/j9_narrative_direction.md`
- `docs/writing/EMOJI_INTIMACY_EVOLUTION_RULES.md`
- `docs/writing/dialogue_authoring_tools.md`
- `docs/writing/characters/VOICE_PROFILES.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- `docs/story_state/J5_SUMMARY.md`
- `game/data/conversations/chapter_05_sandra_later.json`
- `game/data/conversations/chapter_08_marie_counterpoint.json`
- Absence vérifiée : `chapter_09_index.json`, `chapter_09_*.json`, `chapter_09_proofs.json`, `day_09.json`, `routes_schema.json`, `J9_SUMMARY.md`

## Draft status
- Documentation-only : oui
- Runtime J9 : absent
- Modif `game/data/` : non
- Index J9 : non
- Proof runtime : non
- Content_id inventé : non
- Flag inventé : non
- Route lock : non
- Reports conservés : non
- Lecture outil narratif : context packs lancés pour Sandra et Marie

## Global SMS rhythm rules
- Maximum 3 messages du même personnage avant Player.
- Une bulle = une idée.
- Choix Player courts : 3 à 9 mots.
- Pas de mini-thèse Player.
- Pas de longs monologues.
- Pas de confession lourde.
- Pas de bascule sexuelle directe.
- Pas de confrontation.
- Pas de route lock.
- Pas de proof définitif.
- Le style reste naturel, concret, humain, avec sous-texte plutôt qu’explication.

## Visual content placeholders for later
- `[VISUAL_INTENT: J9 Sandra photo — photo douce / prétexte concret / relationnelle / non proof]`
- `[VISUAL_INTENT: J9 Marie daily photo — trace domestique / couple visible / non proof]`
- `[VISUAL_INTENT: J9 Pauline indirect trace — story floue / social weak trace / non proof]`

## Scene 1 — Sandra / relance du manque

### Function
Relancer Sandra après J8 sans la rendre disponible.
Faire sentir le manque, garder la prudence, faire monter le trouble sans confession lourde, et laisser une possibilité de se reparler ou de se revoir.

### Visual intent
Prétexte concret : photo retrouvée, souvenir du déjeuner, trace oubliée, détail qui revient.
La photo Sandra reste une intention narrative douce, relationnelle, non proof.

### Emoji direction
Sandra : emojis rares, surtout `🙂` ou `😅` comme masque de gêne ou de phrase trop vraie.
Pas d’uniformisation. Pas de jeu trop léger trop tôt.

### Full SMS draft
Sandra: J’ai retrouvé la photo du déjeuner.
Sandra: Celle où tu fais semblant d’être très concentré.
Sandra: Je ne sais pas pourquoi elle m’a fait rire.

[VISUAL_INTENT: J9 Sandra photo — photo douce / prétexte concret / relationnelle / non proof]

Choice 1 — Player
- Tu l’as retrouvée où ?
- Je m’en souviens très bien.
- Tu fais exprès, là.

Sandra: Un peu.
Sandra: J’avais gardé ton air sérieux.
Sandra: Et le mien un peu trop.

Player: Ça te gêne ?
Sandra: Oui.
Sandra: Un peu.
Sandra: Mais pas comme tu crois.

Choice 2 — Player
- Alors comme quoi ?
- Dis-moi sans détour.
- Je prends le risque.

Sandra: Comme un détail qui reste.
Sandra: Comme si le repas n’avait pas fini.
Sandra: Comme si toi non plus.

Player: C’est dangereux, ça.
Sandra: C’est surtout embarrassant 😅
Sandra: Et toi, tu réponds trop vite.

Choice 3 — Player
- Parce que tu m’appelles.
- Parce que je n’avais pas oublié.
- Parce que j’aime quand tu reviens.

Sandra: Voilà.
Sandra: Là, tu forces un peu.
Sandra: Mais juste assez pour que ce soit vrai.

Player: Je peux être plus prudent.
Sandra: Oui.
Sandra: Fais ça.
Sandra: Et garde la photo pour plus tard.

Player: Plus tard, donc ?
Sandra: Je n’ai pas dit “jamais”.
Sandra: Je te laisse choisir la suite.

### Choice map
- Moment 1 : tester le prétexte photo sans casser la retenue.
- Moment 2 : faire émerger la phrase trop vraie sans bascule lourde.
- Moment 3 : laisser Player assumer un trouble léger sans promesse.

### Exit state
Player a envie de revoir / réentendre Sandra.
Sandra est touchée mais prudente.
Une possibilité de se reparler ou de se revoir existe.
Rien n’est verrouillé.
Aucune promesse explicite.

### Review notes
- Le mouvement reste banal → gêne → phrase trop vraie → esquive → relance douce.
- Sandra garde une sortie et ne devient pas disponible.
- Les choix restent courts et sendables.
- La photo reste relationnelle, douce, non proof.
- La scène tient en SMS lisible sans monologue.

## Optional Scene 2 — Marie / coût indirect
Optional — use only if the couple needs to remain emotionally visible.

### Function
Rappeler que Player a une vie de couple.
Ne pas transformer Marie en obstacle.
Faire sentir un coût émotionnel discret.
Garder Marie humaine, tendre, un peu fatiguée.

### Visual intent
Prétexte concret : message domestique, fatigue, photo quotidienne, détail de présence/absence, petit geste de couple.

### Emoji direction
Marie : `🙂 / 🙄 / 😅` modérés, ou absence assumée si la fatigue porte mieux la phrase.

### Full SMS draft
Marie: J’ai racheté du pain.
Marie: L’autre était sec.
Marie: J’ai pensé à toi en le prenant 🙂

[VISUAL_INTENT: J9 Marie daily photo — trace domestique / couple visible / non proof]

Choice 1 — Player
- Merci.
- T’avais raison.
- Je reviens vite.

Marie: Oui.
Marie: C’est ça le problème.
Marie: Tu dis souvent ça.

Player: Je peux faire mieux.
Marie: Je sais.
Marie: Je te le demande sans grand discours.

Choice 2 — Player
- Je reste avec toi.
- Je t’écoute vraiment.
- Je coupe l’écran.

Marie: Voilà.
Marie: Là, c’est plus simple.
Marie: Et moi, j’aime mieux le simple.

Player: On se voit ce soir ?
Marie: Peut-être.
Marie: Mais pas pour réparer vite.
Marie: Juste pour être là.

### Choice map
- Moment 1 : présence simple, sans mensonge lourd.
- Moment 2 : compensation maladroite ou écoute réelle.

### Exit state
Marie existe encore comme lien vivant.
Le couple reste incarné.
Le coût de Sandra est sensible mais indirect.
Pas de reproche frontal.

### Review notes
- Marie reste affective, lucide, domestique.
- Le détail du pain porte le sous-texte sans confrontation.
- Le contrepoint reste bref et ne vole pas l’axe Sandra.
- L’option doit rester facultative si elle affaiblit le centre Sandra.

## Indirect Pauline trace
Propositions possibles, sans scène directe :
1. story floue qui rappelle qu’elle regarde sans s’ouvrir.
2. photo sociale faible, déjà un peu décalée, sans preuve nette.
3. commentaire indirect qui garde le monde vivant sans ouvrir un fil complet.

Placeholder possible :
- `[VISUAL_INTENT: J9 Pauline indirect trace — story floue / social weak trace / non proof]`
- ou `[VISUAL_INTENT: J9 Sandra second texture — seconde photo douce / non proof]`

## What must remain unresolved
- Sandra n’est pas acquise.
- Marie n’est pas confrontée.
- Pauline ne révèle rien.
- Raphaëlle ne revient pas.
- Mathilde n’est pas ajoutée pour remplir.
- Nico ne disperse pas la journée.
- Aucun proof définitif n’existe.
- Aucun choix ne verrouille une route.
- Aucun contenu adulte explicite.

## Runtime integration notes for later
V0.49 ne crée aucun runtime.
Les drafts devront être validés avant toute intégration.
Les futurs fichiers possibles, seulement après validation :
- `chapter_09_index.json` ;
- conversation Sandra ;
- micro-conversation Marie optionnelle ;
- fichier proof/visual content si la structure visuelle est validée.

Les futurs `content_id` seront nommés uniquement lors de l’intégration runtime.
Ne pas les inventer dans V0.49.

## Review checklist
- [ ] Sandra reste-t-elle l’axe principal ?
- [ ] La scène Sandra relance-t-elle le manque sans la rendre acquise ?
- [ ] La photo Sandra est-elle douce / relationnelle / non proof ?
- [ ] Les choix Player sont-ils courts ?
- [ ] Aucun choix n’est-il une confession lourde ?
- [ ] Aucun choix ne crée-t-il une bascule sexuelle directe ?
- [ ] Marie reste-t-elle optionnelle ?
- [ ] Marie est-elle un contrepoint, pas une confrontation ?
- [ ] Pauline reste-t-elle indirecte ?
- [ ] Raphaëlle repose-t-elle ?
- [ ] Mathilde et Nico sont-ils absents ?
- [ ] Les emojis sont-ils présents là où la voix le justifie ?
- [ ] L’absence d’emoji est-elle assumée si utilisée ?
- [ ] Les visuels restent-ils soft / relationnels / non définitifs ?
- [ ] Aucun content_id n’est-il inventé ?
- [ ] Aucun runtime n’est-il créé ?

## Recommendation
Recommendation: validate Scene 1 Sandra first.
Use Optional Scene 2 Marie only if the next runtime integration needs to keep the couple emotionally visible.
Do not add a third active scene.
Keep Pauline as indirect trace only.
